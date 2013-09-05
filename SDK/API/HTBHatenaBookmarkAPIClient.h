//  HTBHatenaBookmarkAPIClient.h
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


#import <Foundation/Foundation.h>
#import "HTBAFOAuth1Client.h"

typedef NS_OPTIONS(NSUInteger, HatenaBookmarkPOSTOptions) {
    HatenaBookmarkPostOptionNone            = 0,
    HatenaBookmarkPostOptionTwitter         = 1 << 0,
    HatenaBookmarkPostOptionFacebook        = 1 << 1,
    HatenaBookmarkPostOptionMixi            = 1 << 2,
    HatenaBookmarkPostOptionEvernote        = 1 << 3,
    HatenaBookmarkPostOptionSendMail        = 1 << 4,
    HatenaBookmarkPostOptionPrivate         = 1 << 5,
};

extern NSString * const kHTBLoginStartNotification;
extern NSString * const kHTBLoginFinishNotification;
extern NSString * const kHTBApplicationLaunchOptionsURLKey;

@interface HTBHatenaBookmarkAPIClient : HTBAFOAuth1Client

+ (instancetype)sharedClientWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

// Initialize client with consumer key and consumer secret. Those keys set as global valiable.
- (id)initWithKey:(NSString *)key secret:(NSString *)secret;

// Authorize with OAuth.
- (void)authorizeWithSuccess:(void (^)(AFOAuth1Token *accessToken, id responseObject))success
                     failure:(void (^)(NSError *error))failure;

// Get your user information.
- (void)getMyWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get your tags.
- (void)getMyTagsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get public entry information.
- (void)getEntryWithURL:(NSURL *)bookmarkURL
                success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get canonical information.
- (void)getCanonicalEntryWithURL:(NSURL *)bookmarkURL
                success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get your bookmark information.
- (void)getBookmarkWithURL:(NSURL *)bookmarkURL
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Add or edit your bookmark.
- (void)postBookmarkWithURL:(NSURL *)bookmarkURL
                    comment:(NSString *)comment
                       tags:(NSArray *)tags
                    options:(HatenaBookmarkPOSTOptions)options
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Delete your bookmark.
- (void)deleteBookmarkWithURL:(NSURL *)bookmarkURL
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
