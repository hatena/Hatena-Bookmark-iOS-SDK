//  HTBBookmarkToolbarView.h
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

#import <UIKit/UIKit.h>
#import "HTBHatenaBookmarkAPIClient.h"

@class HTBMyEntry;
@class HTBBookmarkedDataEntry;
@class HTBToggleButton;
@class HTBSelectedState;
@interface HTBBookmarkToolbarView : UIView
@property (nonatomic, strong) HTBMyEntry *myEntry;
@property (nonatomic, strong) HTBBookmarkedDataEntry *bookmarkEntry;
@property (nonatomic, assign) HatenaBookmarkPOSTOptions lastPostOptions;
@property (nonatomic, strong) HTBToggleButton *twitterToggleButton;
@property (nonatomic, strong) HTBToggleButton *facebookToggleButton;
@property (nonatomic, strong) HTBToggleButton *mixiToggleButton;
@property (nonatomic, strong) HTBToggleButton *evernoteToggleButton;
@property (nonatomic, strong) HTBToggleButton *mailToggleButton;
@property (nonatomic, strong) HTBToggleButton *privateToggleButton;

@property (nonatomic, readonly, assign) HatenaBookmarkPOSTOptions selectedPostOptions;

@end
