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

#define HTB_BOOKMARK_VIEW_MARGIN 4
#define HTB_BOOKMARK_VIEW_HEIGHT_PHONE (192 + 4 * 2)

@interface HTBHatenaBookmarkViewController ()

@end

@implementation HTBHatenaBookmarkViewController {
    UINavigationController *_htbNavigationConroller;
    UIStatusBarStyle _originalStatusBarStyle;
    CGFloat _keyboardAnimationDuration;
    CGRect _keyboardRect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HTBBookmarkViewController *viewController = [[HTBBookmarkViewController alloc] init];
    viewController.URL = self.URL;
    _htbNavigationConroller = [[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil];
    _htbNavigationConroller.viewControllers = @[viewController];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.size.height;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    [self addChildViewController:_htbNavigationConroller];
    [self.containerView addSubview:_htbNavigationConroller.view];
    [_htbNavigationConroller didMoveToParentViewController:self];
    self.containerView.frame = frame;

    _htbNavigationConroller.view.layer.cornerRadius = 6;
    _htbNavigationConroller.view.layer.masksToBounds = YES;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [_htbNavigationConroller beginAppearanceTransition:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:animated ? 0.27 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
    } completion:^(BOOL finished) {

    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:_originalStatusBarStyle animated:animated];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    _keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardRect = [self.view convertRect:_keyboardRect fromView:nil];
    _keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    CGRect newVisibleRect = self.view.frame;
    if ([notification.name isEqualToString:UIKeyboardDidShowNotification] || [notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        newVisibleRect.size.height -= _keyboardRect.size.height;
    } else if ([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        _keyboardRect = CGRectZero;
    }
    newVisibleRect.size.height -= 20;
    [self updateModalHeight:newVisibleRect duration:_keyboardAnimationDuration];
}

- (void)updateModalHeight:(CGRect)modalRect duration:(CGFloat)duration
{
    __block __weak HTBHatenaBookmarkViewController *weakSelf = self;
    CGRect frame = modalRect;
    frame.origin = CGPointMake((modalRect.size.width - frame.size.width) / 2, (modalRect.size.height - frame.size.height) / 2);
    [UIView animateWithDuration:duration animations:^{
        CGRect inset = CGRectInset(modalRect, HTB_BOOKMARK_VIEW_MARGIN, HTB_BOOKMARK_VIEW_MARGIN);
        _htbNavigationConroller.view.frame = inset;
    } completion:^(BOOL finished) {
    }];

}

- (void)viewOrientationDidChanged:(NSNotification *)notification
{
    [super viewOrientationDidChanged:notification];
    CGRect newVisibleRect = self.view.frame;
    newVisibleRect.size.height -= _keyboardRect.size.height;
    newVisibleRect.size.height -= 20;
    [self updateModalHeight:newVisibleRect duration:_keyboardAnimationDuration];
}

@end
