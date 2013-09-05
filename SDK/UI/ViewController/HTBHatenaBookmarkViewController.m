//  HTBRootViewController.m
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

#import "HTBHatenaBookmarkViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HTBNavigationBar.h"
#import "HTBBookmarkViewController.h"
#import "HTBHatenaBookmarkManager.h"
#import "HTBLoginWebViewController.h"
#import "HTBUtility.h"
#import "HTBMacro.h"

#define HTB_BOOKMARK_VIEW_MARGIN_X UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 112 : 4
#define HTB_BOOKMARK_VIEW_MARGIN_Y UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 200 : 4
#define HTB_BOOKMARK_VIEW_MARGIN_X_LANDSCAPE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 240 : 4
#define HTB_BOOKMARK_VIEW_MARGIN_Y_LANDSCAPE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 : 4
#define HTB_BOOKMARK_VIEW_HEIGHT_PHONE (192 + 4 * 2)
#define UIModalPresentationSLCompose 17

@interface HTBHatenaBookmarkViewController ()

@end

@implementation HTBHatenaBookmarkViewController {
    CGRect _keyboardRect;
    CGFloat _keyboardAnimationDuration;
    UINavigationController *_htbNavigationConroller;
    UIView *_shadowView;
    UIStatusBarStyle _originalStatusBarStyle;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationSLCompose;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HTBBookmarkViewController *viewController = [[HTBBookmarkViewController alloc] init];
    viewController.URL = self.URL;
    _htbNavigationConroller = [[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil];
    _htbNavigationConroller.viewControllers = @[viewController];
    
    CGRect screenFrame = self.view.bounds;
    screenFrame.origin.y = MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
    CGRect frame = CGRectInset(screenFrame,
                               UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? HTB_BOOKMARK_VIEW_MARGIN_X_LANDSCAPE : HTB_BOOKMARK_VIEW_MARGIN_X,
                               UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? HTB_BOOKMARK_VIEW_MARGIN_Y_LANDSCAPE : HTB_BOOKMARK_VIEW_MARGIN_Y);
    frame.size.height = HTB_BOOKMARK_VIEW_HEIGHT_PHONE;
    
    _shadowView = [[UIView alloc] initWithFrame:frame];
    _shadowView.layer.cornerRadius = 6;
    _shadowView.layer.shadowOpacity = 0.7;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(3, 5);
    _shadowView.layer.shouldRasterize = YES;
    _shadowView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.view addSubview:_shadowView];
    
    _keyboardRect = CGRectZero;
    
    _htbNavigationConroller.view.frame = frame;
    _htbNavigationConroller.view.backgroundColor = [UIColor whiteColor];
    _htbNavigationConroller.view.layer.cornerRadius = 6;
    _htbNavigationConroller.view.layer.masksToBounds = YES;
    
    [self addChildViewController:_htbNavigationConroller];
    [self.view addSubview:_htbNavigationConroller.view];
    [_htbNavigationConroller didMoveToParentViewController:self];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self isBeingPresented]) {
        [UIView animateWithDuration:animated ? 0.27 : 0 animations:^{
            self.presentingViewController.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        }];
        _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
#if __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_7_0 // for iOS7
        // on iOS7, UIStatusBarStyleBlackOpaque is deprecated.
        if (HTB_IS_RUNNING_IOS7) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
        }
#else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
#endif
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    if (![HTBHatenaBookmarkManager sharedManager].authorized && !self.isBeingDismissed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[HTBUtility localizedStringForKey:@"auth-error-title" withDefault:@"Authorization Required"]
                                                        message:[HTBUtility localizedStringForKey:@"auth-error-body" withDefault:@"You are not authorized to use Hatena Bookmark. Please login."]
                                                       delegate:self
                                              cancelButtonTitle:[HTBUtility localizedStringForKey:@"cancel" withDefault:@"Cancel"]
                                              otherButtonTitles:[HTBUtility localizedStringForKey:@"login" withDefault:@"Login"],
                              nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self isBeingDismissed]) {
        self.view.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication] setStatusBarStyle:_originalStatusBarStyle animated:animated];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    _keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardRect = [self.view convertRect:_keyboardRect fromView:nil];
    _keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_keyboardRect.origin.y >= self.view.bounds.size.height || _keyboardRect.origin.x < 0) {
        _keyboardRect = CGRectZero;
    }
    [self updateFrame];
}

- (void)orientationDidChange:(NSNotification *)notification
{
    [self updateFrame];
}

- (void)updateFrame
{
    CGRect newVisibleRect = self.view.bounds;
    newVisibleRect.size.height -= _keyboardRect.size.height;
    
    CGRect frame = newVisibleRect;
    frame.origin = CGPointMake((newVisibleRect.size.width - frame.size.width) / 2, (newVisibleRect.size.height - frame.size.height) / 2);
#if __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_7_0 // for iOS7
    if ([self respondsToSelector:(@selector(topLayoutGuide))]) { // for iOS7 use topLayoutGuide
        CGFloat statusBarHeight = self.topLayoutGuide.length;
        frame.origin.y += statusBarHeight;
        frame.size.height -= statusBarHeight;
    }
#endif
    
    CGRect inset = CGRectInset(frame,
                               UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? HTB_BOOKMARK_VIEW_MARGIN_X_LANDSCAPE : HTB_BOOKMARK_VIEW_MARGIN_X,
                               UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? HTB_BOOKMARK_VIEW_MARGIN_Y_LANDSCAPE : HTB_BOOKMARK_VIEW_MARGIN_Y);
    CGRect fromShadowRect = _htbNavigationConroller.view.bounds;
    CGRect shadowRect = inset;
    fromShadowRect.origin = CGPointZero;
    shadowRect.origin = CGPointZero;
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnimation.duration = _keyboardAnimationDuration * (fromShadowRect.size.height < shadowRect.size.height ? 1.2 : 0.6);
    shadowAnimation.fromValue = (id)[UIBezierPath bezierPathWithRect:fromShadowRect].CGPath;
    shadowAnimation.toValue = (id)[UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    [_shadowView.layer addAnimation:shadowAnimation forKey:@"shadowPath"];
    
    [UIView animateWithDuration:_keyboardAnimationDuration animations:^{
        _htbNavigationConroller.view.frame = inset;
        _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:6].CGPath;
        _shadowView.frame = inset;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UINavigationController *navigationController =[[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class]
                                                                                                    toolbarClass:nil];
        HTBLoginWebViewController *loginViewController = [[HTBLoginWebViewController alloc] init];
        __weak HTBHatenaBookmarkViewController *weakSelf = self;
        __weak HTBLoginWebViewController *weakLogin = loginViewController;
        loginViewController.completionHandler = ^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [weakLogin dismissViewControllerAnimated:YES completion:^{
                        HTBBookmarkViewController *viewController = [[HTBBookmarkViewController alloc] init];
                        viewController.URL = weakSelf.URL;
                        _htbNavigationConroller.viewControllers = @[viewController];
                    }];
                } else {
                    [weakSelf dismissHatenaBookmarkViewControllerCompleted:NO];
                }
            });
        };
        navigationController.providesPresentationContextTransitionStyle = YES;
        navigationController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        navigationController.viewControllers = @[loginViewController];
        [self presentViewController:navigationController animated:YES completion:^{
        }];
    } else {
        [self dismissHatenaBookmarkViewControllerCompleted:NO];
    }
}

- (void)dismissHatenaBookmarkViewControllerCompleted:(BOOL)completed
{
    if (self.completionHandler) {
        self.completionHandler(completed);
    }
    if (!self.isBeingDismissed) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // for iOS5
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[HTBHatenaBookmarkManager sharedManager] logout];
        [self dismissHatenaBookmarkViewControllerCompleted:NO];
    }
}

@end
