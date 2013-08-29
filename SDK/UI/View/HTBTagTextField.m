//  HTBTagTextField.m
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

#import "HTBTagTextField.h"
#import "HTBTagInputView.h"
#import "HTBTagTokenizer.h"
#import "HTBTagToolbarView.h"

#define HTB_TAG_TEXT_FIELD_MAX_TAG_NUM 10
#define HTB_TAG_TEXT_FIELD_MY_TAG_MAX_NUM 100
#define HTB_TAG_TEXT_FIELD_KEYBOARD_HEIGT 216

@interface HTBTagTextField ()
@property (nonatomic, strong) HTBTagToolbarView *tagToolbarView;
@property (nonatomic, strong) HTBTagInputView *myTagInputView;
@property (nonatomic, strong) HTBTagInputView *recommendedTagInputView;
@end


@implementation HTBTagTextField

-(void)awakeFromNib {
    [super awakeFromNib];
    [self inputAccessoryView];
}

- (UIView *)inputAccessoryView {
    if (!_tagToolbarView) {
        _tagToolbarView = [[HTBTagToolbarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        [_tagToolbarView.segmentedControl addTarget:self action:@selector(tagModeChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _tagToolbarView;
}

-(void)tagModeChanged:(UISegmentedControl *)sender
{
    self.mode = sender.selectedSegmentIndex;
    [self reloadInputViews];
}

-(BOOL)canInputTag {
    return [self.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 300;
}

-(NSArray *)inputTags {
    return [HTBTagTokenizer spaceTextToTagArray:self.text];
}

-(void)recommendTag {
    self.mode = RecommendedTagsInputMode;
    [self reloadInputViews];
}

-(void)myTag {
    self.mode = MyTagsInputMode;
    [self reloadInputViews];
}

-(void)keybord {
    self.mode = TextInputMode;
    [self reloadInputViews];
}

-(void)backspace {
    if (self.text.length)
        self.text = [self.text substringToIndex:self.text.length - 1];
}

-(HTBTagInputView *)inputScrollViewWithTags:(NSArray *)tags {
    HTBTagInputView *inputView = [[HTBTagInputView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, HTB_TAG_TEXT_FIELD_KEYBOARD_HEIGT) tags:tags];
    inputView.delegate = self;
    return inputView;
}

-(void)toggleTagButtons {
    NSArray *tags = [HTBTagTokenizer spaceTextToTagArray:self.text];
    [self.myTagInputView toggleTagButtons:tags];
    [self.recommendedTagInputView toggleTagButtons:tags];
}

-(UIView *)inputView {
    switch (self.mode) {
        case RecommendedTagsInputMode:
            if (!self.recommendedTagInputView) {
                self.recommendedTagInputView = [self inputScrollViewWithTags:self.recommendedTags];
            }
            [self toggleTagButtons];
            return self.recommendedTagInputView;
            break;
        case MyTagsInputMode:
            if (!self.myTagInputView) {
                self.myTagInputView = [self inputScrollViewWithTags:[self.myTags subarrayWithRange:NSMakeRange(0, fmin(self.myTags.count, HTB_TAG_TEXT_FIELD_MY_TAG_MAX_NUM))]];
            }
            [self toggleTagButtons];
            return self.myTagInputView;
            break;
        case TextInputMode:
            return nil;
            break;
        default:
            break;
    }
    return nil;
}

-(void)removeTag:(NSString *)removeTag {
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[HTBTagTokenizer spaceTextToTagArray:self.text]];
    int removeIndex = -1;
    for (int i = 0; i < tags.count; i++) {
        if ([[tags objectAtIndex:i] caseInsensitiveCompare:removeTag] == NSOrderedSame) {
            removeIndex = i;
            break;
        }
    }
    if (removeIndex >= 0) {
        [tags removeObjectAtIndex:removeIndex];
    }
    
    self.text = [HTBTagTokenizer tagArrayToSpaceText:tags];
    [self.myTagInputView toggleTagButtons:tags];
    [self.recommendedTagInputView toggleTagButtons:tags];
}

-(void)inputTag:(NSString *)tag {
    NSMutableString *tagText = [NSMutableString stringWithString:self.text];    
    if (self.text.length) {
        [tagText appendString:@" "];
    }
    if ([tag rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        [tagText appendFormat:@"[%@]", tag];
    }
    else {
        [tagText appendString:tag];
    }
    self.text = tagText;
    [self toggleTagButtons];
}

@end
