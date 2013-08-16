//  HTBBookmarkedDataEntrySpec.m
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
#import "HTBBookmarkedDataEntry.h"

SPEC_BEGIN(HTBBookmarkedDataEntrySpec)

describe(@"HTBBookmarkedDataEntry", ^{
    
    NSDictionary *json = @{
                           @"comment" : @"便利情報",
                           @"tags" : @[@"これはひどい", @"あとで読む", @"増田"],
                           @"created_epoch" : @1333234800,
                           @"private" : @1
    };
    __block HTBBookmarkedDataEntry *dataEntry = nil;
    
    beforeAll(^{
        dataEntry = [[HTBBookmarkedDataEntry alloc] initWithJSON:json];
    });
    
    it(@"BookmarkedDataEntryが生成できる", ^{
        [[dataEntry.comment should] equal:@"便利情報"];
        [[dataEntry.tags should] haveCountOf:3];
        [[dataEntry.tags should] containObjectsInArray:@[@"これはひどい", @"あとで読む", @"増田"]];

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1333234800];
        [[dataEntry.modified should] equal:date];

        [[theValue(dataEntry.isPrivate) should] beYes];

    });
    
});


SPEC_END