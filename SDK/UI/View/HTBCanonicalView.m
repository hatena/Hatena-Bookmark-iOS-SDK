//  HTBCanonicalView.m
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

#import "HTBCanonicalView.h"
#import "HTBUtility.h"

#define HTB_CANONICAL_VIEW_VERTICAL_MARGIN 6
#define HTB_CANONICAL_VIEW_HORIZONTAL_MARGIN 9
#define HTB_CANONICAL_VIEW_LABEL_TOP_MARGIN 2
#define HTB_CANONICAL_VIEW_LABEL_HEIGHT 14
#define HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_HEIGHT 13.f
#define HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_WIDTH 9.f
#define HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN 8.f
#define HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_LEFT_MARGIN 8.f
#define HTB_CANONICAL_VIEW_CONTENT_RIGHT (HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN  + HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_WIDTH + HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_LEFT_MARGIN)

@implementation HTBCanonicalView

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
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.font = [UIFont systemFontOfSize:12.0f];
    self.messageLabel.textColor = [UIColor colorWithWhite:0.251 alpha:1.000];
    self.messageLabel.highlightedTextColor = [UIColor whiteColor];
    self.messageLabel.shadowOffset = CGSizeMake(0, 1);
    self.messageLabel.shadowColor = [UIColor whiteColor];
    [self addSubview:self.messageLabel];
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.urlLabel.backgroundColor = [UIColor clearColor];
    self.urlLabel.font = [UIFont systemFontOfSize:12.0f];
    self.urlLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    self.urlLabel.highlightedTextColor = [UIColor whiteColor];
    self.urlLabel.shadowOffset = CGSizeMake(0, 1);
    self.urlLabel.shadowColor = [UIColor whiteColor];
    [self addSubview:self.urlLabel];
    self.messageLabel.text = [HTBUtility localizedStringForKey:@"canonical" withDefault:@"Other URL offered"];

    NSString *imagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/disclosure-indicator.png"];
    _disclosureIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    _disclosureIndicatorImageView.highlightedImage = [UIImage imageWithContentsOfFile:[[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/disclosure-indicator-highlighted.png"]];
    [self addSubview:_disclosureIndicatorImageView];

    NSString *resourcePath = [[HTBUtility hatenaBookmarkSDKBundle] resourcePath];
    [self setBackgroundImage:[[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"Images/canonical.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateNormal];
}

- (void)setHighlighted: (BOOL) highlighted {
    [super setHighlighted: highlighted];

    for (UIView *view in self.subviews) {
        if ([view respondsToSelector:@selector(setHighlighted:)]) {
            [(UIControl *)view setHighlighted:highlighted];
        }
    }

    for (UIView *view in self.subviews) {
        if ([view respondsToSelector:@selector(setShadowColor:)]) {
            [view performSelector:@selector(setShadowColor:) withObject:highlighted ? [UIColor clearColor] : [UIColor whiteColor]];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelWidth = self.bounds.size.width - HTB_CANONICAL_VIEW_HORIZONTAL_MARGIN * 2 - HTB_CANONICAL_VIEW_CONTENT_RIGHT;
    CGFloat y = HTB_CANONICAL_VIEW_VERTICAL_MARGIN;
    self.messageLabel.frame = CGRectMake(HTB_CANONICAL_VIEW_HORIZONTAL_MARGIN, y, labelWidth, HTB_CANONICAL_VIEW_LABEL_HEIGHT);

    y += HTB_CANONICAL_VIEW_LABEL_HEIGHT + HTB_CANONICAL_VIEW_LABEL_TOP_MARGIN;
    self.urlLabel.frame = CGRectMake(HTB_CANONICAL_VIEW_HORIZONTAL_MARGIN, y , labelWidth, HTB_CANONICAL_VIEW_LABEL_HEIGHT);

    _disclosureIndicatorImageView.frame = CGRectMake(self.bounds.size.width -   HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_WIDTH -  HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN, (self.bounds.size.height -  HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_HEIGHT) / 2,  HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_WIDTH,  HTB_CANONICAL_VIEW_DISCLOSURE_VIEW_HEIGHT);
}

@end
