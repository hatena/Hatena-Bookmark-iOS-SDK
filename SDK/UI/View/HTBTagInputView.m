//  HTBTagInputView.m
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

#import "HTBTagInputView.h"
#import "HTBToggleButton.h"
#import "HTBUtility.h"
#import "HTBMacro.h"

#define HTB_BOOKMARK_TAG_KEY_FONT_SIZE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 15 : 18)
#define HTB_BOOKMARK_TAG_KEY_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 40 : 60)
#define HTB_BOOKMARK_TAG_KEY_TOP_MARGIN 11
#define HTB_BOOKMARK_TAG_KEY_V_MARGIN (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 14 : 10)
#define HTB_BOOKMARK_TAG_KEY_TEXT_H_MARGIN (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 10 : 16)
#define HTB_BOOKMARK_TAG_KEY_LEFT_MARGIN (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 3 : 8)
#define HTB_BOOKMARK_TAG_KEY_H_MARGIN (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? (HTB_IS_RUNNING_IOS7 ? 7 : 2) : (HTB_IS_RUNNING_IOS7 ? 14 : 8))
#define HTB_BOOKMARK_TAG_PAGE_CONTOL_HEIGHT 30
#define HTB_BOOKMARK_TAG_PAGE_CONTOL_BOTTOM_MARGIN 6

@interface HTBTagInputView ()
@property (nonatomic, retain) UIScrollView *inputView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableDictionary *tagButtons;
@property (nonatomic, assign) BOOL isBackspaceButtonTouched;
@property (nonatomic, strong) NSArray *tags;
@end

@implementation HTBTagInputView

-(id)initWithFrame:(CGRect)frame tags:(NSArray *)tags {
    if (self = [super initWithFrame:frame]) {
        _tags = tags;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews
{
    self.tagButtons = [NSMutableDictionary dictionary];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    NSString *resourcePath = [[HTBUtility hatenaBookmarkSDKBundle] resourcePath];
    NSString *imagePath = [resourcePath stringByAppendingPathComponent:HTB_IS_RUNNING_IOS7 ? @"Images7" : @"Images"];
    
    backgroundImageView.image = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"keyboard.png"]];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:backgroundImageView];
    self.inputView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.inputView.pagingEnabled = YES;
    self.inputView.scrollsToTop = NO;
    self.inputView.showsHorizontalScrollIndicator = NO;
    self.inputView.showsVerticalScrollIndicator = NO;
    self.inputView.delegate = self;
    for (NSString *tag in _tags) {
        HTBToggleButton *button = [[HTBToggleButton alloc] initWithFrame:CGRectZero];
        button.title = tag;
        button.selectedTitle = tag;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:HTB_BOOKMARK_TAG_KEY_FONT_SIZE];
        [button addTarget:self action:@selector(inputTag:) forControlEvents:UIControlEventTouchUpInside];        
        button.backgroundImage = [[UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"keyboard-button.png"]] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        button.highlightedBackgroundImage = [[UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"keyboard-button-highlighted.png"]] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        button.selectedBackgroundImage = [[UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"keyboard-selected-button.png"]] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        button.selectedHighlightedBackgroundImage  = [[UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"keyboard-selected-button-highlighted.png"]] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        button.textColor = [UIColor blackColor];
        button.selectedTextColor = [UIColor whiteColor];
        [self.inputView addSubview:button];
        [self.tagButtons setObject:button forKey:[tag lowercaseString]];
    }
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -  (HTB_BOOKMARK_TAG_PAGE_CONTOL_BOTTOM_MARGIN + HTB_BOOKMARK_TAG_PAGE_CONTOL_HEIGHT), self.frame.size.width, HTB_BOOKMARK_TAG_PAGE_CONTOL_HEIGHT)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.inputView];
    [self addSubview:self.pageControl];
}

-(void)toggleTagButtons:(NSArray *)tags {
    NSMutableArray *lowercaseTags = [NSMutableArray array];
    for (NSString *tag in tags) {
        [lowercaseTags addObject:[tag lowercaseString]];
    }
    NSSet *tagsSet = [NSSet setWithArray:lowercaseTags];
    NSMutableSet *buttonKeySet = [NSMutableSet setWithArray:[self.tagButtons allKeys]];
    for (NSString *tag in tagsSet) {
        HTBToggleButton *button = (HTBToggleButton *)[self.tagButtons objectForKey:[tag lowercaseString]];
        [button setSelected:YES];
    }
    [buttonKeySet minusSet:tagsSet];
    for (NSString *tag in buttonKeySet) {
        HTBToggleButton *button = (HTBToggleButton *)[self.tagButtons objectForKey:[tag lowercaseString]];
        [button setSelected:NO];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    int row = 0;
    int keyViewCount = 0;
    CGFloat leftMargin = HTB_BOOKMARK_TAG_KEY_LEFT_MARGIN;
    for (NSString *tag in self.tags) {
        HTBToggleButton *button = [self.tagButtons objectForKey:[tag lowercaseString]];
        CGSize size = [tag sizeWithFont:[UIFont boldSystemFontOfSize:HTB_BOOKMARK_TAG_KEY_FONT_SIZE]];
        CGFloat buttonWidth = size.width + HTB_BOOKMARK_TAG_KEY_TEXT_H_MARGIN * 2;
        if (HTB_BOOKMARK_TAG_KEY_LEFT_MARGIN + leftMargin + buttonWidth > self.bounds.size.width) {
            row++;
            leftMargin = HTB_BOOKMARK_TAG_KEY_LEFT_MARGIN;
        }
        if (row >= (int)((self.bounds.size.height - (HTB_BOOKMARK_TAG_KEY_TOP_MARGIN) - (HTB_BOOKMARK_TAG_KEY_V_MARGIN * row) -(HTB_BOOKMARK_TAG_PAGE_CONTOL_BOTTOM_MARGIN + HTB_BOOKMARK_TAG_PAGE_CONTOL_HEIGHT)) / HTB_BOOKMARK_TAG_KEY_HEIGHT)) {
            row = 0;
            keyViewCount++;
        }
        button.frame = CGRectMake(keyViewCount * self.frame.size.width + HTB_BOOKMARK_TAG_KEY_LEFT_MARGIN + leftMargin, HTB_BOOKMARK_TAG_KEY_TOP_MARGIN + row * (HTB_BOOKMARK_TAG_KEY_HEIGHT + HTB_BOOKMARK_TAG_KEY_V_MARGIN) , buttonWidth, HTB_BOOKMARK_TAG_KEY_HEIGHT);
        
        leftMargin += button.frame.size.width + HTB_BOOKMARK_TAG_KEY_H_MARGIN;
    }
    self.inputView.contentSize = CGSizeMake(self.frame.size.width * (keyViewCount + 1), self.frame.size.height);
    self.pageControl.numberOfPages = keyViewCount + 1;
    [self.inputView setContentOffset:CGPointMake(self.frame.size.width * nearbyint(self.inputView.contentOffset.x / self.frame.size.width), 0) animated:NO];
}

-(UIView *)keyView {
    UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
    keyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return keyView;
}

-(void)inputTag:(HTBToggleButton *)sender {
    if (!sender.selected) {
        if ([self.delegate respondsToSelector:@selector(removeTag:)]) {
            [self.delegate removeTag:sender.titleLabel.text];
        }                
    }
    else {
        if ([self.delegate respondsToSelector:@selector(inputTag:)]) {
            [self.delegate inputTag:sender.titleLabel.text];
        }        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {  
    CGFloat pageWidth = self.inputView.frame.size.width;
    self.pageControl.currentPage = floor((self.inputView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}  

-(void)changePage:(id)sender {  
    CGRect frame = self.inputView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;  
    [self.inputView scrollRectToVisible:frame animated:YES];
}  

@end
