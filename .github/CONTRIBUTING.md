# Contributing to Planthor iOS Application

## Local Development & CI Checks

Before pushing changes, run these commands locally to validate your code against the same checks the CI pipeline runs.

### Setup

```bash
flutter pub get
dart format .
```

### Pre-Commit Checks

Run these commands before pushing to ensure CI will pass:

```bash
# 1. Static analysis & linting
flutter analyze

# 2. Unit & widget tests with coverage
flutter test --coverage

# 3. Check coverage meets threshold (70%)
# Coverage report is generated at ./coverage/lcov.info
# You can view a detailed report:
# (On macOS)
open coverage/index.html
# (On Linux)
firefox coverage/index.html
```

### Building Locally

To verify builds work before CI:

```bash
# Android APK (release build)
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release --no-codesign
```

## CI Pipeline Overview

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs on every push to `main` and on all pull requests. It consists of 5 stages:

### Stage 1: Lint & Analyze
- **Job:** `analyze`
- **Command:** `flutter analyze`
- **Purpose:** Catch code style violations and potential bugs
- **Runs on:** Ubuntu (Linux)
- **Gates:** Blocks tests and builds if analysis fails

### Stage 2: Unit & Widget Tests
- **Job:** `test`
- **Command:** `flutter test --coverage`
- **Purpose:** Run all tests and measure code coverage
- **Coverage threshold:** 70% (minimum required to pass)
- **Runs on:** Ubuntu (Linux)
- **Gates:** Blocks Android and iOS builds if tests fail
- **Output:** Coverage report uploaded to Codecov

### Stage 3: Android Build (Matrix)
- **Job:** `build-android`
- **Matrix variants:** `[debug, release]` — tests both build types in parallel
- **Command:** `flutter build apk --[debug|release]`
- **Purpose:** Verify Android APK builds successfully in all configurations
- **Runs on:** Ubuntu (Linux), **after** lint and tests pass
- **Artifacts:** APK for each variant retained for 7 days
- **Parallel jobs:** 2 (debug + release run simultaneously)

### Stage 4: iOS Build (Matrix)
- **Job:** `build-ios`
- **Matrix variants:** `[debug, release]` — tests both build types in parallel
- **Command:** `flutter build ios --[debug|release] --no-codesign`
- **Purpose:** Verify iOS build succeeds in all configurations (without code signing)
- **Runs on:** macOS, **after** lint and tests pass
- **Artifacts:** iOS build output for each variant retained for 7 days
- **Parallel jobs:** 2 (debug + release run simultaneously)

### Stage 5: Success Gate
- **Job:** `ci-success`
- **Purpose:** Confirms all jobs (including all matrix variants) completed successfully
- **Shows on PR:** ✅ status when all checks pass

## Matrix Builds

The CI pipeline uses **matrix strategies** to test multiple build configurations in parallel:

### Android Matrix
- **Variants:** `[debug, release]`
- **Parallel jobs:** 2 simultaneous APK builds
- **Configuration:** Edit `.github/workflows/ci.yml` → `build-android.strategy.matrix.build-type`
- **Extend to:** Add more variants like `profile`, or test multiple Flutter versions

### iOS Matrix
- **Variants:** `[debug, release]`
- **Parallel jobs:** 2 simultaneous iOS builds
- **Configuration:** Edit `.github/workflows/ci.yml` → `build-ios.strategy.matrix.build-type`
- **Extend to:** Add deployment target variations or multiple build schemes

### Benefits of Matrix Builds
- ✅ **Parallel execution**: Debug and release builds run simultaneously (faster feedback)
- ✅ **Comprehensive coverage**: Test multiple configurations without separate jobs
- ✅ **Cost-effective**: Reuse same job logic with different parameters
- ✅ **Easy to scale**: Add new matrix values without duplicating code

### Example: Extending Matrix to Test Multiple Flutter Versions

To test against multiple Flutter versions, update `.github/workflows/ci.yml`:

```yaml
build-android:
  strategy:
    matrix:
      build-type: [debug, release]
      flutter-version: ['latest', '3.22.0']  # Add multiple versions
    fail-fast: false
```

Then update the Flutter setup step:
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: ${{ matrix.flutter-version }}
    channel: 'stable'
```

## Troubleshooting CI Failures

### Lint Failures

**Error:** `flutter analyze` fails with style or lint warnings

**Solution:**
1. Run `flutter analyze` locally to see the full error
2. Fix issues according to `flutter_lints` rules (defined in `analysis_options.yaml`)
3. Use `dart format .` to auto-fix formatting issues
4. Push changes and CI will re-run

### Test Failures

**Error:** `flutter test` fails; coverage below 70%

**Solution:**
1. Run `flutter test --coverage` locally
2. View coverage report: `open coverage/index.html`
3. Add tests to cover uncovered lines
4. Ensure widget tests pass: `flutter test test/widget_test.dart`

### Android Build Failures

**Error:** `flutter build apk --release` fails

**Common causes:**
- Java/Gradle version mismatch (CI uses Java 17, verify `build.gradle.kts`)
- Missing Android SDK dependencies
- Namespace or package name issues

**Solution:**
1. Run `flutter build apk --release` locally
2. Check Java version: `java -version`
3. Update Android build config if needed
4. See [android/app/build.gradle.kts](../android/app/build.gradle.kts)

### iOS Build Failures

**Error:** `flutter build ios --release` fails

**Common causes:**
- Xcode version mismatch (CI uses latest macOS image)
- Pod/dependency issues
- Provisioning profile issues (in CI, we skip code signing)

**Solution:**
1. Run on macOS: `flutter build ios --release --no-codesign`
2. Check Xcode version: `xcode-select --version`
3. Clear pod cache: `cd ios && rm -rf Pods && cd ..`
4. Reinstall: `flutter pub get && flutter clean && flutter pub get`

## Code Coverage & Quality Gates

### Minimum Coverage Threshold

The CI pipeline enforces a **70% code coverage** minimum. This ensures:
- Critical code paths are tested
- Regressions are caught early
- Test suite grows with features

### Viewing Coverage Locally

After running `flutter test --coverage`:

```bash
# Generate HTML report (macOS)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Improving Coverage

- Add widget tests for UI components
- Add unit tests for business logic
- Add integration tests for workflows
- See [test/widget_test.dart](../test/widget_test.dart) for example

## Adding New Tests

When adding features, add corresponding tests:

1. **Widget tests:** `test/features/my_feature_test.dart`
2. **Unit tests:** `test/models/my_model_test.dart`
3. **Integration tests:** `integration_test/my_workflow_test.dart` (optional)

Run tests locally:
```bash
flutter test
```

## Deployment & Production Builds

**Note:** This CI pipeline is for verification only. It does **not** deploy to app stores (TestFlight, Google Play).

For production builds:
- Android: Add signing configuration to `android/app/build.gradle.kts`
- iOS: Add provisioning profiles and certificates

See project maintainers for production release steps.

## Pull Request Checklist

Before submitting a PR:
## SonarCloud Setup (optional)

To enable SonarCloud analysis in CI, add these repository secrets under: Repository → Settings → Secrets and variables → Actions

- `SONAR_TOKEN` — SonarCloud token (Execute Analysis permission)
- `SONAR_ORGANIZATION` — SonarCloud organization key
- `SONAR_PROJECT_KEY` — SonarCloud project key

Create a project at https://sonarcloud.io (choose your organization), then add the three secrets above. The CI workflow will run the `sonar` job after tests and upload the coverage report to SonarCloud.
- ✅ PR description explains the change

## Questions?

Check the [Flutter docs](https://flutter.dev/docs) or ask project maintainers.
