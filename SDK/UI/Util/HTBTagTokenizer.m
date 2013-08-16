//  HTBTagTokenizer.m
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

#import "HTBTagTokenizer.h"

@implementation HTBTagTokenizer

+ (NSArray *)bracketedTextToTagArray:(NSString *)bracketText
{
    NSError *error = nil;
    NSRegularExpression *prefix = [NSRegularExpression regularExpressionWithPattern:@"^(\\[[^\\]\\[]+\\])+"
                                                                            options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSArray *result = [prefix matchesInString:bracketText
                                      options:0
                                        range:NSMakeRange(0, bracketText.length)];
    if ([result count] > 0) {
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"\\[([^\\]]+)\\]"
                                      options:NSRegularExpressionAllowCommentsAndWhitespace
                                      error:&error];
        NSRange range = [result[0] rangeAtIndex:0];
        NSString *prefixText = [bracketText substringWithRange:range];
        return [self textToTagArray:prefixText regex:regex];
    }
    return @[];
}

+ (NSArray *)textToTagArray:(NSString *)text regex:(NSRegularExpression *)regex
{
    NSMutableArray *tags = [@[] mutableCopy];
    if (text.length > 0) {
        NSArray *matchResults = [regex matchesInString:text
                                               options:0
                                                 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *match in matchResults) {
            NSRange range = NSMakeRange(NSNotFound, 0);
            for (int i = 1; i <= 2; i++) {
                NSRange matchRange = [match rangeAtIndex:i];
                if (matchRange.location != NSNotFound) {
                    range = matchRange;
                    break;
                }
            }
            if (range.location != NSNotFound) {
                NSString *tag = [text substringWithRange:range];
                [tags addObject:tag];
            }
        }
    }
    return tags;
}

+(NSArray *)spaceTextToTagArray:(NSString *)spaceText {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(?:\\[([^\\]]+)\\]|([^\\s]+))"
                                  options:NSRegularExpressionAllowCommentsAndWhitespace
                                  error:&error];
    return [self textToTagArray:spaceText regex:regex];
}

+ (NSString *)tagArrayToBracketedText:(NSArray *)tags
{
    NSMutableString *bracketText = [NSMutableString string];
    for (NSString *tag in tags) {
        [bracketText appendFormat:@"[%@]", tag];
    }
    return bracketText;
}

+ (NSString *)tagArrayToSpaceText:(NSArray *)tags
{
    NSMutableString *spaceText = [NSMutableString string];
    for (NSString *tag in tags) {
        NSRange range = [tag rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (spaceText.length) {
            [spaceText appendString:@" "];
        }
        if (range.location != NSNotFound) {
            [spaceText appendFormat:@" [%@]", tag];
        }
        else {
            [spaceText appendString:tag];
        }
    }
    return spaceText;
}

@end
