//  HTBHatenaBookmarkAPIClient.m
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

#import "HTBHatenaBookmarkAPIClient.h"

#import "HTBAFOAuth1Client.h"
#import "AFJSONRequestOperation.h"

#import "HTBUserManager.h"

#define kHatenaBookmarkBaseURLString @"http://api.b.hatena.ne.jp/"

#define KHatenaOAuthReuestTokenPath @"https://www.hatena.ne.jp/oauth/initiate"
#define kHatenaOAuthUserAuthorizationPath @"https://www.hatena.ne.jp/oauth/authorize"
#define KHatenaOAuthAccessTokenPath @"https://www.hatena.com/oauth/token"

@implementation HTBHatenaBookmarkAPIClient {
    id _applicationLaunchNotificationObserver;
}

NSString * const kHTBLoginStartNotification = @"kHTBLoginStatrNotification";
NSString * const kHTBLoginFinishNotification = @"kHTBLoginFinishNotification";
NSString * const kHTBApplicationLaunchOptionsURLKey = @"UIApplicationLaunchOptionsURLKey";

static NSDictionary * HTBParametersFromQueryString(NSString *queryString) {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (queryString) {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:queryString];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value) {
                [parameters setValue:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    return parameters;
}


+ (instancetype)sharedClientWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    if (!(consumerKey && consumerSecret)) {
        NSLog(@"Please set consumer key and consumer secret.");
    }
    
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithKey:consumerKey secret:consumerSecret];
    });
    return _sharedClient;
}

- (id)initWithKey:(NSString *)key secret:(NSString *)secret
{
    self = [super initWithBaseURL:[NSURL URLWithString:kHatenaBookmarkBaseURLString] key:key secret:secret];
    if (self) {
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

- (void)authorizeWithSuccess:(void (^)(AFOAuth1Token *accessToken, id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    [self acquireOAuthRequestTokenWithPath:KHatenaOAuthReuestTokenPath callbackURL:[NSURL URLWithString:@"http://www.hatena.ne.jp/"] accessMethod:@"POST" scope:@"read_private,write_public" success:^(AFOAuth1Token *requestToken, id responseObject) {

        NSMutableDictionary *parameters = [@{} mutableCopy];
        [parameters setValue:requestToken.key forKey:@"oauth_token"];
        NSMutableURLRequest *request = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHatenaBookmarkBaseURLString]] requestWithMethod:@"GET" path:kHatenaOAuthUserAuthorizationPath parameters:parameters];
        request.HTTPShouldHandleCookies = NO;
        __block AFOAuth1Token *currentRequestToken = requestToken;
        
        _applicationLaunchNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kHTBLoginFinishNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

            NSURL *url = [[notification userInfo] valueForKey:kHTBApplicationLaunchOptionsURLKey];

            currentRequestToken.verifier = [HTBParametersFromQueryString([url query]) valueForKey:@"oauth_verifier"];
            [self acquireOAuthAccessTokenWithPath:KHatenaOAuthAccessTokenPath requestToken:currentRequestToken accessMethod:@"POST" success:^(AFOAuth1Token * accessToken, id responseObject) {
                [[NSNotificationCenter defaultCenter] removeObserver:_applicationLaunchNotificationObserver];
                _applicationLaunchNotificationObserver = nil;
                if (accessToken) {
                    self.accessToken = accessToken;
                    if (success) {
                        success(accessToken, responseObject);
                    }
                } else {
                    if (failure) {
                        failure(nil);
                    }
                }
            } failure:^(NSError *error) {
                [[NSNotificationCenter defaultCenter] removeObserver:_applicationLaunchNotificationObserver];
                _applicationLaunchNotificationObserver = nil;
                if (failure) {
                    failure(error);
                }
            }];
        }];

        NSNotification *notification = [NSNotification notificationWithName:kHTBLoginStartNotification object:request];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// Add or edit your bookmark. 
- (void)postBookmarkWithURL:(NSURL *)bookmarkURL
                             comment:(NSString *)comment
                                tags:(NSArray *)tags
                             options:(HatenaBookmarkPOSTOptions)options
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/my/bookmark.json";
    NSDictionary *parameters = @{
        @"url"           : [bookmarkURL absoluteString],
        @"comment"       : comment ? comment : @"",
        @"tags"          : tags ? tags : @[],
        @"post_twitter"  : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionTwitter],
        @"post_facebook" : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionFacebook],
        @"post_mixi" : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionMixi],        
        @"post_evernote" : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionEvernote],
        @"send_mail"     : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionSendMail],
        @"private"       : [NSNumber numberWithBool:options & HatenaBookmarkPostOptionPrivate],
    };    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Delete your bookmark.
- (void)deleteBookmarkWithURL:(NSURL *)bookmarkURL
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/my/bookmark.json";
    NSDictionary *parameters = @{
        @"url": [bookmarkURL absoluteString],
    };
    [self deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Get your bookmarked information.
- (void)getBookmarkWithURL:(NSURL *)bookmarkURL
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/my/bookmark.json";
    NSDictionary *parameters = @{
        @"url": [bookmarkURL absoluteString],
    };
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Get your user information.
- (void)getMyWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/my.json";
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Get your tags.
- (void)getMyTagsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/my/tags.json";
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Get public entry information.
- (void)getEntryWithURL:(NSURL *)bookmarkURL
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/entry.json";
    NSDictionary *parameters = @{
        @"url": [bookmarkURL absoluteString],
        @"with_tag_recommendations" : @YES,
    };
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// Get canonical information.
- (void)getCanonicalEntryWithURL:(NSURL *)bookmarkURL
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = @"/1/canonical_entry.json";
    NSDictionary *parameters = @{ @"url": [bookmarkURL absoluteString] };
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

@end
