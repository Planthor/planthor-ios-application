#!/usr/bin/env bash
set -euo pipefail

environment=""
version=""
commit=""
branch=""
actor=""
timestamp=""
manifest="release-manifest.json"
prepare_only="false"

while (($# > 0)); do
  case "$1" in
    --environment) environment="${2:-}"; shift 2 ;;
    --version) version="${2:-}"; shift 2 ;;
    --commit) commit="${2:-}"; shift 2 ;;
    --branch) branch="${2:-}"; shift 2 ;;
    --actor) actor="${2:-}"; shift 2 ;;
    --timestamp) timestamp="${2:-}"; shift 2 ;;
    --manifest) manifest="${2:-}"; shift 2 ;;
    --prepare-only) prepare_only="true"; shift ;;
    *) echo "MOCK: unknown argument '$1'." >&2; exit 2 ;;
  esac
done

case "${environment}" in
  dev | staging | production) ;;
  *) echo "MOCK: environment must be dev, staging, or production." >&2; exit 2 ;;
esac

for required_value in version commit branch actor timestamp; do
  if [[ -z "${!required_value}" ]]; then
    echo "MOCK: --${required_value} is required." >&2
    exit 2
  fi
done

python3 - "${manifest}" "${environment}" "${version}" "${commit}" "${branch}" "${actor}" "${timestamp}" <<'PY'
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
expected = {
    "mode": "mock",
    "platforms": ["android", "ios"],
    "environment": sys.argv[2],
    "version": sys.argv[3],
    "commit": sys.argv[4],
    "branch": sys.argv[5],
    "triggered_by": sys.argv[6],
    "timestamp": sys.argv[7],
    "external_upload_performed": False,
}

if manifest_path.exists():
    actual = json.loads(manifest_path.read_text(encoding="utf-8"))
    if actual != expected:
        raise SystemExit("MOCK: existing release manifest does not match requested metadata.")
else:
    manifest_path.write_text(json.dumps(expected, indent=2) + "\n", encoding="utf-8")
PY

echo "MOCK: release manifest ready at ${manifest}"

if [[ "${prepare_only}" == "true" ]]; then
  exit 0
fi

echo "MOCK: would distribute Android artifact to Firebase App Distribution"
echo "MOCK: would submit Android AAB to Google Play"
echo "MOCK: would build and upload iOS archive through Fastlane"
echo "MOCK: would upload debug symbols to Sentry"
echo "MOCK: no external upload performed"
