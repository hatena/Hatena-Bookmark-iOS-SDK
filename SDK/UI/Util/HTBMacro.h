//
//  HTBMacro.h
//  DemoApp
//
//  Created by giginet on 9/5/13.
//  Copyright (c) 2013 Hatena Co., Ltd. All rights reserved.
//

#ifndef DemoApp_HTBMacro_h
#define DemoApp_HTBMacro_h

#if __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_7_0
#define HTB_IS_RUNNING_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#else
#define HTB_IS_RUNNING_IOS7 NO
#endif

#endif
