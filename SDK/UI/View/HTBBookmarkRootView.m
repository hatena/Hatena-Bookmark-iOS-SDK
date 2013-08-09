//  HTBBookmarkRootView.m
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

#import "HTBBookmarkRootView.h"
#import "HTBTagTextField.h"
#import "HTBPlaceholderTextView.h"
#import "HTBBookmarkEntryView.h"
#import "HTBBookmarkToolbarView.h"
#import "HTBCanonicalView.h"
#import "HTBUtility.h"

#define HTB_BOOKMARK_ROOT_VIEW_ENTRY_VIEW_HEIGHT 50.f
#define HTB_BOOKMARK_ROOT_VIEW_SEPARATOR_LINE_HEIGHT 2.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN 8.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT 40.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_BOTTOM_MARGIN 9.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT 30.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_LEFT_MARGIN 4.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_IMAGE_VIEW_WIDTH 20.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_IMAGE_VIEW_LEFT_MARGIN 8.f
#define HTB_BOOKMARK_ROOT_VIEW_TAG_IMAGE_SIZE 12.f

@interface HTBBookmarkRootView ()
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation HTBBookmarkRootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews
{
    self.commentTextView = [[HTBPlaceholderTextView alloc] initWithFrame:CGRectZero];
    self.commentTextView.backgroundColor = [UIColor clearColor];
    self.tagTextField = [[HTBTagTextField alloc] initWithFrame:CGRectZero];
    self.entryView = [[HTBBookmarkEntryView alloc] initWithFrame:CGRectZero];
    self.myBookmarkActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.bookmarkActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
    NSString *tagImagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/tag.png"];
    self.tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:tagImagePath]];
    self.tagImageView.contentMode = UIViewContentModeCenter;
    self.canonicalView = [[HTBCanonicalView alloc] initWithFrame:CGRectZero];
    self.canonicalView.hidden = YES;

    [self addSubview:self.commentTextView];
    [self addSubview:self.tagTextField];
    [self addSubview:self.myBookmarkActivityIndicatorView];
    [self addSubview:self.entryView];
    [self addSubview:self.bookmarkActivityIndicatorView];
    [self addSubview:self.separatorLineView];
    [self addSubview:self.tagImageView];
    [self addSubview:self.canonicalView];
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.000];

    [self.bookmarkActivityIndicatorView startAnimating];
    [self.myBookmarkActivityIndicatorView startAnimating];
    self.commentTextView.font = [UIFont systemFontOfSize:17.f];
    self.commentTextView.placeholder = [HTBUtility localizedStringForKey:@"add-comments" withDefault:@"Add comments"];
    self.tagTextField.font = [UIFont systemFontOfSize:12.f];
    self.tagTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.tagTextField.placeholder = [HTBUtility localizedStringForKey:@"add-tags" withDefault:@"Add tags"];

    NSString *borderImagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/border-dotted.png"];    
    _separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:borderImagePath]];

    self.toolbarView = [[HTBBookmarkToolbarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44.f)];
    self.toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.commentTextView.inputAccessoryView = self.toolbarView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat y = self.bounds.size.height;

    if (!self.canonicalView.hidden) {
        y -= HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_BOTTOM_MARGIN;
        self.canonicalView.frame = CGRectMake(HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN, y, self.bounds.size.width - HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN * 2, HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT);
//        y -= HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN;
    }
    else {
        self.canonicalView.frame = CGRectMake(HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN, self.bounds.size.height, self.bounds.size.width, HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT);
    }

    y -= HTB_BOOKMARK_ROOT_VIEW_ENTRY_VIEW_HEIGHT;
    self.entryView.frame = CGRectMake(0, y,  self.bounds.size.width, HTB_BOOKMARK_ROOT_VIEW_ENTRY_VIEW_HEIGHT);
    self.bookmarkActivityIndicatorView.center = self.entryView.center;


    y -= HTB_BOOKMARK_ROOT_VIEW_SEPARATOR_LINE_HEIGHT;
    self.separatorLineView.frame = CGRectMake(0, y, self.bounds.size.width, HTB_BOOKMARK_ROOT_VIEW_SEPARATOR_LINE_HEIGHT);

    y -= HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT;
    self.tagImageView.frame = CGRectMake(HTB_BOOKMARK_ROOT_VIEW_TAG_IMAGE_VIEW_LEFT_MARGIN, y, HTB_BOOKMARK_ROOT_VIEW_TAG_IMAGE_SIZE, HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT);
    CGFloat tagTextFieldLeftMargin = self.tagImageView.frame.origin.x + self.tagImageView.frame.size.width + HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_LEFT_MARGIN;
    self.tagTextField.frame = CGRectMake(tagTextFieldLeftMargin, y, self.bounds.size.width - tagTextFieldLeftMargin, HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT);

    self.commentTextView.frame = CGRectMake(0, 0, self.bounds.size.width, y);
    self.myBookmarkActivityIndicatorView.center = self.commentTextView.center;
}

-(void)setCanonicalViewShown:(BOOL)shown urlString:(NSString *)urlString animated:(BOOL)animated
{
    self.canonicalView.hidden = !shown;
    self.canonicalView.urlLabel.text = urlString;
    [UIView animateWithDuration:animated ? 0.27 : 0 animations:^{
        [self layoutSubviews];

    }];
}


@end
