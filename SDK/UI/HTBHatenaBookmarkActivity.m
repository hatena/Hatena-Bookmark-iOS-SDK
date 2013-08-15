//  HTBHatenaBookmarkActivity.m
//
//  Copyright (c) 2013 Hatena Co., Ltd. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "HTBHatenaBookmarkActivity.h"
#import "HTBHatenaBookmarkManager.h"
#import "HTBHatenaBookmarkViewController.h"
#import "HTBUtility.h"

#import "HTBLoginWebViewController.h"
#import "HTBNavigationBar.h"

@implementation HTBHatenaBookmarkActivity {
    NSURL *url;
}

- (NSString *)activityType {
    return @"com.hatena.bookmark.sdk";
}

- (UIImage *)activityImage {
    NSString *imagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/uiactivity-bookmark-icon.png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (NSString *)activityTitle {
    return [HTBUtility localizedStringForKey:@"hatena-bookmark" withDefault:@"Hatena Bookmark"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            NSString *scheme = [(NSURL *)activityItem scheme];
            return [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	NSLog(@"prepareWithActivityItems");
	[super prepareWithActivityItems:activityItems];
	activityItems_ = [activityItems copy];
	
	if (![HTBHatenaBookmarkManager sharedManager].authorized) {
		double delayInSeconds = 1.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[[HTBHatenaBookmarkManager sharedManager] authorizeWithLoginUserInterface:self.presentingViewController success:^{
				NSLog(@"login success");
				[self performActivity];
				double delayInSeconds = 1.0;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					HTBHatenaBookmarkViewController *viewController = [[HTBHatenaBookmarkViewController alloc] init];
					viewController.URL = url;
					[self.presentingViewController presentViewController:viewController animated:YES completion:nil];
				});
			} failure:^(NSError *error) {
				NSLog(@"%@", error.localizedDescription);
			}];
		});
		[self activityDidFinish:YES];
	}
	else {
		[self performActivity];
	}
}

- (UIViewController *)activityViewController {
	HTBHatenaBookmarkViewController *viewController = nil;
	if ([HTBHatenaBookmarkManager sharedManager].authorized) {
		viewController = [[HTBHatenaBookmarkViewController alloc] init];
		viewController.URL = url;
	}
	
	return viewController;
}

- (void)performActivity {
	NSLog(@"performActivity");
	if ([HTBHatenaBookmarkManager sharedManager].authorized) {
		for (id activityItem in activityItems_) {
			if ([activityItem isKindOfClass:[NSURL class]]) {
				NSString *scheme = [(NSURL *)activityItem scheme];
				if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
					url = activityItem;
				}
			}
		}
	}
}

- (void)activityDidFinish:(BOOL)completed {
	[super activityDidFinish:completed];
}

@end
