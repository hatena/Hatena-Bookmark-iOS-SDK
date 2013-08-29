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
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            NSString *scheme = [(NSURL *)activityItem scheme];
            if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
                url = activityItem;
            }
        }
    }
}

- (UIViewController *)activityViewController {
    HTBHatenaBookmarkViewController *viewController = [[HTBHatenaBookmarkViewController alloc] init];
    viewController.URL = url;
    viewController.completionHandler = ^(BOOL completion) {
        [self activityDidFinish:completion];
    };
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController.providesPresentationContextTransitionStyle = NO;
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    return viewController;
}

@end
