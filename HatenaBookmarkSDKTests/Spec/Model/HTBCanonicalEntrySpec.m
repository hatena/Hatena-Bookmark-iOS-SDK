//  HTBCanonicalEntrySpec.m
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
#import "HTBCanonicalEntry.h"
#import "HTBBookmarkEntry.h"

SPEC_BEGIN(HTBCanonicalEntrySpec)

describe(@"HTBCanonicalEntrySpec", ^{
    NSDictionary *json = @{
            @"canonical_url" : @"http://staff.hatenablog.com/canonical",
            @"original_url" : @"http://staff.hatenablog.com/",
            @"canonical_entry" : @{
                    @"smartphone_app_entry_url" : @"http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=http%3A%2F%2Fstaff.hatenablog.com%2F",
                    @"title" : @"はてなブログ開発ブログ",
                    @"entry_url" : @"http://b.hatena.ne.jp/entry/staff.hatenablog.com/",
                    @"url" : @"http://staff.hatenablog.com/",
                    @"favicon_url" : @"http://cdn-ak.favicon.st-hatena.com\/?url=http%3A%2F%2Fstaff.hatenablog.com%2F",
                    @"count" : @101
            }
    };

    __block HTBCanonicalEntry *canonicalEntry = nil;

    beforeEach(^{
        canonicalEntry = [[HTBCanonicalEntry alloc] initWithJSON:json];
    });

    it(@"CanonicalEntryが生成できる", ^{
        [[[canonicalEntry.canonicalURL absoluteString] should] equal:@"http://staff.hatenablog.com/canonical"];
        [[[canonicalEntry.originalURL absoluteString] should] equal:@"http://staff.hatenablog.com/"];
        HTBBookmarkEntry *bookmarkEntry = canonicalEntry.canonicalEntry;
        [[bookmarkEntry.title should] equal:@"はてなブログ開発ブログ"];
    });

    it(@"displayURLStringでURL文字列が取得できる", ^{
        [[[canonicalEntry displayCanonicalURLString] should] equal:@"staff.hatenablog.com/canonical"];
    });

    it(@"URLスキーマがhttpsのとき、displayURLStringでURL文字列が取得できる", ^{
        canonicalEntry.canonicalURL = [[NSURL alloc] initWithString:@"https://www.google.co.jp"];
        [[[canonicalEntry displayCanonicalURLString] should] equal:@"www.google.co.jp"];
    });
});

SPEC_END