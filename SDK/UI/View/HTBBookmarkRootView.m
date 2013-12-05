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
#define HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_FONT_SIZE 12.f
#define HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_RIGHT_MARGIN 8.f
#define HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_HEIGHT 10.f
#define HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_WIDTH 22.f
#define HTB_BOOKMARK_ROOT_VIEW_TEXT_MINIMUM_HEIGHT 30

@interface HTBBookmarkRootView ()
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation HTBBookmarkRootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.containerView = [[UIView alloc] initWithFrame:frame];
        self.scrollView.zoomScale = 1.0;
        [self initializeViews];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initializeViews
{
    self.commentTextView = [[HTBPlaceholderTextView alloc] initWithFrame:CGRectZero];
    self.commentTextView.backgroundColor = [UIColor clearColor];

    self.textCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textCountLabel.backgroundColor = [UIColor clearColor];
    self.textCountLabel.textAlignment = NSTextAlignmentRight;
    self.textCountLabel.font = [UIFont systemFontOfSize:HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_FONT_SIZE];
    self.textCountLabel.textColor = [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.000];
    self.textCountLabel.shadowColor = [UIColor whiteColor];
    self.textCountLabel.shadowOffset = CGSizeMake(0, 1);
    self.textCountLabel.text = @"0";

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

    [self.containerView addSubview:self.commentTextView];
    [self.containerView addSubview:self.textCountLabel];
    [self.containerView addSubview:self.tagTextField];
    [self.containerView addSubview:self.myBookmarkActivityIndicatorView];
    [self.containerView addSubview:self.entryView];
    [self.containerView addSubview:self.bookmarkActivityIndicatorView];
    [self.containerView addSubview:self.separatorLineView];
    [self.containerView addSubview:self.tagImageView];
    [self.containerView addSubview:self.canonicalView];
    self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.000];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentDidChanged:) name:UITextViewTextDidChangeNotification object:self.commentTextView];

    [self.bookmarkActivityIndicatorView startAnimating];
    [self.myBookmarkActivityIndicatorView startAnimating];
    self.commentTextView.font = [UIFont systemFontOfSize:17.f];
    self.commentTextView.placeholderText = [HTBUtility localizedStringForKey:@"add-comments" withDefault:@"Add comments"];
    self.tagTextField.font = [UIFont systemFontOfSize:12.f];
    self.tagTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    NSString *placeholderText = [HTBUtility localizedStringForKey:@"add-tags" withDefault:@"Add tags"];
    if ([self.tagTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor whiteColor];
        shadow.shadowOffset = CGSizeMake(0, 1);
        self.tagTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{
                NSShadowAttributeName : shadow,
        }];
    }
    else {
        self.tagTextField.placeholder = placeholderText;

    }

    NSString *borderImagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/border-dotted.png"];
    _separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:borderImagePath]];

    self.toolbarView = [[HTBBookmarkToolbarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44.f)];
    self.toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.commentTextView.inputAccessoryView = self.toolbarView;
    [self.scrollView addSubview:self.containerView];
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;
    CGFloat minimumHeight = HTB_BOOKMARK_ROOT_VIEW_ENTRY_VIEW_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_SEPARATOR_LINE_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_TEXT_MINIMUM_HEIGHT;
    if (!self.canonicalView.hidden) {
        minimumHeight += HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_BOTTOM_MARGIN;
    }

    CGFloat y = self.bounds.size.height - self.scrollView.contentInset.top;
    if (self.frame.size.height < minimumHeight) {
        y = minimumHeight;
    }
    CGRect newFrame = self.bounds;
    newFrame.size.height = y;
    self.containerView.frame = newFrame;
    self.scrollView.contentSize = newFrame.size;

    if (!self.canonicalView.hidden) {
        y -= HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT + HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_BOTTOM_MARGIN;
        self.canonicalView.frame = CGRectMake(HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN, y, self.bounds.size.width - HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_MARGIN * 2, HTB_BOOKMARK_ROOT_VIEW_TAG_CANONICAL_VIEW_HEIGHT);
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
    self.tagTextField.frame = CGRectMake(tagTextFieldLeftMargin, y, self.bounds.size.width - tagTextFieldLeftMargin - HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_WIDTH - HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_RIGHT_MARGIN, HTB_BOOKMARK_ROOT_VIEW_TAG_TEXT_HEIGHT);

    self.textCountLabel.frame = CGRectMake(self.bounds.size.width - HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_WIDTH - HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_RIGHT_MARGIN, y + HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_HEIGHT, HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_WIDTH, HTB_BOOKMARK_ROOT_VIEW_TEXT_COUNT_LABEL_HEIGHT);

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

- (void)updateTextCount
{
    NSInteger textCount = ceilf((float)[self.commentTextView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding] / 3.f);
    self.textCountLabel.text = [NSString stringWithFormat:@"%d", textCount];
    if (textCount > 100) {
        self.textCountLabel.textColor = [UIColor redColor];
    }
    else {
        self.textCountLabel.textColor = [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.000];
    }
}

- (void)commentDidChanged:(NSNotification *)notification
{
    [self updateTextCount];
}


@end