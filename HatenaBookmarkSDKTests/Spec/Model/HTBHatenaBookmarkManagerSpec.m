//  HTBHatenaBookmarkManagerSpec.m
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
#import "Nocilla.h"

#import "HTBHatenaBookmarkManager.h"
#import "HTBMyEntry.h"
#import "HTBBookmarkedDataEntry.h"
#import "HTBBookmarkEntry.h"
#import "HTBCanonicalEntry.h"
#import "HTBMyTagsEntry.h"
#import "HTBUserManager.h"

SPEC_BEGIN(HTBHatenaBookmarkManagerSpec)

describe(@"HTBHatenaBookmarkManager", ^{

    __block id loginStartObserver = nil;

    it(@"sharedManagerが取得できる", ^{
        HTBHatenaBookmarkManager *hatenaBookmarkManager = [HTBHatenaBookmarkManager sharedManager];
        HTBHatenaBookmarkManager *otherManager = [HTBHatenaBookmarkManager sharedManager];
        [[hatenaBookmarkManager should] beNonNil];
        [[hatenaBookmarkManager should] equal:otherManager];
    });

    context(@"認証が必要な操作", ^{

        __block void (^login)(void (^)(void)) = ^ (void (^success)(void)){
            stubRequest(@"POST", @"https://www.hatena.ne.jp/oauth/initiate").
            
            andReturn(200).
                    withBody(@"oauth_token=dummyoAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&oauth_callback_confirmed=true");
            stubRequest(@"POST", @"https://www.hatena.com/oauth/token").
                    andReturn(200).
                    withBody(@"oauth_token=dummyoAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&url_name=cinnamon&display_name=%e3%81%97%e3%81%aa%e3%82%82%e3%82%93");

            loginStartObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kHTBLoginStartNotification
                                                                                   object:nil queue:[NSOperationQueue mainQueue]
                                                                               usingBlock:^(NSNotification *note) {
                                                                                   NSURL *url = [[NSURL alloc] initWithString:@"http://www.hatena.ne.jp/?oauth_token=dummyoAuthToken%3D%3D&oauth_verifier=dummyoAuthVarifier"];
                                                                                   NSNotification *notification = [NSNotification notificationWithName:kHTBLoginFinishNotification object:nil userInfo:@{ kHTBApplicationLaunchOptionsURLKey : url }];
                                                                                   [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                                               }];

            [[HTBHatenaBookmarkManager sharedManager] authorizeWithSuccess:success failure:nil];
        };

        beforeAll(^{
            [[HTBHatenaBookmarkManager sharedManager] setConsumerKey:@"dummy" consumerSecret:@"dummy"];
            [[LSNocilla sharedInstance] start];
        });

        afterAll(^{
            [[LSNocilla sharedInstance] stop];
        });

        afterEach(^{
            [[LSNocilla sharedInstance] clearStubs];
            [[HTBHatenaBookmarkManager sharedManager] logout];
            [[NSNotificationCenter defaultCenter] removeObserver:loginStartObserver];
        });

        context(@"oAuth認証", ^{

            it(@"ログインができる", ^{
                __block BOOL authorized = NO;
                login(^{
                    authorized = YES;
                });
                [[expectFutureValue(theValue(authorized)) shouldEventually] beYes];
                [[expectFutureValue(theValue([HTBHatenaBookmarkManager sharedManager].userManager.token)) shouldEventually] beNonNil];
                [[expectFutureValue(theValue([HTBHatenaBookmarkManager sharedManager].authorized)) shouldEventually] beYes];
            });

            it(@"ログイン時、ユーザー名、表示名が取り出せる", ^{
                login(nil);
                [[expectFutureValue([HTBHatenaBookmarkManager sharedManager].username) shouldEventually] equal:@"cinnamon"];
                [[expectFutureValue([HTBHatenaBookmarkManager sharedManager].displayName) shouldEventually] equal:@"しなもん"];
            });

        });

        it(@"MyEntryが取得できる", ^{
            NSDictionary *json = @{@"name" : @"hatena",
                    @"plususer" : @1,
                    @"is_oauth_twitter" : @1,
                    @"is_oauth_evernote" : @0,
                    @"is_oauth_facebook" : @0,
                    @"is_oauth_mixi_check" : @0
            };
            NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
            stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/my.json").
                    andReturn(200).
                    withHeaders(@{@"Content-Type": @"application/json"}).
                    withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

            __block HTBMyEntry *responseMyEntry = nil;
            [[HTBHatenaBookmarkManager sharedManager] getMyEntryWithSuccess:^(HTBMyEntry *myEntry) {
                responseMyEntry = myEntry;
            } failure:nil];
            [[expectFutureValue(responseMyEntry) shouldEventually] beNonNil];
            [[expectFutureValue(responseMyEntry.name) shouldEventually] equal:@"hatena"];
            [[expectFutureValue(theValue(responseMyEntry.isPlususer)) shouldEventually] beYes];
            [[expectFutureValue(theValue(responseMyEntry.isOAuthTwitter)) shouldEventually] beYes];
            [[expectFutureValue(theValue(responseMyEntry.isOAuthEvernote)) shouldEventually] beNo];
            [[expectFutureValue(theValue(responseMyEntry.isOAuthFacebook)) shouldEventually] beNo];
            [[expectFutureValue(theValue(responseMyEntry.isOAuthMixiCheck)) shouldEventually] beNo];
        });

        it(@"タグ一覧が取得できる", ^{
            NSDictionary *json = @{@"tags" : @[
                    @{@"tag" : @"hatena", @"count" : @100},
                    @{@"tag" : @"twitter", @"count" : @30},
                    @{@"tag" : @"facebook", @"count" : @999},
                    @{@"tag" : @"instagram", @"count" : @50}
            ]};

            NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
            stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/my/tags.json").
                    andReturn(200).
                    withHeaders(@{@"Content-Type": @"application/json"}).
                    withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

            __block HTBMyTagsEntry *myTagsEntry = nil;

            [[HTBHatenaBookmarkManager sharedManager] getMyTagsWithSuccess:^(HTBMyTagsEntry *entry) {
                myTagsEntry = entry;
            } failure:nil];
            [[expectFutureValue(myTagsEntry) shouldEventually] beNonNil];
            [[expectFutureValue(myTagsEntry.tags) shouldEventually] haveCountOf:4];
        });

        context(@"ブックマーク", ^{

            it(@"ブックマークの追加", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://b.hatena.ne.jp/"];
                NSDictionary *json = @{
                        @"comment" : @"便利情報",
                        @"tags" : @[@"これはひどい", @"あとで読む", @"増田"],
                        @"created_epoch" : @1333234800,
                        @"private" : @1
                };
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
                stubRequest(@"POST", @"http://api.b.hatena.ne.jp/1/my/bookmark.json").
                        withBody(@"comment=%E4%BE%BF%E5%88%A9%E6%83%85%E5%A0%B1&post_evernote=0&post_facebook=1&post_mixi=0&post_twitter=1&private=1&send_mail=0&tags[]=%E3%81%93%E3%82%8C%E3%81%AF%E3%81%B2%E3%81%A9%E3%81%84&tags[]=%E3%81%82%E3%81%A8%E3%81%A7%E8%AA%AD%E3%82%80&tags[]=%E5%A2%97%E7%94%B0&url=http%3A%2F%2Fb.hatena.ne.jp%2F").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                __block HTBBookmarkedDataEntry *bookmarkedDataEntry = nil;
                [[HTBHatenaBookmarkManager sharedManager] postBookmarkWithURL:url
                                                                      comment:json[@"comment"]
                                                                         tags:json[@"tags"]
                                                                      options:HatenaBookmarkPostOptionTwitter | HatenaBookmarkPostOptionFacebook | HatenaBookmarkPostOptionPrivate
                                                                      success:^(HTBBookmarkedDataEntry *entry) {
                                                                          bookmarkedDataEntry = entry;
                                                                      } failure:nil];
                [[expectFutureValue(bookmarkedDataEntry) shouldEventually] beNonNil];
                [[expectFutureValue(bookmarkedDataEntry.comment) shouldEventually] equal:json[@"comment"]];
                [[expectFutureValue(bookmarkedDataEntry.tags) shouldEventually] have:3];
                [[expectFutureValue(theValue(bookmarkedDataEntry.isPrivate)) shouldEventually] beYes];
            });

            it(@"ブックマーク情報の取得", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://b.hatena.ne.jp/"];
                NSDictionary *json = @{
                        @"comment" : @"便利情報",
                        @"tags" : @[@"これはひどい", @"あとで読む", @"増田"],
                        @"created_epoch" : @1333234800,
                        @"private" : @1
                };

                __block HTBBookmarkedDataEntry *bookmarkedDataEntry = nil;
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
                stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/my/bookmark.json?url=http%3A%2F%2Fb.hatena.ne.jp%2F").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                [[HTBHatenaBookmarkManager sharedManager] getBookmarkedDataEntryWithURL:url
                                                                                success:^(HTBBookmarkedDataEntry * entry) {
                                                                                   bookmarkedDataEntry = entry;
                                                                                } failure:nil];
                [[expectFutureValue(bookmarkedDataEntry) shouldEventually] beNonNil];
                [[expectFutureValue(bookmarkedDataEntry.comment) shouldEventually] equal:@"便利情報"];
                [[expectFutureValue(bookmarkedDataEntry.tags) shouldEventually] have:3];
                [[expectFutureValue(theValue(bookmarkedDataEntry.isPrivate)) shouldEventually] beYes];
            });

            it(@"ブックマークの削除", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://b.hatena.ne.jp/"];
                stubRequest(@"DELETE", @"http://api.b.hatena.ne.jp/1/my/bookmark.json?url=http%3A%2F%2Fb.hatena.ne.jp%2F").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody(@"{\"status\" : \"ok\"}");
                __block BOOL deleted = NO;
                [[HTBHatenaBookmarkManager sharedManager] deleteBookmarkWithURL:url
                                                                        success:^{
                                                                            deleted = YES;
                                                                        } failure:nil];
                [[expectFutureValue(theValue(deleted)) shouldEventually] beYes];
            });

        });

        context(@"エントリー", ^{

            it(@"エントリー情報の取得", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://b.hatena.ne.jp/"];
                NSDictionary *json = @{
                        @"url" : @"http://b.hatena.ne.jp/touch",
                        @"favicon_url" : @"http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch%2F",
                        @"entry_url" : @"http://b.hatena.ne.jp/entry/b.hatena.ne.jp/touch",
                        @"title" : @"はてなブックマーク for iPhone",
                        @"count" : @(467),
                        @"recommend_tags" : @[@"PC", @"iPhone", @"Hatena"],
                        @"smartphone_app_entry_url" : @"http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=http%3A%2F%2Fb.hatena.ne.jp%2Ftouch"
                };
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];

                stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/entry.json?url=http%3A%2F%2Fb.hatena.ne.jp%2F&with_tag_recommendations=1").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                __block HTBBookmarkEntry *bookmarkEntry = nil;
                [[HTBHatenaBookmarkManager sharedManager] getBookmarkEntryWithURL:url success:^(HTBBookmarkEntry *entry) {
                    bookmarkEntry = entry;
                } failure:nil];
                [[expectFutureValue(bookmarkEntry) shouldEventually] beNonNil];
                [[expectFutureValue(bookmarkEntry.entryURL) shouldEventually] equal:[[NSURL alloc] initWithString:json[@"entry_url"]]];
                [[expectFutureValue(bookmarkEntry.title) shouldEventually] equal:json[@"title"]];
                [[expectFutureValue(theValue(bookmarkEntry.count)) shouldEventually] equal:theValue([json[@"count"] intValue])];
            });

            it(@"エントリーの正規化", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://staff.hatenablog.com"];
                NSDictionary *json = @{
                        @"canonical_url" : @"http://staff.hatenablog.com/",
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
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];

                stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/canonical_entry.json?url=http%3A%2F%2Fstaff.hatenablog.com").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                __block HTBCanonicalEntry *canonicalEntry = nil;
                [[HTBHatenaBookmarkManager sharedManager] getCanonicalEntryWithURL:url success:^(HTBCanonicalEntry *entry) {
                    canonicalEntry = entry;
                } failure:nil];
                [[expectFutureValue(canonicalEntry) shouldEventually] beNonNil];
                [[expectFutureValue(canonicalEntry.canonicalURL) shouldEventually] equal:[[NSURL alloc] initWithString:@"http://staff.hatenablog.com/"]];
            });

        });

    });

});

SPEC_END