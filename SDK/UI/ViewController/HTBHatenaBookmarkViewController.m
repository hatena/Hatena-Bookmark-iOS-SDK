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

#define HTB_BOOKMARK_VIEW_MARGIN 4
#define HTB_BOOKMARK_VIEW_HEIGHT_PHONE (192 + 4 * 2)

@interface HTBHatenaBookmarkViewController ()

@end

@implementation HTBHatenaBookmarkViewController {
    UINavigationController *_htbNavigationConroller;
    UIStatusBarStyle _originalStatusBarStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HTBBookmarkViewController *viewController = [[HTBBookmarkViewController alloc] init];
    viewController.URL = self.URL;
   _htbNavigationConroller = [[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil];
    _htbNavigationConroller.viewControllers = @[viewController];
    __block CGRect frame = CGRectInset(self.view.bounds, HTB_BOOKMARK_VIEW_MARGIN, HTB_BOOKMARK_VIEW_MARGIN);
    frame.size.height = HTB_BOOKMARK_VIEW_HEIGHT_PHONE;
    frame.origin.y = self.view.bounds.size.height;
    _htbNavigationConroller.view.frame = frame;
    _htbNavigationConroller.view.backgroundColor = [UIColor whiteColor];
    _htbNavigationConroller.view.layer.cornerRadius = 6;
    _htbNavigationConroller.view.layer.masksToBounds = YES;
    [self addChildViewController:_htbNavigationConroller];
    [self.view addSubview:_htbNavigationConroller.view];
    [_htbNavigationConroller didMoveToParentViewController:self];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    
//    [UIView animateWithDuration:0.27 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////        frame.origin.y = HTB_BOOKMARK_VIEW_MARGIN;
////        _htbNavigationConroller.view.frame = frame;
//    } completion:^(BOOL finished) {
//        
//    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    if ([self isBeingPresented]) {
        self.presentingViewController.providesPresentationContextTransitionStyle = YES;
        self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.view.backgroundColor = [UIColor clearColor];
        _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isBeingPresented]) {
        [UIView animateWithDuration:animated ? 0.27 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
        } completion:^(BOOL finished) {
            if (![HTBHatenaBookmarkManager sharedManager].authorized) {
#warning アラートの文言の修正が必要
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"login", nil];
                alert.delegate = self;
                [alert show];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self isBeingDismissed]) {
        [[UIApplication sharedApplication] setStatusBarStyle:_originalStatusBarStyle animated:animated];
        [UIView animateWithDuration:animated ? 0.27 : 0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:nil];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    CGRect newVisibleRect = self.view.bounds;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification] || [notification.name isEqualToString:UIKeyboardWillHideNotification])
        newVisibleRect.size.height -= keyboardRect.size.height;
    
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        CGRect frame = newVisibleRect;
//        frame.size.height = fmin(frame.size.height, HTB_BOOKMARK_VIEW_HEIGHT_PHONE);

        frame.origin = CGPointMake((newVisibleRect.size.width - frame.size.width) / 2, (newVisibleRect.size.height - frame.size.height) / 2);
        _htbNavigationConroller.view.frame = CGRectInset(frame, HTB_BOOKMARK_VIEW_MARGIN, HTB_BOOKMARK_VIEW_MARGIN);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil];
        HTBLoginWebViewController *viewController = [[HTBLoginWebViewController alloc] init];
        viewController.dismissBlock = ^(BOOL success) {
            HTBBookmarkViewController *viewController = _htbNavigationConroller.viewControllers[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success) {
                    [viewController dismiss];
                }
                else {
                    [viewController loadEntry];
                }
            });
        };
        navigationController.providesPresentationContextTransitionStyle = YES;
        navigationController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        navigationController.viewControllers = @[viewController];
        [self presentViewController:navigationController animated:YES completion:^{
        }];
    }
    else {
        HTBBookmarkViewController *viewController = _htbNavigationConroller.viewControllers[0];
        [viewController dismiss];
    }
}

@end
