//
//  HTBAuthorizeEntry.h
//  DemoApp
//
//  Created by giginet on 8/16/13.
//  Copyright (c) 2013 Hatena Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBAuthorizeEntry : NSObject <NSCoding>
@property (readonly, nonatomic, copy) NSString *username;
@property (readonly, nonatomic, copy) NSString *displayName;

- (id)initWithQueryString:(NSString *)queryString;

@end
