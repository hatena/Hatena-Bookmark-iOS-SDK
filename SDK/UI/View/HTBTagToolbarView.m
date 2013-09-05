//  HTBTagToolbarView.m
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

#import "HTBTagToolbarView.h"
#import "HTBUtility.h"
#import "HTBMacro.h"
#define HTB_TAG_TOOLBAR_VIEW_SIDE_MARGIN 20
#define HTB_TAG_TOOLBAR_VIEW_VERTICAL_MARGIN 8

@implementation HTBTagToolbarView {
    UIBarButtonItem *_segmentedControlItem;
}

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
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[[HTBUtility localizedStringForKey:@"keyboard" withDefault:@"Keyboard"],  [HTBUtility localizedStringForKey:@"recommended" withDefault:@"Recommended"],  [HTBUtility localizedStringForKey:@"tags" withDefault:@"Tags"]]];
     _segmentedControlItem = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentedControl.selectedSegmentIndex = 0;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.items = @[spacer, _segmentedControlItem, spacer];
    if (!HTB_IS_RUNNING_IOS7) { // on iOS7, tintColor of separated controller will be default one.
        self.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _segmentedControl.frame = CGRectInset(CGRectMake(0, 0, self.superview.bounds.size.width, self.bounds.size.height), HTB_TAG_TOOLBAR_VIEW_SIDE_MARGIN, HTB_TAG_TOOLBAR_VIEW_VERTICAL_MARGIN);
}

@end
