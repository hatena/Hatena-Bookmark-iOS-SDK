//  HTBHatenaBookmarkAPIClientSpec.m
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

#import "HTBHatenaBookmarkAPIClient.h"
#import "HTBMyTagsEntry.h"
#import "HTBBookmarkEntry.h"
#import "HTBCanonicalEntry.h"
#import "HTBBookmarkedDataEntry.h"

SPEC_BEGIN(HTBHatenaBookmarkAPIClientSpec)

describe(@"HTBHatenaBookmarkAPIClient", ^{

    /**
     This key and secret are for testing.
     These will not be used for other ways.
     **/
    __block NSString *consumerKey = @"dummy";
    __block NSString *consumerSecret = @"dummy";

    __block void (^loginWithClient)(HTBHatenaBookmarkAPIClient *) = ^(HTBHatenaBookmarkAPIClient *bookmarkAPIClient) {
        stubRequest(@"POST", @"https://www.hatena.ne.jp/oauth/initiate").
                andReturn(200).
                withBody(@"oauth_token=dummyiAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&oauth_callback_confirmed=true");
        stubRequest(@"POST", @"https://www.hatena.com/oauth/token").
                andReturn(200).
                withBody(@"oauth_token=dummyoAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&url_name=cinnamon&display_name=%e3%81%97%e3%81%aa%e3%82%82%e3%82%93");

        [[NSNotificationCenter defaultCenter] addObserverForName:kHTBLoginStartNotification
                                                          object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          NSURL *url = [[NSURL alloc] initWithString:@"http://www.hatena.ne.jp/?oauth_token=dummyoAuthToken%3D%3D&oauth_verifier=dummyoAuthVarifier"];
                                                          NSNotification *notification = [NSNotification notificationWithName:kHTBLoginFinishNotification object:nil userInfo:@{ kHTBApplicationLaunchOptionsURLKey : url }];
                                                          [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                      }];
        [bookmarkAPIClient authorizeWithSuccess:nil failure:nil];
    };
    __block HTBHatenaBookmarkAPIClient *client = nil;

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    beforeEach(^{
        client = [[HTBHatenaBookmarkAPIClient alloc] initWithKey:consumerKey
                                                          secret:consumerSecret];
    });

    afterEach(^{
        client = nil;
        [[LSNocilla sharedInstance] clearStubs];
    });

    context(@"oAuth認証", ^{

        it(@"requestTokenが取得できる", ^{

            stubRequest(@"POST", @"https://www.hatena.ne.jp/oauth/initiate").
                    withBody(@"scope=read_private%2Cwrite_public").
                    andReturn(200).
                    withBody(@"oauth_token=dummyoAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&oauth_callback_confirmed=true");

            __block NSURLRequest *request = nil;
            [[NSNotificationCenter defaultCenter] addObserverForName:kHTBLoginStartNotification
                                                              object:nil queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                                                              request = (NSURLRequest *)note.object;
                                                          }];

            [client authorizeWithSuccess:nil failure:nil];
            [[expectFutureValue([request.URL absoluteString]) shouldEventually] equal:@"https://www.hatena.ne.jp/oauth/authorize?oauth_token=dummyoAuthToken%3D%3D"];
        });

        it(@"accessTokenが取得できる", ^{
            loginWithClient(client);
            [[expectFutureValue(client.accessToken) shouldEventually] beNonNil];
        });

    });

    context(@"認証が必要な操作", ^{

        it(@"MyEntryが取得できる", ^{
            NSDictionary *json = @{@"name" : @"hatena",
                    @"plususer" : @0,
                    @"is_oauth_twitter" : @0,
                    @"is_oauth_evernote" : @1,
                    @"is_oauth_facebook" : @1,
                    @"is_oauth_mixi_check" : @1
            };
            NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
            stubRequest(@"GET", @"http://api.b.hatena.ne.jp/1/my.json").
                    andReturn(200).
                    withHeaders(@{@"Content-Type": @"application/json"}).
                    withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

            __block id response = nil;

            [client getMyWithSuccess:^(AFHTTPRequestOperation *operation, id responseJSON) {
                response = responseJSON;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [[expectFutureValue(response) shouldEventually] beNonNil];
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

            [client getMyTagsWithSuccess:^(AFHTTPRequestOperation *operation, id responseJSON) {
                myTagsEntry = [[HTBMyTagsEntry alloc] initWithJSON:responseJSON];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
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
                        withBody(@"comment=tag0&post_evernote=0&post_facebook=1&post_mixi=0&post_twitter=1&private=0&send_mail=0&tags[]=tag0&tags[]=tag1&url=http%3A%2F%2Fb.hatena.ne.jp%2F").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                __block HTBBookmarkedDataEntry *bookmarkedDataEntry = nil;
                [client postBookmarkWithURL:url
                                    comment:@"tag0"
                                       tags:@[@"tag0", @"tag1"]
                                    options:HatenaBookmarkPostOptionTwitter | HatenaBookmarkPostOptionFacebook
                        success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                            bookmarkedDataEntry = [[HTBBookmarkedDataEntry alloc] initWithJSON:responseJSON];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                }];
                [[expectFutureValue(bookmarkedDataEntry) shouldEventually] beNonNil];
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

                [client getBookmarkWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                    bookmarkedDataEntry = [[HTBBookmarkedDataEntry alloc] initWithJSON:responseJSON];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                }];
                [[expectFutureValue(bookmarkedDataEntry) shouldEventually] beNonNil];
                [[expectFutureValue(bookmarkedDataEntry.comment) shouldEventually] equal:@"便利情報"];
                [[expectFutureValue(bookmarkedDataEntry.tags) shouldEventually] have:3];
            });

            it(@"ブックマークの削除", ^{
                NSURL *url = [[NSURL alloc] initWithString:@"http://b.hatena.ne.jp/"];
                stubRequest(@"DELETE", @"http://api.b.hatena.ne.jp/1/my/bookmark.json?url=http%3A%2F%2Fb.hatena.ne.jp%2F").
                        andReturn(200).
                        withHeaders(@{@"Content-Type": @"application/json"}).
                        withBody(@"{\"status\" : \"ok\"}");
                __block id response = nil;
                [client deleteBookmarkWithURL:url
                                      success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                                          response = responseJSON;
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      }];
                [[expectFutureValue(response) shouldEventually] beNonNil];
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
                [client getEntryWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                    bookmarkEntry = [[HTBBookmarkEntry alloc] initWithJSON:responseJSON];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                }];
                [[expectFutureValue(bookmarkEntry) shouldEventually] beNonNil];
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
                [client getCanonicalEntryWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                    canonicalEntry = [[HTBCanonicalEntry alloc] initWithJSON:responseJSON];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                }];
                [[expectFutureValue(canonicalEntry) shouldEventually] beNonNil];
            });

        });
    });

});

SPEC_END