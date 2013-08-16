PROJECT = HatenaBookmarkSDKTests/HatenaBookmarkSDKTests.xcodeproj
SCHEME = HatenaBookmarkSDKTests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk iphonesimulator \
		TEST_AFTER_BUILD=YES \
		ONLY_ACTIVE_ARCH=NO \
		TEST_HOST=
