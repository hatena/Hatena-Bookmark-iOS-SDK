# Hatena Bookmark iOS SDK
<a href="https://travis-ci.org/hatena/Hatena-Bookmark-iOS-SDK" target="_blank"><img alt="travis-ci" src="https://travis-ci.org/hatena/Hatena-Bookmark-iOS-SDK.png?branch=master" /></a>

Integrate Hatena Bookmark into your application. This is an Objective-C library for handling the Hatena Bookmark API and for providing a user interface.

<img alt="Main Screenshot" src="http://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenabookmark/20130809/20130809153934.png?1376030463" width="240px" style="width: 240px;" />

# Install

## CocoaPods
Add the lines below to your Podfile.
```
platform :ios, '5.0'

pod 'HatenaBookmarkSDK'
```

## Without CocoaPods

Clone this repository.

```
git clone --recursive https://github.com/hatena/Hatena-Bookmark-iOS-SDK.git
```

Copy `/SDK/` directory and add dependent modules [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone/) to your project .

# Usage

## Register OAuth

Register your app information at [Hatena Developer Center](http://developer.hatena.com/). This SDK needs all scope, read_public, read_private, write_public, write_private.

<img alt="Scope Settings" src="http://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenabookmark/20131204/20131204094841.png?1386118126" width="531px" style="width: 531px;" />

After registration, you will get a consumer key and a consumer secret. 

<img alt="Consumer Key and Consumer Secret" src="http://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenabookmark/20131204/20131204095421.png?1386118494" width="604px" style="width: 604px;" />



## Initialize

At first SDK needs initialization with consumer key and secret. You should add below initalization code at `application:didFinishLaunchingWithOptions:` or other initalize section.

```objc
[[HTBHatenaBookmarkManager sharedManager] setConsumerKey:@"your consumer key" consumerSecret:@"your consumer secret"];
```

## Authorization

The SDK needs to login with OAuth before making a request to the API. Add authorization code your app's settings view.

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebView:) name:kHTBLoginStartNotification object:nil];

[[HTBHatenaBookmarkManager sharedManager] authorizeWithSuccess:^{

} failure:^(NSError *error) {

}];
```

After making an authorization request, the SDK calls kHTBLoginStartNotification with NSURLRequest including the login page URL. You should handle the notification and request with HTBLoginWebViewController.

```objc
-(void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOAuthLoginView:) name:kHTBLoginStartNotification object:nil];
}

-(void)showOAuthLoginView:(NSNotification *)notification {
    NSURLRequest *req = (NSURLRequest *)notification.object;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil];
    HTBLoginWebViewController *viewController = [[HTBLoginWebViewController alloc] initWithAuthorizationRequest:req];
    navigationController.viewControllers = @[viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
```

<img alt="Login Screenshot" src="http://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenabookmark/20130809/20130809154323.png?1376030609" width="240px" style="width: 240px;" />

## Bookmark UI

The SDK provides two ways for integrating the Hatena Bookmark Panel UI.
- HTBHatenaBookmarkActivity
- HTBHatenaBookmarkViewController

### HTBHatenaBookmarkActivity
UIActivity is an iOS native sharing interface, available on iOS 6 or later.
This SDK provides `HTBHatenaBookmarkActivity`.

#### iPhone / iPod touch

You can present a UIActivityViewController modally on iPhone or iPod touch.
```objc
NSURL *URL = self.webView.request.URL;

// iOS 6 or later
if ([UIActivityViewController class]) {
    HTBHatenaBookmarkActivity *hateaBookmarkActivity = [[HTBHatenaBookmarkActivity alloc] init];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[URL]                                                                               applicationActivities:@[hateaBookmarkActivity]];
    [self presentViewController:activityView animated:YES completion:nil];
}
```

<img alt="UIActivity Screenshot" src="http://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenabookmark/20130809/20130809153935.png?1376030507" width="240px" style="width: 240px;" />

#### iPad

Apple official document said that "on iPad, it must be presented in a popover".
```objc
NSURL *URL = self.webView.request.URL;

// iOS 6 or later
if ([UIActivityViewController class]) {
    HTBHatenaBookmarkActivity *hateaBookmarkActivity = [[HTBHatenaBookmarkActivity alloc] init];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[URL]                                                                               applicationActivities:@[hateaBookmarkActivity]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // on iPad
        self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityView];
        __weak UIPopoverController *weakPopover = self.activityPopover;
        activityView.completionHandler = ^(NSString *activityType, BOOL completed){
            // dismiss popover on activity completed.
            [weakPopover dismissPopoverAnimated:YES];
        };
        [self.activityPopover presentPopoverFromBarButtonItem:sender
                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                     animated:YES];
    }
}
```

See `HTBDemoViewController` for detail.

### HTBHatenaBookmarkViewController

You can call ViewController directly.

```objc

// iOS 5
NSURL *URL = self.webView.request.URL;
HTBHatenaBookmarkViewController *viewController = [[HTBHatenaBookmarkViewController alloc] init];
viewController.URL = URL;
[self presentViewController:viewController animated:YES completion:nil];
```

# Build DemoApp

Clone this repository and run `git submodule update --init`. After that, open `/DemoApp/DemoApp.xcodeproj` and build.

Demo app also needs OAuth consumer secret and key. Add to `[[HTBHatenaBookmarkManager sharedManager] setConsumerKey:@"your consumer key" consumerSecret:@"your consumer secret"];` in `HTBDemoViewController`.

# Running Tests

Clone this repository and run `make clean test` in root directory.

# Archtecture
- `/SDK/API/`
 - HTTP request class
- `/SDK/UI/`
 - Some classes related in bookmark panel UI and login
 - `HTBHatenaBookmkarkManager`
  - Core module
  - Handle user login information
  - Dispatch JSON response to model class

# Requirements
- iOS 5.0 or later
- ARC

## Dependency
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
 - Version 1.x
 - Currently 2.0 is not supported because it required iOS 7.
- [AFOAuth1Client](https://github.com/AFNetworking/AFOAuth1Client)
 - Currentry we forked and copied it as HTBAFOAuth1Client for waiting merge some pull requests.
- [SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone/)

# Hatena Bookmark API
iOS SDK interfaces with the Hatena Bookmark API. For more details, see [api docs](http://developer.hatena.ne.jp/ja/documents/bookmark/apis/rest) (In Japanese).

# License
[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
[GPL]: http://www.gnu.org/licenses/gpl.html
[BSD]: http://opensource.org/licenses/bsd-license.php
[MIT license][MIT].
