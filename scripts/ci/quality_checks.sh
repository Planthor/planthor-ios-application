#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "QUALITY: checking Dart formatting"
dart format --output=none --set-exit-if-changed .

echo "QUALITY: running static analysis"
flutter analyze --fatal-infos --fatal-warnings

echo "QUALITY: running tests with coverage"
flutter test --no-pub --coverage

echo "QUALITY: reporting coverage"
"${script_dir}/check_coverage.sh"

echo "QUALITY: all required checks passed"
