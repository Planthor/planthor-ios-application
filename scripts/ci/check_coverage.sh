#!/usr/bin/env bash
set -euo pipefail

coverage_file="${LCOV_FILE:-coverage/lcov.info}"
coverage_mode="${COVERAGE_MODE:-report-only}"
minimum_coverage="${MIN_COVERAGE:-70}"

case "${coverage_mode}" in
  report-only | enforce) ;;
  *)
    echo "COVERAGE: COVERAGE_MODE must be 'report-only' or 'enforce'." >&2
    exit 2
    ;;
esac

if [[ ! "${minimum_coverage}" =~ ^([0-9](\.[0-9]+)?|[1-9][0-9](\.[0-9]+)?|100)$ ]]; then
  echo "COVERAGE: MIN_COVERAGE must be a number from 0 to 100." >&2
  exit 2
fi

if [[ ! -f "${coverage_file}" ]]; then
  echo "COVERAGE: expected ${coverage_file}, but it does not exist." >&2
  exit 1
fi

read -r lines_found lines_hit < <(
  awk -F: '
    /^LF:/ { found += $2 }
    /^LH:/ { hit += $2 }
    END { printf "%d %d\n", found, hit }
  ' "${coverage_file}"
)

if ((lines_found == 0)); then
  echo "COVERAGE: ${coverage_file} contains no executable lines." >&2
  exit 1
fi

coverage_percentage="$(awk -v hit="${lines_hit}" -v found="${lines_found}" 'BEGIN { printf "%.2f", (hit / found) * 100 }')"
meets_threshold="$(awk -v actual="${coverage_percentage}" -v minimum="${minimum_coverage}" 'BEGIN { print (actual >= minimum ? "yes" : "no") }')"

echo "COVERAGE: ${coverage_percentage}% (${lines_hit}/${lines_found} lines); threshold ${minimum_coverage}%; mode ${coverage_mode}."

if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  echo "Coverage: **${coverage_percentage}%** (${coverage_mode}, threshold ${minimum_coverage}%)." >> "${GITHUB_STEP_SUMMARY}"
fi

if [[ "${meets_threshold}" != "yes" && "${coverage_mode}" == "enforce" ]]; then
  echo "COVERAGE: ${coverage_percentage}% is below the required ${minimum_coverage}%." >&2
  exit 1
fi

if [[ "${meets_threshold}" != "yes" ]]; then
  echo "COVERAGE: below threshold; continuing because report-only mode is active."
fi
