//  HTBComposeViewController.h
//
//  modified from REComposeViewController.m (https://github.com/romaonthego/REComposeViewController)
//
//  Copyright (c) 2013 Hatena Co., Ltd.
//  Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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

#import <QuartzCore/QuartzCore.h>
#import "HTBComposeViewController.h"

@implementation HTBComposeViewController {
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _cornerRadius = 10;
    }
    return self;
}

- (int)currentWidth
{
    UIScreen *screen = [UIScreen mainScreen];
    return (!UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) ? screen.bounds.size.width : screen.bounds.size.height;
}

- (void)loadView
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _backgroundView = [[HTBREComposeBackgroundView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.centerOffset = CGSizeMake(0, - self.view.frame.size.height / 2);
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, self.currentWidth - 8, [UIScreen mainScreen].bounds.size.height)];
    _backView.layer.cornerRadius = _cornerRadius;
    _backView.layer.shadowOpacity = 0;
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOffset = CGSizeMake(3, 5);
    _backView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_backView.frame cornerRadius:_cornerRadius].CGPath;
    _backView.layer.shouldRasterize = YES;
    _backView.layer.rasterizationScale = [UIScreen mainScreen].scale;

    [_containerView addSubview:_backView];
    [self.view addSubview:_containerView];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) return;
    __typeof(&*self) __weak weakSelf = self;
    
    _backgroundView.frame = _rootViewController.view.bounds;
    [weakSelf beginAppearanceTransition:YES animated:YES];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = weakSelf.containerView.frame;
        [weakSelf layoutWithOrientation:weakSelf.interfaceOrientation width:weakSelf.view.frame.size.width height:weakSelf.view.frame.size.height];
    } completion:^(BOOL finished) {
        [weakSelf endAppearanceTransition];
    }];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.backgroundView.alpha = 1;
                     } completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)layoutWithOrientation:(UIInterfaceOrientation)interfaceOrientation width:(NSInteger)width height:(NSInteger)height
{
    NSInteger offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 : 4;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGRect frame = _containerView.frame;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            offset *= 2;
        }

        NSInteger verticalOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 316 : 216;

        NSInteger containerHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? _containerView.frame.size.height : _containerView.frame.size.height;
        frame.origin.y = (height - verticalOffset - containerHeight) / 2;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        if (frame.origin.y < 20) frame.origin.y = 20;
        _containerView.frame = frame;

        _containerView.clipsToBounds = YES;
        _backView.frame = CGRectMake(offset, 0, width - offset * 2, [UIScreen mainScreen].bounds.size.height);
    } else {
        CGRect frame = _containerView.frame;
        frame.origin.y = 20;
        if (frame.origin.y < 20) frame.origin.y = 20;
        _containerView.frame = frame;
        _backView.frame = CGRectMake(offset, 0, width - offset * 2, [UIScreen mainScreen].bounds.size.height);
    }
    
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    __typeof(&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:flag ? 0.4 : 0 animations:^{
        CGRect frame = weakSelf.containerView.frame;
        frame.origin.y =  weakSelf.rootViewController.view.frame.size.height;
        weakSelf.containerView.frame = frame;
    }];
    [self beginAppearanceTransition:NO animated:flag];
    [UIView animateWithDuration:flag ? 0.4 : 0
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.backgroundView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakSelf.view removeFromSuperview];
                         [weakSelf removeFromParentViewController];
                         [weakSelf endAppearanceTransition];
                         if (completion)
                             completion();
                     }];
    [super dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)viewOrientationDidChanged:(NSNotification *)notification
{
    [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
}


@end