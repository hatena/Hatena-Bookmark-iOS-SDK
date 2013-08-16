//  HTBTagTokenizerSpec.m
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

#import "Kiwi.h"
#import "HTBTagTokenizer.h"

SPEC_BEGIN(HTBTagTokenizerSpec)

describe(@"HTBTagTokenizerSpec", ^{
    
    context(@"bracedTextToTagArray", ^{
        it(@"bracketedTextToTagArrayで文字列からタグ一覧にできる", ^{
            NSString *text = @"[Apple][iPhone][iPad][iOS]";
            NSArray *tags = [HTBTagTokenizer bracketedTextToTagArray:text];
            [[tags should] haveCountOf:4];
            [[tags[0] should] equal:@"Apple"];
            [[tags[1] should] equal:@"iPhone"];
            [[tags[2] should] equal:@"iPad"];
            [[tags[3] should] equal:@"iOS"];
        });
        
        it(@"空文字を含むbracketedTextをタグ一覧にできる", ^{
            NSString *text = @"[Apple][iPhone][][][iOS]";
            NSArray *tags = [HTBTagTokenizer bracketedTextToTagArray:text];
            [[tags should] haveCountOf:2];
            [[tags[0] should] equal:@"Apple"];
            [[tags[1] should] equal:@"iPhone"];
        });
        
        it(@"閉じられていないbracketedTextをタグ一覧にできる", ^{
            NSString *text = @"[Apple][iOS[iPhone]";
            NSArray *tags = [HTBTagTokenizer bracketedTextToTagArray:text];
            [[tags should] haveCountOf:1];
            [[tags[0] should] equal:@"Apple"];
        });
        
        it(@"入れ子になっているbracketedTextをタグ一覧にできる", ^{
            NSString *text = @"[iPad][[[Apple]][iPhone]][iOS]";
            NSArray *tags = [HTBTagTokenizer bracketedTextToTagArray:text];
            [[tags should] haveCountOf:1];
            [[tags[0] should] equal:@"iPad"];
        });
        
        it(@"入れ子になっているbracketedTextをタグ一覧にできる", ^{
            NSString *text = @"[][iPad][[[Apple]][iPhone]][iOS]";
            NSArray *tags = [HTBTagTokenizer bracketedTextToTagArray:text];
            [[tags should] haveCountOf:0];
        });
    });
    
    context(@"spaceTextToTagArray", ^{
        it(@"spaceTextToTagArrayで文字列からタグ一覧にできる", ^{
            NSString *text = @"Apple iPhone iPad iOS";
            NSArray *tags = [HTBTagTokenizer spaceTextToTagArray:text];
            [[tags should] haveCountOf:4];
            [[tags[0] should] equal:@"Apple"];
            [[tags[1] should] equal:@"iPhone"];
            [[tags[2] should] equal:@"iPad"];
            [[tags[3] should] equal:@"iOS"];
        });
    });
    
    it(@"tagArrayToBracketedTextでタグ一覧から文字列にできる", ^{
        NSArray *tags = @[@"tag0", @"tag1", @"tag2", @"tag3"];
        NSString *bracketedText = [HTBTagTokenizer tagArrayToBracketedText:tags];
        [[bracketedText should] equal:@"[tag0][tag1][tag2][tag3]"];
    });
    
    it(@"tagArrayToSpaceTextでタグ一覧から文字列にできる", ^{
        NSArray *tags = @[@"tag0", @"tag1", @"tag2", @"tag3"];
        NSString *spaceText = [HTBTagTokenizer tagArrayToSpaceText:tags];
        [[spaceText should] equal:@"tag0 tag1 tag2 tag3"];
    });
    
});

SPEC_END