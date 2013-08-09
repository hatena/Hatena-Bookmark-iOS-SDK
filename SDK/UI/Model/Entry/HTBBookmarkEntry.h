//  HTBBookmarkEntry.h
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

#import <Foundation/Foundation.h>

@class HTBBookmarkedDataEntry;

@interface HTBBookmarkEntry : NSObject

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *faviconURL;
@property (nonatomic, strong) NSURL *entryURL;
@property (nonatomic, strong) NSURL *smartphoneAppEntryURL;
@property (nonatomic, strong) NSArray *recommendTags;
@property (nonatomic) NSInteger count;
@property (nonatomic, readonly, strong) NSString *displayURLString;
@property (nonatomic, readonly, strong) NSString *countUsers;

- (id)initWithJSON:(NSDictionary *)json;

@end
