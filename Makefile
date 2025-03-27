.PHONY: format analyze clean build

# Format all Dart files
format:
	dart format .

# Run static analysis
analyze:
	dart analyze

# Clean build cache
clean:
	flutter clean

# Build APK (release mode)
build:
	flutter build apk --release