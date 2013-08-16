//  HTBTagEntrySpec.m
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
#import "HTBTagEntry.h"
#import "HTBMyTagsEntry.h"

SPEC_BEGIN(HTBTagEntrySpec)

describe(@"HTBTagEntry", ^{
    
    NSDictionary *json = @{
                           @"tag" : @"hatena",
                           @"count" : @100
    };

    __block HTBTagEntry *tagEntry = nil;
    
    beforeAll(^{
        tagEntry = [[HTBTagEntry alloc] initWithJSON:json];
    });
    
    it(@"TagEntryが生成できる", ^{
        [[tagEntry.tag should] equal:@"hatena"];
        [[theValue(tagEntry.count) should] equal:theValue(100)];
    });

});

describe(@"HTBMyTagsEntry", ^{
    
    NSDictionary *json = @{@"tags" : @[
                  @{@"tag" : @"hatena", @"count" : @100},
                  @{@"tag" : @"twitter", @"count" : @30},
                  @{@"tag" : @"facebook", @"count" : @999},
                  @{@"tag" : @"instagram", @"count" : @50}
    ]};
    
    __block HTBMyTagsEntry *myTagsEntry = nil;
    
    beforeAll(^{
        myTagsEntry = [[HTBMyTagsEntry alloc] initWithJSON:json];
    });
    
    it(@"MyTagsEntryが生成できる", ^{
        [[myTagsEntry.tags should] haveCountOf:4];
        [[[(HTBTagEntry *)myTagsEntry.tags[0] tag] should] equal:@"hatena"];
        [[theValue([(HTBTagEntry *)myTagsEntry.tags[0] count]) should] equal:theValue(100)];
        [[[(HTBTagEntry *)myTagsEntry.tags[1] tag] should] equal:@"twitter"];
        [[theValue([(HTBTagEntry *)myTagsEntry.tags[1] count]) should] equal:theValue(30)];
        [[[(HTBTagEntry *)myTagsEntry.tags[2] tag] should] equal:@"facebook"];
        [[theValue([(HTBTagEntry *)myTagsEntry.tags[2] count]) should] equal:theValue(999)];
        [[[(HTBTagEntry *)myTagsEntry.tags[3] tag] should] equal:@"instagram"];
        [[theValue([(HTBTagEntry *)myTagsEntry.tags[3] count]) should] equal:theValue(50)];
    });
    
    it(@"sortedTagsで正しくソートできる", ^{
        NSArray *sorted = myTagsEntry.sortedTags;
        [[[(HTBTagEntry *)sorted[0] tag] should] equal:@"facebook"];
        [[[(HTBTagEntry *)sorted[1] tag] should] equal:@"hatena"];
        [[[(HTBTagEntry *)sorted[2] tag] should] equal:@"instagram"];
        [[[(HTBTagEntry *)sorted[3] tag] should] equal:@"twitter"];
    });
    
});

SPEC_END