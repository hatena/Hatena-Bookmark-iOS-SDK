//  HTBBookmarkEntry.m
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

#import "HTBBookmarkEntry.h"

#define kHTBBookmarkEntryUrl                   @"url"
#define kHTBBookmarkEntryFaviconUrl            @"favicon_url"
#define kHTBBookmarkEntryEntryUrl              @"entry_url"
#define kHTBBookmarkEntryEntryTitle            @"title"
#define kHTBBookmarkEntryEntryCount            @"count"
#define kHTBBookmarkEntryEntryRecommendedTags  @"recommend_tags"
#define kHTBBookmarkEntrySmartphoneAppEntryUrl @"smartphone_app_entry_url"

@implementation HTBBookmarkEntry

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        if ([json[kHTBBookmarkEntryUrl] isKindOfClass:[NSString class]]) {
            self.URL = [NSURL URLWithString:json[kHTBBookmarkEntryUrl]];
        }
        if ([json[kHTBBookmarkEntryFaviconUrl] isKindOfClass:[NSString class]]) {
            self.faviconURL = [NSURL URLWithString:json[kHTBBookmarkEntryFaviconUrl]];
        }
        if ([json[kHTBBookmarkEntryEntryUrl] isKindOfClass:[NSString class]]) {
            self.entryURL = [NSURL URLWithString:json[kHTBBookmarkEntryEntryUrl]];
        }
        if ([json[kHTBBookmarkEntryEntryTitle] isKindOfClass:[NSString class]]) {
            self.title = json[kHTBBookmarkEntryEntryTitle];
        }
        if ([json[kHTBBookmarkEntryEntryCount] isKindOfClass:[NSNumber class]]) {
            self.count = [json[kHTBBookmarkEntryEntryCount] integerValue];
        }
        if ([json[kHTBBookmarkEntryEntryRecommendedTags] isKindOfClass:[NSArray class]]) {
            self.recommendTags = json[kHTBBookmarkEntryEntryRecommendedTags];
        }
        if ([json[kHTBBookmarkEntrySmartphoneAppEntryUrl] isKindOfClass:[NSString class]]) {
            self.smartphoneAppEntryURL = [NSURL URLWithString:json[kHTBBookmarkEntrySmartphoneAppEntryUrl]];
        }
    }
    return self;
}

- (NSString *)displayURLString
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^(https?://)"
                                                                            options:0
                                                                              error:nil];
    return self.URL ? [regexp stringByReplacingMatchesInString:[self.URL absoluteString] options:0 range:NSMakeRange(0, [self.URL absoluteString].length) withTemplate:@""] : nil;
}

- (NSString *)countUsers
{
    return [NSString stringWithFormat:@"%d users", self.count];
}

@end
