## Installs all dependencies
init:
	# Install bundler if not installed
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		-sudo gem install bundler;\
	fi
	-bundle update
	-bundle install --path .bundle
	-bundle exec pod repo update
	-bundle exec pod install

## Run SwiftLint check
lint:
	./Pods/SwiftLint/swiftlint lint --config .swiftlint.yml

## Autocorrect with SwiftLint
format:
	./Pods/SwiftLint/swiftlint autocorrect --config .swiftlint.yml

## Execute pod install command
pod_install:
	-bundle exec pod install
