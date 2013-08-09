//  HTBMyTagsEntry.m
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

#import "HTBMyTagsEntry.h"
#import "HTBTagEntry.h"

#define kHTBMyTagsEntryTags @"tags"

@implementation HTBMyTagsEntry

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        NSArray *rawTags = json[kHTBMyTagsEntryTags];
        if ([rawTags isKindOfClass:[NSArray class]]) {
            NSMutableArray *tags = [@[] mutableCopy];
            for (NSDictionary *json in rawTags) {
                [tags addObject:[[HTBTagEntry alloc] initWithJSON:json]];
            }
            self.tags = [tags mutableCopy];
        }
    }
    return self;
}

- (NSArray *)sortedTags
{
    // Sort with using flequency
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO];
    NSArray *sortedTags = [self.tags sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedTags;
}

@end
