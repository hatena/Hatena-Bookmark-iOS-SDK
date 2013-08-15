//
//  HTBAuthorizeEntry.m
//  DemoApp
//
//  Created by giginet on 8/16/13.
//  Copyright (c) 2013 Hatena Co., Ltd. All rights reserved.
//

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
