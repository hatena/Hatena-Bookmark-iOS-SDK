//  HTBMyEntry.m
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

#import "HTBMyEntry.h"

#define kHTBMyEntryName             @"name"
#define kHTBMyEntryIsOAuthTwitter   @"is_oauth_twitter"
#define kHTBMyEntryIsOAuthFacebook  @"is_oauth_facebook"
#define kHTBMyEntryIsOAuthMixiCheck @"is_oauth_mixi_check"
#define kHTBMyEntryIsOAuthEvernote  @"is_oauth_evernote"
#define kHTBMyEntryIsPlususer       @"plususer"

@implementation HTBMyEntry

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        if ([json[kHTBMyEntryName] isKindOfClass:[NSString class]]) {
            self.name = json[kHTBMyEntryName];
        }
        if ([json[kHTBMyEntryIsOAuthTwitter] isKindOfClass:[NSNumber class]]) {
            self.isOAuthTwitter = [json[kHTBMyEntryIsOAuthTwitter] boolValue];
        }
        if ([json[kHTBMyEntryIsOAuthFacebook] isKindOfClass:[NSNumber class]]) {
            self.isOAuthFacebook = [json[kHTBMyEntryIsOAuthFacebook] boolValue];
        }
        if ([json[kHTBMyEntryIsOAuthMixiCheck] isKindOfClass:[NSNumber class]]) {
            self.isOAuthMixiCheck = [json[kHTBMyEntryIsOAuthMixiCheck] boolValue];
        }
        if ([json[kHTBMyEntryIsOAuthEvernote] isKindOfClass:[NSNumber class]]) {
            self.isOAuthEvernote = [json[kHTBMyEntryIsOAuthEvernote] boolValue];
        }
        if ([json[kHTBMyEntryIsPlususer] isKindOfClass:[NSNumber class]]) {
            self.isPlususer = [json[kHTBMyEntryIsPlususer] boolValue];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name             = [aDecoder decodeObjectForKey:kHTBMyEntryName];
        self.isOAuthTwitter   = [aDecoder decodeBoolForKey:kHTBMyEntryIsOAuthTwitter];
        self.isOAuthFacebook  = [aDecoder decodeBoolForKey:kHTBMyEntryIsOAuthFacebook];
        self.isOAuthMixiCheck = [aDecoder decodeBoolForKey:kHTBMyEntryIsOAuthMixiCheck];
        self.isOAuthEvernote  = [aDecoder decodeBoolForKey:kHTBMyEntryIsOAuthEvernote];
        self.isPlususer       = [aDecoder decodeBoolForKey:kHTBMyEntryIsPlususer];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kHTBMyEntryName];
    [aCoder encodeBool:self.isOAuthTwitter forKey:kHTBMyEntryIsOAuthTwitter];
    [aCoder encodeBool:self.isOAuthFacebook forKey:kHTBMyEntryIsOAuthFacebook];
    [aCoder encodeBool:self.isOAuthMixiCheck forKey:kHTBMyEntryIsOAuthMixiCheck];
    [aCoder encodeBool:self.isOAuthEvernote forKey:kHTBMyEntryIsOAuthEvernote];
    [aCoder encodeBool:self.isPlususer forKey:kHTBMyEntryIsPlususer];
}

@end
