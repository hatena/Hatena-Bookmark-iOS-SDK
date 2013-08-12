//  HTBToggleButton.m
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

#import "HTBToggleButton.h"

@implementation HTBToggleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    _highlightedImage = highlightedImage;
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setSelectedHighlightedImage:(UIImage *)selectedHighlightedImage
{
    _selectedHighlightedImage = selectedHighlightedImage;
    [self setImage:selectedHighlightedImage forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
    _highlightedBackgroundImage = highlightedBackgroundImage;
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage
{
    _selectedBackgroundImage = selectedBackgroundImage;
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
}

- (void)setSelectedHighlightedBackgroundImage:(UIImage *)selectedHighlightedBackgroundImage
{
    _selectedHighlightedBackgroundImage = selectedHighlightedBackgroundImage;
    [self setBackgroundImage:selectedHighlightedBackgroundImage forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    _selectedTitle = selectedTitle;
    [self setTitle:selectedTitle forState:UIControlStateSelected];
    [self setTitle:selectedTitle forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    [self setTitleColor:selectedTextColor forState:UIControlStateSelected];
    [self setTitleColor:selectedTextColor forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)toggleButton:(id)sender
{
    self.selected = !self.selected;
}

@end
