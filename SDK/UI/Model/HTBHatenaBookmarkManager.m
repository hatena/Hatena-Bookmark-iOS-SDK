//  HTBHatenaBookmarkManager.m
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

#import "HTBHatenaBookmarkManager.h"
#import "HTBHatenaBookmarkAPIClient.h"
#import "HTBBookmarkEntry.h"
#import "HTBBookmarkedDataEntry.h"
#import "HTBMyEntry.h"
#import "HTBTagEntry.h"
#import "HTBMyTagsEntry.h"
#import "HTBUserManager.h"
#import "AFHTTPRequestOperation.h"
#import "HTBCanonicalEntry.h"

@implementation HTBHatenaBookmarkManager {
    NSString *_consumerKey;
    NSString *_consumerSecret;
}

+ (instancetype)sharedManager
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (NSString *)username
{
    return self.userManager.authorizeEntry.username;
}

- (NSString *)displayName
{
    return self.userManager.authorizeEntry.displayName;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userManager = [HTBUserManager sharedManager];
    }
    return self;
}

- (void)logout
{
    self.apiClient = [[HTBHatenaBookmarkAPIClient alloc] initWithKey:_consumerKey secret:_consumerSecret];
    _authorized = NO;
    [self.userManager reset];
}

- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    _consumerKey = consumerKey;
    _consumerSecret = consumerSecret;
    self.apiClient = [[HTBHatenaBookmarkAPIClient alloc] initWithKey:consumerKey secret:consumerSecret];
    _authorized = NO;

    // Resume token
    if (self.userManager.token) {
        _authorized = YES;
        self.apiClient.accessToken = self.userManager.token;
    }
}

- (HTBHatenaBookmarkAPIClient *)apiClient {
    if (!_apiClient) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Invoke `setConsumerKey:consumerSecret:` before api call.", NSStringFromClass([self class])] userInfo:nil];
    }
    return _apiClient;
}

- (void)authorizeWithSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure
{
    [self.apiClient authorizeWithSuccess:^(AFOAuth1Token *accessToken, id responseObject) {
        NSString *queryString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.userManager.authorizeEntry = [[HTBAuthorizeEntry alloc] initWithQueryString:queryString];
        self.userManager.token = accessToken;
        _authorized = YES;
        if (success) success();
        
    } failure:^(NSError *error) {
        if (failure) failure(error);

    }];
}

- (void)getMyEntryWithSuccess:(void (^)(HTBMyEntry *myEntry))success
                      failure:(void (^)(NSError *error))failure
{
    [self.apiClient getMyWithSuccess:^(AFHTTPRequestOperation *operation, id responseJSON) {

        HTBMyEntry *myEntry = [[HTBMyEntry alloc] initWithJSON:responseJSON];
        self.userManager.myEntry = myEntry;
        if (success) success(myEntry);
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            // Not Authorize
            if ([operation.response statusCode] == 401) {
                [self logout];
            }
            if (failure) failure(error);            
    }];
}

- (void)getMyTagsWithSuccess:(void (^)(HTBMyTagsEntry *))success
                     failure:(void (^)(NSError *))failure
{
    [self.apiClient getMyTagsWithSuccess:^(AFHTTPRequestOperation *operation, id responseJSON) {
        HTBMyTagsEntry *myTagsEntry = [[HTBMyTagsEntry alloc]initWithJSON:responseJSON];
        self.userManager.myTagsEntry = myTagsEntry;
            if (success) success(myTagsEntry);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // Not Authorize
        if ([operation.response statusCode] == 401) {
            [self logout];
        }
        if (failure) failure(error);
    }];
}

- (void)getBookmarkEntryWithURL:(NSURL *)url
                        success:(void (^)(HTBBookmarkEntry *entry))success
                        failure:(void (^)(NSError *error))failure
{
    [self.apiClient getEntryWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {

        HTBBookmarkEntry *entry = [[HTBBookmarkEntry alloc] initWithJSON:responseJSON];
            if (success) success(entry);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([operation.response statusCode] == 404) {
                NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                if (data) {
                    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    HTBBookmarkEntry *nullEntry = [[HTBBookmarkEntry alloc] initWithJSON:responseJSON];
                    if (success)
                        success(nullEntry);
                    return;
                }
            }
            // Not Authorize
            if ([operation.response statusCode] == 401) {
                [self logout];
            }
            if (failure) failure(error);
    }];
}

- (void)getCanonicalEntryWithURL:(NSURL *)url
                         success:(void (^)(HTBCanonicalEntry *entry))success
                         failure:(void (^)(NSError *error))failure
{
    [self.apiClient getCanonicalEntryWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {

        HTBCanonicalEntry *canonicalEntry = [[HTBCanonicalEntry alloc] initWithJSON:responseJSON];
        if (success) success(canonicalEntry);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // Not Authorize
        if ([operation.response statusCode] == 401) {
            [self logout];
        }
        if (failure) failure(error);
    }];
}

- (void)getBookmarkedDataEntryWithURL:(NSURL *)url
                        success:(void (^)(HTBBookmarkedDataEntry *entry))success
                        failure:(void (^)(NSError *error))failure
{
    [self.apiClient getBookmarkWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {

        HTBBookmarkedDataEntry *entry = [[HTBBookmarkedDataEntry alloc] initWithJSON:responseJSON];
        if (success) success(entry);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 404) {
            // Not bookmarked yet.
            if (success) success(nil);
            return;
        }
        // Not Authorize
        if ([operation.response statusCode] == 401) {
            [self logout];
        }
        if (failure) failure(error);
        
    }];
}

// Add or edit your bookmark.
- (void)postBookmarkWithURL:(NSURL *)url
                    comment:(NSString *)comment
                       tags:(NSArray *)tags
                    options:(HatenaBookmarkPOSTOptions)options
                    success:(void (^)(HTBBookmarkedDataEntry *entry))success
                    failure:(void (^)(NSError *error))failure
{
    [self.apiClient postBookmarkWithURL:url comment:comment tags:tags options:options success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        
        HTBBookmarkedDataEntry *entry = [[HTBBookmarkedDataEntry alloc] initWithJSON:responseJSON];
        if (success) success(entry);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // Not Authorize
        if ([operation.response statusCode] == 401) {
            [self logout];
        }
        if (failure) failure(error);

    }];
}

// Delete your bookmark.
- (void)deleteBookmarkWithURL:(NSURL *)url
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure
{
    [self.apiClient deleteBookmarkWithURL:url success:^(AFHTTPRequestOperation *operation, id responseJSON) {

        if (success) success();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // Not Authorize
        if ([operation.response statusCode] == 401) {
            [self logout];
        }
        if (failure) failure(error);

    }];
}



@end
