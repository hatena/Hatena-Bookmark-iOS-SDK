//  HTBHatenaBookmarkManager.h
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
#import "HTBHatenaBookmarkAPIClient.h"

@class HTBHatenaBookmarkAPIClient;
@class HTBUserManager;
@class HTBMyEntry;
@class HTBBookmarkEntry;
@class HTBMyTagsEntry;
@class HTBBookmarkedDataEntry;
@class HTBCanonicalEntry;

@interface HTBHatenaBookmarkManager : NSObject

@property (nonatomic, strong) HTBHatenaBookmarkAPIClient *apiClient;
@property (nonatomic, strong) HTBUserManager *userManager;
@property (nonatomic, readonly, assign) BOOL authorized;
@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *displayName;

+ (instancetype)sharedManager;

- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

- (void)authorizeWithSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;

- (void)getMyEntryWithSuccess:(void (^)(HTBMyEntry *myEntry))success
                      failure:(void (^)(NSError *error))failure;

- (void)getMyTagsWithSuccess:(void (^)(HTBMyTagsEntry *))success
                     failure:(void (^)(NSError *error))failure;

- (void)getBookmarkEntryWithURL:(NSURL *)url
                        success:(void (^)(HTBBookmarkEntry *entry))success
                        failure:(void (^)(NSError *error))failure;

- (void)getCanonicalEntryWithURL:(NSURL *)url
                        success:(void (^)(HTBCanonicalEntry *canonicalEntry))success
                        failure:(void (^)(NSError *error))failure;


- (void)getBookmarkedDataEntryWithURL:(NSURL *)url
                              success:(void (^)(HTBBookmarkedDataEntry *entry))success
                              failure:(void (^)(NSError *error))failure;
// Add or edit your bookmark.
- (void)postBookmarkWithURL:(NSURL *)url
                    comment:(NSString *)comment
                       tags:(NSArray *)tags
                    options:(HatenaBookmarkPOSTOptions)options
                    success:(void (^)(HTBBookmarkedDataEntry *entry))success
                    failure:(void (^)(NSError *error))failure;

- (void)deleteBookmarkWithURL:(NSURL *)url
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

- (void)logout;

@end
