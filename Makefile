PROJECT = HatenaBookmarkSDK/HatenaBookmarkSDK.xcodeproj
TARGET = HatenaBookmarkSDKTests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TARGET) \
		-sdk iphonesimulator \
		TEST_AFTER_BUILD=YES \
		ONLY_ACTIVE_ARCH=NO \
		TEST_HOST=
