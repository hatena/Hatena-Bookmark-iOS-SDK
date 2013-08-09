//  HTBCanonicalEntry.m
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

#import "HTBCanonicalEntry.h"
#import "HTBBookmarkEntry.h"

#define kHTBCanonicalEntryCanonicalEntry @"canonical_entry"
#define kHTBCanonicalEntryCanonicalUrl   @"canonical_url"
#define kHTBCanonicalEntryOriginalUrl    @"original_url"

@implementation HTBCanonicalEntry

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        if ([json[kHTBCanonicalEntryCanonicalEntry] isKindOfClass:[NSDictionary class]]) {
            self.canonicalEntry = [[HTBBookmarkEntry alloc] initWithJSON:json[kHTBCanonicalEntryCanonicalEntry]];
        }
        if ([json[kHTBCanonicalEntryOriginalUrl] isKindOfClass:[NSString class]]) {
            self.originalURL = [NSURL URLWithString:json[kHTBCanonicalEntryOriginalUrl]];
        }
        if ([json[kHTBCanonicalEntryCanonicalUrl] isKindOfClass:[NSString class]]) {
            self.canonicalURL = [NSURL URLWithString:json[kHTBCanonicalEntryCanonicalUrl] relativeToURL:self.originalURL];
        }
    }
    return self;
}

- (NSString *)displayCanonicalURLString
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^(https?://)"
                                                                            options:0
                                                                              error:nil];
    return self.canonicalURL ? [regexp stringByReplacingMatchesInString:[self.canonicalURL absoluteString] options:0 range:NSMakeRange(0, [self.canonicalURL absoluteString].length) withTemplate:@""] : nil;
}


@end
