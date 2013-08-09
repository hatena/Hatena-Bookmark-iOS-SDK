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
@synthesize selected = _selected;

-(id)initWithFrame:(CGRect)frame
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
    [self toggleImages];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    _highlightedImage = highlightedImage;
    [self toggleImages];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self toggleImages];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage
{
    _selectedBackgroundImage = selectedBackgroundImage;
    [self toggleImages];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self toggleImages];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    _selectedTitle = selectedTitle;
    [self toggleImages];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self toggleImages];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    [self toggleImages];
}

- (void)toggleButton:(id)sender
{
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self toggleImages];
    }
}

-(void)toggleImages
{
    UIImage *image = self.selected ? self.selectedImage : self.image;
    if (image)
        [self setImage:image forState:UIControlStateNormal];
    
    UIImage *highlightedImage = self.selected ? self.selectedHighlightedImage : self.highlightedImage;
    if (highlightedImage)
        [self setImage:highlightedImage forState:UIControlStateHighlighted];        
    
    UIImage *backgroundImage = self.selected ? self.selectedBackgroundImage : self.backgroundImage;
    if (backgroundImage)
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    UIImage *highlightedBackgroundImage = self.selected ? self.selectedHighlightedBackgroundImage : self.highlightedBackgroundImage;
    if (highlightedBackgroundImage)
        [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    
    UIColor *textColor = self.selected ? self.selectedTextColor : self.textColor;
    if (textColor)
        [self setTitleColor:textColor forState:UIControlStateNormal];
    
    NSString *title = self.selected ? self.selectedTitle : self.title;
    if (title)
        [self setTitle:title forState:UIControlStateNormal];
}

@end
