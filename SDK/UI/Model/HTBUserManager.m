//  HTBUserManager.m
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

#import "HTBUserManager.h"
#import "SFHFKeychainUtils.h"

#define kHTBKeychainServiceName @"HatenaBookmark"
#define kHTBKeychainTokenKey @"keychainTokenKey"
#define kHTBKeychainTokenSecret @"keychainTokenSecret"
#define kHTBUserDefaultAuthorizeEntry @"authorizeEntry"
#define kHTBUserDefaultLastPostOptions @"HTBUserDefaultLastPostOptions"

@implementation HTBUserManager

+ (instancetype)sharedManager
{
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

- (void)reset
{
    [self setTokenKey:nil];
    [self setTokenSecret:nil];
    [self setAuthorizeEntry:nil];
    [self setLastPostOptions:HatenaBookmarkPostOptionNone];
}

- (void)setToken:(AFOAuth1Token *)token
{
    [self setTokenKey:token.key];
    [self setTokenSecret:token.secret];
}

- (AFOAuth1Token *)token
{
    NSString *key = [self tokenKey];
    NSString *secret = [self tokenSecret];
    if (key && secret) {
        return [[AFOAuth1Token alloc] initWithKey:key secret:secret session:nil expiration:nil renewable:NO];
    }
    else {
        return nil;
    }
}

- (void)setTokenKey:(NSString *)key
{
    if (key) {
        [SFHFKeychainUtils storeUsername:kHTBKeychainTokenKey andPassword:key forServiceName:kHTBKeychainServiceName updateExisting:YES error:nil];
    }
    else {
        [SFHFKeychainUtils deleteItemForUsername:kHTBKeychainTokenKey andServiceName:kHTBKeychainServiceName error:nil];
    }
}

- (void)setTokenSecret:(NSString *)secret
{
    if (secret) {
        [SFHFKeychainUtils storeUsername:kHTBKeychainTokenSecret andPassword:secret forServiceName:kHTBKeychainServiceName updateExisting:YES error:nil];
    }
    else {
        [SFHFKeychainUtils deleteItemForUsername:kHTBKeychainTokenSecret andServiceName:kHTBKeychainServiceName error:nil];
    }
}

- (NSString *)tokenKey
{
    return [SFHFKeychainUtils getPasswordForUsername:kHTBKeychainTokenKey andServiceName:kHTBKeychainServiceName error:nil];
}

- (NSString *)tokenSecret
{
    return [SFHFKeychainUtils getPasswordForUsername:kHTBKeychainTokenSecret andServiceName:kHTBKeychainServiceName error:nil];
}

- (HTBAuthorizeEntry *)authorizeEntry
{
    NSData *authorizeData = [[NSUserDefaults standardUserDefaults] objectForKey:kHTBUserDefaultAuthorizeEntry];
    if (authorizeData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:authorizeData];
    }
    return nil;
}

- (void)setAuthorizeEntry:(HTBAuthorizeEntry *)authorizeEntry
{
    if (authorizeEntry) {
        NSData *authorizeData = [NSKeyedArchiver archivedDataWithRootObject:authorizeEntry];
        [[NSUserDefaults standardUserDefaults] setObject:authorizeData forKey:kHTBUserDefaultAuthorizeEntry];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kHTBUserDefaultAuthorizeEntry];
    }
}

- (HatenaBookmarkPOSTOptions)lastPostOptions
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kHTBUserDefaultLastPostOptions];
}

- (void)setLastPostOptions:(HatenaBookmarkPOSTOptions)lastSelectedState
{
    [[NSUserDefaults standardUserDefaults] setInteger:lastSelectedState forKey:kHTBUserDefaultLastPostOptions];
}

@end
