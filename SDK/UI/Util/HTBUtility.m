//  HTBUtility.m
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

#import "HTBUtility.h"

@implementation HTBUtility

+ (NSBundle *)hatenaBookmarkSDKBundle
{
    static dispatch_once_t fetchBundleOnce;
    static NSBundle *bundle = nil;
    
    dispatch_once(&fetchBundleOnce, ^{
        NSString *path = [[NSBundle mainBundle]
                          pathForResource:@"HTBResources"
                                   ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (NSString *)localizedStringForKey:(NSString *)key
                        withDefault:(NSString *)value
                           inBundle:(NSBundle *)bundle
{
    NSString *result = value;
    if (bundle) {
        result = [bundle localizedStringForKey:key
                                         value:value
                                         table:nil];
    }
    return result;
}

+ (NSString *)localizedStringForKey:(NSString *)key
                        withDefault:(NSString *)value
{
    return [self localizedStringForKey:key withDefault:value inBundle:[self hatenaBookmarkSDKBundle]];
}

@end
