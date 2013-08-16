//  HTBMyEntrySpec.m
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
#import "HTBMyEntry.h"

SPEC_BEGIN(HTBMyEntrySpec)

describe(@"HTBMyEntry", ^{
    
    NSDictionary *json = @{
                           @"name" : @"hatena",
                           @"plususer" : @"0",
                           @"is_oauth_twitter" : @0,
                           @"is_oauth_evernote" : @1,
                           @"is_oauth_facebook" : @1,
                           @"is_oauth_mixi_check" : @1
    };

    __block HTBMyEntry *myEntry = nil;
    
    beforeAll(^{
        myEntry = [[HTBMyEntry alloc] initWithJSON:json];
    });
    
    it(@"MyEntryが生成できる", ^{
        [[myEntry.name should] equal:@"hatena"];
        [[theValue(myEntry.isPlususer) should] beNo];
        [[theValue(myEntry.isOAuthTwitter) should] beNo];
        [[theValue(myEntry.isOAuthEvernote) should] beYes];
        [[theValue(myEntry.isOAuthFacebook) should] beYes];
        [[theValue(myEntry.isOAuthMixiCheck) should] beYes];
    });

    it(@"MyEntryをエンコードできる", ^{
        [[myEntry should] conformToProtocol:@protocol(NSCoding)];
        [[theBlock(^{
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myEntry];
            [[data should] beNonNil];
        }) shouldNot] raise];
    });

    it(@"MyEntryをデコードできる", ^{
        [[myEntry should] conformToProtocol:@protocol(NSCoding)];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myEntry];
        NSObject<NSCoding> *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [[decodedObject should] beKindOfClass:[HTBMyEntry class]];

        HTBMyEntry *newEntry = (HTBMyEntry *)decodedObject;

        [[newEntry.name should] equal:@"hatena"];
        [[theValue(newEntry.isPlususer) should] beNo];
        [[theValue(newEntry.isOAuthTwitter) should] beNo];
        [[theValue(newEntry.isOAuthEvernote) should] beYes];
        [[theValue(newEntry.isOAuthFacebook) should] beYes];
        [[theValue(newEntry.isOAuthMixiCheck) should] beYes];
    });
    
    
});

SPEC_END