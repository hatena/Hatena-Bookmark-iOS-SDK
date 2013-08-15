//  HTBBookmarkEntryView.m
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

#import "HTBBookmarkEntryView.h"
#import <QuartzCore/QuartzCore.h>
#import "HTBBookmarkEntry.h"
#import "UIImageView+AFNetworking.h"
#import "HTBUtility.h"

#define HTB_ENTRY_VIEW_FAVICON_MARGIN 8.f
#define HTB_ENTRY_VIEW_FAVICON_SIZE 16.f
#define HTB_ENTRY_VIEW_CONTENT_LEFT_MARGIN (HTB_ENTRY_VIEW_FAVICON_MARGIN * 2 + HTB_ENTRY_VIEW_FAVICON_SIZE)
#define HTB_ENTRY_VIEW_TOP_MARGIN 8.f
#define HTB_ENTRY_VIEW_BOTTOM_MARGIN 8.f
#define HTB_ENTRY_VIEW_HEIGHT 44.f
#define HTB_ENTRY_VIEW_TITLE_HEIGHT 16.f
#define HTB_ENTRY_VIEW_URL_TOP_MARGIN 4.f
#define HTB_ENTRY_VIEW_URL_Y (HTB_ENTRY_VIEW_TOP_MARGIN + HTB_ENTRY_VIEW_TITLE_HEIGHT + HTB_ENTRY_VIEW_URL_TOP_MARGIN)
#define HTB_ENTRY_VIEW_URL_HEIGHT 14.f
#define HTB_ENTRY_VIEW_COUNT_HEIGHT 14.f
#define HTB_ENTRY_VIEW_DISCLOSURE_VIEW_HEIGHT 13.f
#define HTB_ENTRY_VIEW_DISCLOSURE_VIEW_WIDTH 9.f
#define HTB_ENTRY_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN 16.f
#define HTB_ENTRY_VIEW_DISCLOSURE_VIEW_LEFT_MARGIN 8.f
#define HTB_ENTRY_VIEW_CONTENT_RIGHT (HTB_ENTRY_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN  + HTB_ENTRY_VIEW_DISCLOSURE_VIEW_WIDTH + HTB_ENTRY_VIEW_DISCLOSURE_VIEW_LEFT_MARGIN)

@implementation HTBBookmarkEntryView {
    UILabel *_entryTitleLabel;
    UILabel *_entryURLLabel;
    UILabel *_entryCountLabel;
    UIImageView *_entryFaviconImageView;
    UIImageView *_disclosureIndicatorImageView;
    CALayer *_hilightedLayer;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeViews];
    }
    return self;
}

-(void)initializeViews
{
    self.enabled = NO;
    _hilightedLayer = [HTBBookmarkEntryView blueGradient];
    _hilightedLayer.frame = self.bounds;
    _hilightedLayer.hidden = YES;
    [self.layer addSublayer:_hilightedLayer];

    _entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _entryTitleLabel.backgroundColor = [UIColor clearColor];
    _entryTitleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _entryTitleLabel.textColor = [UIColor colorWithRed:64.f / 255.f  green:64.f / 255.f blue:64.f / 255.f alpha:1.0];
    _entryTitleLabel.highlightedTextColor = [UIColor whiteColor];
    _entryTitleLabel.shadowColor = [UIColor whiteColor];
    _entryTitleLabel.shadowOffset = CGSizeMake(0, 1);

    _entryCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _entryCountLabel.font = [UIFont systemFontOfSize:12.f];
    _entryCountLabel.textColor = [UIColor colorWithRed:255.f / 255.f green:65.f / 255.f blue:102.f / 255.f alpha:1.0];
    _entryCountLabel.backgroundColor = [UIColor clearColor];
    _entryCountLabel.highlightedTextColor = [UIColor whiteColor];
    _entryCountLabel.shadowColor = [UIColor whiteColor];
    _entryCountLabel.shadowOffset = CGSizeMake(0, 1);

    _entryURLLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _entryURLLabel.backgroundColor = [UIColor clearColor];
    _entryURLLabel.font = [UIFont systemFontOfSize:12.f];
    _entryURLLabel.textColor = [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.0];
    _entryURLLabel.highlightedTextColor = [UIColor whiteColor];
    _entryURLLabel.shadowColor = [UIColor whiteColor];
    _entryURLLabel.shadowOffset = CGSizeMake(0, 1);
    
    _entryFaviconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *imagePath = [[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/disclosure-indicator.png"];

    _disclosureIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    _disclosureIndicatorImageView.highlightedImage = [UIImage imageWithContentsOfFile:[[[HTBUtility hatenaBookmarkSDKBundle] resourcePath] stringByAppendingPathComponent:@"Images/disclosure-indicator-highlighted.png"]];
    _disclosureIndicatorImageView.hidden = YES;
    
    [self addSubview:_entryTitleLabel];
    [self addSubview:_entryCountLabel];
    [self addSubview:_entryURLLabel];
    [self addSubview:_entryFaviconImageView];
    [self addSubview:_disclosureIndicatorImageView];
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


    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    _hilightedLayer.hidden = !self.highlighted;
    [CATransaction commit];
}

-(void)setEntry:(HTBBookmarkEntry *)entry
{
    if (entry) {
        _entry = entry;
        [_entryFaviconImageView setImageWithURL:_entry.faviconURL];
        _entryTitleLabel.text = _entry.title;
        _entryURLLabel.text = _entry.displayURLString;
        _entryCountLabel.text = _entry.countUsers;
        self.enabled = !!_entry.count;
        _disclosureIndicatorImageView.hidden = !self.enabled;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _hilightedLayer.frame = self.bounds;
    _entryFaviconImageView.frame = CGRectMake(HTB_ENTRY_VIEW_FAVICON_MARGIN, HTB_ENTRY_VIEW_FAVICON_MARGIN, HTB_ENTRY_VIEW_FAVICON_SIZE, HTB_ENTRY_VIEW_FAVICON_SIZE);

    _entryTitleLabel.frame = CGRectMake(HTB_ENTRY_VIEW_CONTENT_LEFT_MARGIN, HTB_ENTRY_VIEW_TOP_MARGIN, self.bounds.size.width - HTB_ENTRY_VIEW_CONTENT_LEFT_MARGIN - HTB_ENTRY_VIEW_CONTENT_RIGHT, HTB_ENTRY_VIEW_TITLE_HEIGHT);
    
    CGSize countSize = [_entry.countUsers sizeWithFont:_entryCountLabel.font];
    _entryCountLabel.frame = CGRectMake(self.bounds.size.width - countSize.width - HTB_ENTRY_VIEW_CONTENT_RIGHT, HTB_ENTRY_VIEW_URL_Y, countSize.width, HTB_ENTRY_VIEW_URL_HEIGHT);
    
    CGSize urlSize = [_entry.displayURLString sizeWithFont:_entryURLLabel.font forWidth:self.bounds.size.width - HTB_ENTRY_VIEW_CONTENT_LEFT_MARGIN - countSize.width - HTB_ENTRY_VIEW_CONTENT_RIGHT lineBreakMode:NSLineBreakByTruncatingTail];
    _entryURLLabel.frame = CGRectMake(HTB_ENTRY_VIEW_CONTENT_LEFT_MARGIN, HTB_ENTRY_VIEW_URL_Y, urlSize.width, HTB_ENTRY_VIEW_URL_HEIGHT);
    
    _disclosureIndicatorImageView.frame = CGRectMake(self.bounds.size.width -  HTB_ENTRY_VIEW_DISCLOSURE_VIEW_WIDTH - HTB_ENTRY_VIEW_DISCLOSURE_VIEW_RIGHT_MARGIN, (self.bounds.size.height - HTB_ENTRY_VIEW_DISCLOSURE_VIEW_HEIGHT) / 2, HTB_ENTRY_VIEW_DISCLOSURE_VIEW_WIDTH, HTB_ENTRY_VIEW_DISCLOSURE_VIEW_HEIGHT);
}

+ (CAGradientLayer *) blueGradient {    
    UIColor *colorOne = [UIColor colorWithRed:0.096 green:0.452 blue:0.906 alpha:1.000];
    UIColor *colorTwo = [UIColor colorWithRed:0.062 green:0.282 blue:0.857 alpha:1.000];
    
    NSArray *colors = @[(__bridge id)colorOne.CGColor, (__bridge id)colorTwo.CGColor];
    
    NSArray *locations = [NSArray arrayWithObjects:@0.0, @1.0, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
