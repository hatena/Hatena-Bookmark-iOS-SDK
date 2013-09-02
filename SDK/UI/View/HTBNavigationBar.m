//  HTBNavigationBar.m
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

#import "HTBNavigationBar.h"
#import "HTBUtility.h"
#import "HTBMacro.h"

@implementation HTBNavigationBar

+(void)initialize
{
    if (HTB_IS_RUNNING_IOS7) { // for iOS7, navigation bars are not applyed appearance.
        return;
    }
    
    NSString *resourcePath = [[HTBUtility hatenaBookmarkSDKBundle] resourcePath];

    [[self appearance] setTitleTextAttributes:@{
        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeTextShadowColor : [UIColor darkGrayColor],
    }];

    [[self appearance] setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/header-background.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/header-button.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/header-button-push.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/back-button.png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/back-button_on.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/header-button-landscape.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/header-button-push-landscape.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/back-button-landscape.png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/back-button-push-landscape.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
}

@end
