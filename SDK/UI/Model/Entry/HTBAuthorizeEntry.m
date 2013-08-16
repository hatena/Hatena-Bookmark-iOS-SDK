//  HTBAuthorizeEntry.m
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

#import "HTBAuthorizeEntry.h"

@implementation HTBAuthorizeEntry

#define kHTBAuthorizeEntryUserNameKey @"username"
#define kHTBAuthorizeEntryDisplayNameKey @"displayName"

static NSDictionary * HTBParametersFromQueryString(NSString *queryString)
{
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

- (id)initWithQueryString:(NSString *)queryString
{
    self = [super init];
    if (self) {
        NSDictionary *params = HTBParametersFromQueryString(queryString);
        _username = params[@"url_name"];
        _displayName = params[@"display_name"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder decodeObjectForKey:kHTBAuthorizeEntryUserNameKey];
        _displayName = [aDecoder decodeObjectForKey:kHTBAuthorizeEntryDisplayNameKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:kHTBAuthorizeEntryUserNameKey];
    [aCoder encodeObject:self.displayName forKey:kHTBAuthorizeEntryDisplayNameKey];
}

@end
