//  HTBUserManagerSpec.m
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
#import "HTBHatenaBookmarkManager.h"
#import "Nocilla.h"
#import "HTBMyEntry.h"
#import "HTBBookmarkedDataEntry.h"
#import "HTBBookmarkEntry.h"
#import "HTBCanonicalEntry.h"
#import "HTBUserManager.h"

SPEC_BEGIN(HTBUserManagerSpec)

__block HTBUserManager *userManager = nil;

    beforeAll(^{
       userManager = [HTBUserManager sharedManager];
    });

    it(@"tokenを保存して取り出せる", ^{
       AFOAuth1Token *token = [[AFOAuth1Token alloc] initWithKey:@"key"
                                                          secret:@"secret"
                                                         session:@"session"
                                                      expiration:[NSDate date]
                                                       renewable:YES];
        userManager.token = token;
        [[userManager.token.key shouldEventually] equal:@"key"];
        [[userManager.token.secret shouldEventually] equal:@"secret"];
    });

    it(@"authorizeEntryを保存して取り出せる", ^{
        HTBAuthorizeEntry *entry = [[HTBAuthorizeEntry alloc] initWithQueryString:@"oauth_token=dummyoAuthToken%3D%3D&oauth_token_secret=dummyoAuthTokenSecret%3D&url_name=cinnamon&display_name=%e3%81%97%e3%81%aa%e3%82%82%e3%82%93"];
        userManager.authorizeEntry = entry;

        [[userManager.authorizeEntry.username should] equal:@"cinnamon"];
        [[userManager.authorizeEntry.displayName should] equal:@"しなもん"];
    });

    it(@"authorizeEntryの値を削除できる", ^{
        userManager.authorizeEntry = nil;
        [[userManager.authorizeEntry should] beNil];
    });

SPEC_END