//  HTBPlaceholderTextView.m
//  from http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
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

#import "HTBPlaceholderTextView.h"

@interface HTBPlaceholderTextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation HTBPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholderText) {
        [self setPlaceholderText:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholderText:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholderText] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholderText] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholderText;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholderText] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (CGRect)firstRectForRange:(UITextRange *)range
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r1= [self caretRectForPosition:[self positionWithinRange:range farthestInDirection:UITextLayoutDirectionRight]];
        CGRect r2= [self caretRectForPosition:[self positionWithinRange:range farthestInDirection:UITextLayoutDirectionLeft]];
        return CGRectUnion(r1,r2);
    }
    return [super firstRectForRange:range];
}

- (NSUInteger)characterIndexForPoint:(CGPoint)point
{
    if (self.text.length == 0) {
        return 0;
    }
    
    CGRect r1;
    if ([[self.text substringFromIndex:self.text.length - 1] isEqualToString:@"\n"]) {
        r1 = [super caretRectForPosition:[super positionFromPosition:self.endOfDocument offset:-1]];
        CGRect sr = [super caretRectForPosition:[super positionFromPosition:self.beginningOfDocument offset:0]];
        r1.origin.x = sr.origin.x;
        r1.origin.y += self.font.lineHeight;
    } else {
        r1 = [super caretRectForPosition:[super positionFromPosition:self.endOfDocument offset:0]];
    }
    
    if ((point.x > r1.origin.x && point.y >= r1.origin.y) || point.y >= r1.origin.y + r1.size.height) {
        return [super offsetFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    }
    
    CGFloat fraction;
    NSUInteger index = [self.textStorage.layoutManagers[0] characterIndexForPoint:point inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:&fraction];
    
    return index;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        point.y -= self.font.lineHeight / 2;
        NSUInteger index = [self characterIndexForPoint:point];
        UITextPosition *pos = [self positionFromPosition:self.beginningOfDocument offset:index];
        return pos;
    }
    
    return [super closestPositionToPoint:point];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [super scrollRangeToVisible:range];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        if (self.layoutManager.extraLineFragmentTextContainer != nil && self.selectedRange.location == range.location) {
            CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.end];
            [self scrollRectToVisible:caretRect animated:NO];
        }
    }
}

@end
