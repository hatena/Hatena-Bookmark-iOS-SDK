//  HTBBookmarkEntrySpec.m
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
#import "HTBBookmarkEntry.h"

SPEC_BEGIN(HTBBookmarkEntrySpec)

describe(@"HTBBookmarkEntry", ^{
    
    NSDictionary *json = @{
                           @"url" : @"http://b.hatena.ne.jp/touch",
                           @"favicon_url" : @"http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch%2F",
                           @"entry_url" : @"http://b.hatena.ne.jp/entry/b.hatena.ne.jp/touch",
                           @"title" : @"はてなブックマーク for iPhone",
                           @"count" : @(467),
                           @"recommend_tags" : @[@"PC", @"iPhone", @"Hatena"],
                           @"smartphone_app_entry_url" : @"http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch"
    };

    __block HTBBookmarkEntry *entry = nil;

    beforeEach(^{
        entry = [[HTBBookmarkEntry alloc] initWithJSON:json];
    });
    
    it(@"BookmarkEntryが生成できる", ^{
        [[[entry.URL absoluteString] should] equal:@"http://b.hatena.ne.jp/touch"];
        [[[entry.faviconURL absoluteString] should] equal:@"http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch%2F"];
        [[[entry.entryURL absoluteString] should] equal:@"http://b.hatena.ne.jp/entry/b.hatena.ne.jp/touch"];
        [[entry.title should] equal:@"はてなブックマーク for iPhone"];
        [[theValue(entry.count) should] equal:theValue(467)];
        [[entry.recommendTags should] contain:@"PC"];
        [[entry.recommendTags should] contain:@"iPhone"];
        [[entry.recommendTags should] contain:@"Hatena"];
        [[[entry.smartphoneAppEntryURL absoluteString] should] equal:@"http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch"];
    });

    it(@"countUsersでユーザーカウントが取得できる", ^{
        [[[entry countUsers] should] equal:@"467 users"];
    });

    it(@"displayURLStringでURL文字列が取得できる", ^{
        [[[entry displayURLString] should] equal:@"b.hatena.ne.jp/touch"];
    });

    it(@"URLスキーマがhttpsのとき、displayURLStringでURL文字列が取得できる", ^{
        entry.URL = [[NSURL alloc] initWithString:@"https://www.google.co.jp"];
        [[[entry displayURLString] should] equal:@"www.google.co.jp"];
    });

});

SPEC_END