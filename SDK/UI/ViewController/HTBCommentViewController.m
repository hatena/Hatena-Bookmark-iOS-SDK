//  HTBCommentViewController.m
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

#import "HTBCommentViewController.h"
#import "HTBBookmarkEntry.h"
#import "HTBUtility.h"

@interface HTBCommentViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation HTBCommentViewController {
}

-(void)loadView
{
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;

    self.view = _webView;

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = self.view.center;
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.indicatorView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  [HTBUtility localizedStringForKey:@"comments" withDefault:@"Comments"];

    if (_entry) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_entry.smartphoneAppEntryURL];
        [_webView loadRequest:req];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.indicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
}

@end
