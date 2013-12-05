//  HTBLoginWebViewController.m
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

#import "HTBLoginWebViewController.h"
#import "HTBAFOAuth1Client.h"
#import "HTBHatenaBookmarkAPIClient.h"
#import "HTBUtility.h"
#import "HTBHatenaBookmarkManager.h"

@implementation HTBLoginWebViewController {
    UIWebView *_webView;
    NSURLRequest *_authorizationRequest;
}

-(id)initWithAuthorizationRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _authorizationRequest = request;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOAuthLoginView:) name:kHTBLoginStartNotification object:nil];
        [[HTBHatenaBookmarkManager sharedManager] authorizeWithSuccess:^{
            [self hideModalView:YES];
        } failure:^(NSError *error) {
            [self hideModalView:NO];
        }];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [HTBUtility localizedStringForKey:@"login" withDefault:@"Login"];

    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"close" withDefault:@"Close"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
    }
    [_webView loadRequest:_authorizationRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* queryString = request.URL.query;
    if (queryString && [queryString rangeOfString:@"oauth_verifier"].location != NSNotFound) {
        NSNotification *notification = [NSNotification notificationWithName:kHTBLoginFinishNotification object:nil userInfo:@{ kHTBApplicationLaunchOptionsURLKey : request.URL }];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        return NO;
    }
    return YES;
}

- (void)closeButtonPushed:(id)sender
{
    [self hideModalView:NO];
}

- (void)hideModalView:(BOOL)success
{
    if (self.completionHandler) {
        self.completionHandler(success);
    } else {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }
}

#pragma mark - 

-(void)loadOAuthLoginView:(NSNotification *)notification
{
    NSURLRequest *req = (NSURLRequest *)notification.object;
    _authorizationRequest = req;
    [_webView loadRequest:_authorizationRequest];
}


@end
