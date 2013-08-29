//  HTBBookmarkToolbarView.m
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

#import "HTBBookmarkToolbarView.h"
#import "HTBMyEntry.h"
#import "HTBBookmarkedDataEntry.h"
#import "HTBToggleButton.h"
#import "HTBUtility.h"

#define HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_LEFT_MARGIN 6.f
#define HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_RIGHT_MARGIN 6.f
#define HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_WIDTH 38.f
#define HTB_BOOKMARK_TOOLBAR_VIEW_PRIVATE_BUTTON_WIDTH 72.f

@implementation HTBBookmarkToolbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

-(void)setMyEntry:(HTBMyEntry *)myEntry
{
    _myEntry = myEntry;
    [self enableButtonsWithMyEntry:_myEntry];
    [self selectButtonsWithBookmarkedDataEntry:_bookmarkEntry lastSelectedState:_lastPostOptions];
}

- (void)setLastPostOptions:(HatenaBookmarkPOSTOptions)lastPostOptions
{
    _lastPostOptions = lastPostOptions;
    [self enableButtonsWithMyEntry:_myEntry];
    [self selectButtonsWithBookmarkedDataEntry:_bookmarkEntry lastSelectedState:_lastPostOptions];
}

-(void)setBookmarkEntry:(HTBBookmarkedDataEntry *)bookmarkEntry
{
    _bookmarkEntry = bookmarkEntry;
    [self enableButtonsWithMyEntry:_myEntry];
    [self selectButtonsWithBookmarkedDataEntry:_bookmarkEntry lastSelectedState:_lastPostOptions];
}


-(void)enableButtonsWithMyEntry:(HTBMyEntry *)myEntry
{
    _twitterToggleButton.enabled  = myEntry.isOAuthTwitter;
    _facebookToggleButton.enabled = myEntry.isOAuthFacebook;
    _mixiToggleButton.enabled     = myEntry.isOAuthMixiCheck;
    _evernoteToggleButton.enabled = myEntry.isOAuthEvernote;
    _mailToggleButton.enabled     = myEntry.isPlususer;
    [self setNeedsLayout];
}

- (void)selectButtonsWithBookmarkedDataEntry:(HTBBookmarkedDataEntry *)bookmarkEntry lastSelectedState:(HatenaBookmarkPOSTOptions)lastPostOptions
{
    if (_twitterToggleButton.enabled) {
        _twitterToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionTwitter);
    }
    if (_facebookToggleButton.enabled) {
        _facebookToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionFacebook);
    }
    if (_mixiToggleButton.enabled) {
        _mixiToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionMixi);
    }
    if (_evernoteToggleButton.enabled) {
        _evernoteToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionEvernote);
    }
    if (_mailToggleButton.enabled) {
        _mailToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionSendMail);
    }

    if (bookmarkEntry) {
        _privateToggleButton.selected = bookmarkEntry.isPrivate;
    }
    else {
        _privateToggleButton.selected = !!(lastPostOptions & HatenaBookmarkPostOptionPrivate);
    }
    if (_privateToggleButton.selected) {
        [self togglePrivateButton:_privateToggleButton.selected];
    }
}

- (void)initializeViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    _twitterToggleButton  = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
    _facebookToggleButton = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
    _mixiToggleButton     = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
    _evernoteToggleButton = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
    _mailToggleButton     = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
    _privateToggleButton  = [[HTBToggleButton alloc] initWithFrame:CGRectZero];

    [self addSubview:_twitterToggleButton];
    [self addSubview:_facebookToggleButton];
    [self addSubview:_mixiToggleButton];
    [self addSubview:_evernoteToggleButton];
    [self addSubview:_mailToggleButton];
    [self addSubview:_privateToggleButton];
    NSString *resourcePath = [[HTBUtility hatenaBookmarkSDKBundle] resourcePath];
    _twitterToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-twitter-icon-off.png"]];
    _twitterToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-twitter-icon.png"]];
    _facebookToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-facebook-icon-off.png"]];
    _facebookToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-facebook-icon.png"]];
    _mixiToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-mixi-icon-off.png"]];
    _mixiToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-mixi-icon.png"]];
    _evernoteToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-evernote-icon-off.png"]];
    _evernoteToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-evernote-icon.png"]];
    _mailToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-mail-icon-off.png"]];
    _mailToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-mail-icon.png"]];
    _privateToggleButton.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-public-icon.png"]];
    _privateToggleButton.selectedImage = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/addbookmark-private-icon.png"]];
    _privateToggleButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_privateToggleButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _privateToggleButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [_privateToggleButton setTitleColor:[UIColor colorWithWhite:0.25 alpha:1.0] forState:UIControlStateNormal];
    [_privateToggleButton setTitleColor:[UIColor colorWithWhite:0.50 alpha:1.0] forState:UIControlStateHighlighted];

    _privateToggleButton.title = [HTBUtility localizedStringForKey:@"public" withDefault:@"Public"];
    _privateToggleButton.selectedTitle = [HTBUtility localizedStringForKey:@"private" withDefault:@"Private"];
    _privateToggleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_privateToggleButton addTarget:self action:@selector(privateButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger x = HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_LEFT_MARGIN;
    for (HTBToggleButton *button in @[_twitterToggleButton, _facebookToggleButton, _mixiToggleButton, _evernoteToggleButton, _mailToggleButton]) {
        button.frame = CGRectMake(x, 0, HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_WIDTH, self.bounds.size.height);
        x += HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_WIDTH;
    }
    _privateToggleButton.frame = CGRectMake(self.bounds.size.width - HTB_BOOKMARK_TOOLBAR_VIEW_PRIVATE_BUTTON_WIDTH - HTB_BOOKMARK_TOOLBAR_VIEW_BUTTON_RIGHT_MARGIN, 0, HTB_BOOKMARK_TOOLBAR_VIEW_PRIVATE_BUTTON_WIDTH, self.bounds.size.height);
}

- (void)privateButtonPushed:(HTBToggleButton *)sender
{
    [self togglePrivateButton:sender.selected];
}

- (void)togglePrivateButton:(BOOL)isPrivate {
    if (isPrivate) {
        _twitterToggleButton.selected = _facebookToggleButton.selected = _mixiToggleButton.selected = NO;
        _twitterToggleButton.enabled = _facebookToggleButton.enabled = _mixiToggleButton.enabled = NO;
    }
    else {
        _twitterToggleButton.enabled = _facebookToggleButton.enabled = _mixiToggleButton.enabled = YES;
        [self enableButtonsWithMyEntry:_myEntry];
    }
}

- (HatenaBookmarkPOSTOptions)selectedPostOptions
{
    HatenaBookmarkPOSTOptions options = HatenaBookmarkPostOptionNone;

    if (self.twitterToggleButton.selected) {
        options |= HatenaBookmarkPostOptionTwitter;
    }
    if (self.facebookToggleButton.selected) {
        options |= HatenaBookmarkPostOptionFacebook;
    }
    if (self.mixiToggleButton.selected) {
        options |= HatenaBookmarkPostOptionMixi;
    }
    if (self.mailToggleButton.selected) {
        options |= HatenaBookmarkPostOptionSendMail;
    }
    if (self.evernoteToggleButton.selected) {
        options |= HatenaBookmarkPostOptionEvernote;
    }
    if (self.privateToggleButton.selected) {
        options |= HatenaBookmarkPostOptionPrivate;
    }
    return options;
}

@end
