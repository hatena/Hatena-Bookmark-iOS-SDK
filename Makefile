PROJECT = HatenaBookmarkSDKTests/HatenaBookmarkSDKTests.xcodeproj
SCHEME = HatenaBookmarkSDKTests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		test \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk iphonesimulator \
		ONLY_ACTIVE_ARCH=NO \
		TEST_HOST=
