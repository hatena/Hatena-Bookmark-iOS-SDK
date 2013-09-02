//  HTBBookmarkViewController.m
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

#import "HTBBookmarkViewController.h"
#import "HTBToggleButton.h"
#import "UIImageView+AFNetworking.h"
#import "HTBTagTokenizer.h"
#import "HTBBookmarkEntryView.h"
#import "HTBCommentViewController.h"
#import "HTBBookmarkToolbarView.h"
#import "HTBUserManager.h"
#import "HTBTagToolbarView.h"
#import "HTBTagTextField.h"
#import "HTBHatenaBookmarkManager.h"
#import "HTBMyEntry.h"
#import "HTBBookmarkEntry.h"
#import "HTBBookmarkedDataEntry.h"
#import "HTBPlaceholderTextView.h"
#import "HTBUtility.h"
#import "HTBBookmarkRootView.h"
#import "HTBMyTagsEntry.h"
#import "HTBCanonicalEntry.h"
#import "HTBCanonicalView.h"
#import "UIAlertView+HTBNSError.h"
#import "HTBHatenaBookmarkViewController.h"
#import "HTBMacro.h"

@interface HTBBookmarkViewController ()
@property (nonatomic, strong) HTBBookmarkEntry *entry;
@property (nonatomic, strong) HTBCanonicalEntry *canonicalEntry;
@property (nonatomic, strong) HTBBookmarkRootView *rootView;
@end

@implementation HTBBookmarkViewController {
    BOOL _entryRequestFinised;
    BOOL _canonicalRequestFinished;
    
    // Save/resume buffers for memory warinngs
    NSString *_textBuffer;
    NSString *_tagBuffer;
    HatenaBookmarkPOSTOptions _optionsBuffer;
}

-(void)loadView
{
    [super loadView];
    self.rootView = [[HTBBookmarkRootView alloc] initWithFrame:CGRectZero];
    self.rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [HTBUtility localizedStringForKey:@"hatena-bookmark" withDefault:@"Hatena Bookmark"] : [HTBUtility localizedStringForKey:@"bookmark" withDefault:@"Bookmark"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"back" withDefault:@"Back"] style: UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self loadEntry];
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"close" withDefault:@"Close"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"add" withDefault:@"Add"] style:UIBarButtonItemStyleBordered target:self action:@selector(addBookmarkButtonPushed:)];
    self.navigationItem.rightBarButtonItems = @[addButton];
    
    [self.rootView.entryView addTarget:self action:@selector(entryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.canonicalView addTarget:self action:@selector(canonicalButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rootView.toolbarView.lastPostOptions = [HTBHatenaBookmarkManager sharedManager].userManager.lastPostOptions;
    
    if ([HTBHatenaBookmarkManager sharedManager].authorized) {
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat wrapperWidth = HTB_IS_RUNNING_IOS7 ? 90 : 120;
        UIView *wrapper =[[UIView alloc] initWithFrame:CGRectMake(0, 0, wrapperWidth, 45)];
        logoutButton.frame = wrapper.frame;
        logoutButton.showsTouchWhenHighlighted = YES;
        logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        logoutButton.titleLabel.numberOfLines = 1;
        const float kMinimumFontSize = 7;
        if ([logoutButton.titleLabel respondsToSelector:@selector(setMinimumScaleFactor:)]) { // iOS6 or later.
            logoutButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            logoutButton.titleLabel.minimumScaleFactor = kMinimumFontSize / 17.f;
        } else {
            logoutButton.titleLabel.lineBreakMode = UILineBreakModeClip;
            logoutButton.titleLabel.minimumFontSize = kMinimumFontSize;
        }
        logoutButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (HTB_IS_RUNNING_IOS7) {
            [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [logoutButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            logoutButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        }
        [logoutButton setTitle:[NSString stringWithFormat:@"id:%@", [HTBHatenaBookmarkManager sharedManager].username] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [wrapper addSubview:logoutButton];
        self.navigationItem.titleView = wrapper;
    }
    [self resumeViewStates];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self saveViewStates];
}

- (void)handleHTTPError:(NSError *)error
{
    if ([HTBHatenaBookmarkManager sharedManager].authorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithHTBError:error];
            [alertView addButtonWithTitle:[HTBUtility localizedStringForKey:@"cancel" withDefault:@"Cancel"]];
            [alertView show];
        });
    }
}

- (void)handleCanonicalURL
{
    if (_entryRequestFinised && _canonicalRequestFinished) {
        BOOL canonicalURLDetected = self.entry.URL && self.canonicalEntry.canonicalURL && ![[self.canonicalEntry.canonicalURL absoluteString] isEqualToString:[self.entry.URL absoluteString]];
        BOOL entryMissingButCanonicalDetected = !self.entry.count && self.canonicalEntry.canonicalURL && ![[self.canonicalEntry.canonicalURL absoluteString] isEqualToString:[self.URL absoluteString]];
        if (canonicalURLDetected || entryMissingButCanonicalDetected) {
            [self.rootView setCanonicalViewShown:YES urlString:self.canonicalEntry.displayCanonicalURLString animated:YES];
        }
        
    }
}

- (void)canonicalButtonPushed:(id)sender
{
    HTBBookmarkViewController *viewController = [[HTBBookmarkViewController alloc] init];
    viewController.URL = _canonicalEntry.canonicalURL;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)entryButtonPushed:(id)sender
{
    HTBCommentViewController *viewController = [[HTBCommentViewController alloc] init];
    viewController.entry = self.entry;
    [self.navigationController pushViewController:viewController animated:YES];
    [self.rootView.commentTextView resignFirstResponder];
    [self.rootView.tagTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rootView.commentTextView becomeFirstResponder];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isBeingDismissed]) {
        CGRect frame = self.parentViewController.view.frame;
        frame.origin.y = self.view.window.bounds.size.height;
        [UIView animateWithDuration:animated ? 0.27 : 0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.parentViewController.view.frame = frame;
        } completion:nil];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#if __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_7_0
    if ([self respondsToSelector:@selector(topLayoutGuide)]) { // for iOS7
        self.rootView.scrollView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    }
    
    /**
     * on iOS7, when navigationController.view.frame is changed, but it's child view controllers' views are not resized.
     * So, change self.rootView.frame forcibly.
     */
    if (HTB_IS_RUNNING_IOS7) {
        CGFloat y = self.view.frame.origin.y;
        self.rootView.frame = CGRectMake(0,
                                         y,
                                         self.navigationController.view.frame.size.width,
                                         self.navigationController.view.frame.size.height - y);
    }
    
#endif
}

- (void)setEntry:(HTBBookmarkEntry *)entry
{
    if (entry) {
        _entry = entry;
        self.rootView.entryView.entry = entry;
        self.rootView.tagTextField.recommendedTags = entry.recommendTags;
    }
}

-(void)setBookmarkedDataEntry:(HTBBookmarkedDataEntry *)entry
{
    if (entry) {
        self.rootView.commentTextView.text = entry.comment;
        self.rootView.tagTextField.text = [HTBTagTokenizer tagArrayToSpaceText:entry.tags];
        self.rootView.toolbarView.bookmarkEntry = entry;
        [self.rootView updateTextCount];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"edit" withDefault:@"Edit"] style:UIBarButtonItemStyleBordered target:self action:@selector(addBookmarkButtonPushed:)];
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle: [HTBUtility localizedStringForKey:@"delete" withDefault:@"Delete"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteBookmarkButtonPushed:)];
        self.navigationItem.rightBarButtonItems = @[editButton, deleteButton];
    }
}

- (IBAction)addBookmarkButtonPushed:(id)sender
{
    [self.rootView.myBookmarkActivityIndicatorView startAnimating];
    NSArray *tags = [HTBTagTokenizer spaceTextToTagArray:self.rootView.tagTextField.text];
    
    HatenaBookmarkPOSTOptions options = self.rootView.toolbarView.selectedPostOptions;
    
    [[HTBHatenaBookmarkManager sharedManager] postBookmarkWithURL:self.URL comment:self.rootView.commentTextView.text tags:tags options:options success:^(HTBBookmarkedDataEntry *entry) {
        [self setBookmarkedDataEntry:entry];
        [HTBHatenaBookmarkManager sharedManager].userManager.lastPostOptions = options;
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
        [(HTBHatenaBookmarkViewController *)self.navigationController.parentViewController dismissHatenaBookmarkViewControllerCompleted:YES];
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
    }];
}

- (IBAction)deleteBookmarkButtonPushed:(id)sender
{
    [self.rootView.myBookmarkActivityIndicatorView startAnimating];
    [[HTBHatenaBookmarkManager sharedManager] deleteBookmarkWithURL:self.URL success:^{
        self.rootView.commentTextView.text = nil;
        self.rootView.tagTextField.text = nil;
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:[HTBUtility localizedStringForKey:@"add" withDefault:@"Add"] style:UIBarButtonItemStyleBordered target:self action:@selector(addBookmarkButtonPushed:)];
        self.navigationItem.rightBarButtonItems = @[addButton];
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
        [(HTBHatenaBookmarkViewController *)self.navigationController.parentViewController dismissHatenaBookmarkViewControllerCompleted:YES];
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
    }];
}

- (IBAction)closeButtonPushed:(id)sender
{
    [self dismiss];
}

- (IBAction)logoutButtonPushed:(id)sender
{
    HTBHatenaBookmarkViewController *hatenaBookmarkViewController = (HTBHatenaBookmarkViewController *)self.navigationController.parentViewController;
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:[HTBUtility localizedStringForKey:@"logout" withDefault:@"Logout"]
                                                            delegate: hatenaBookmarkViewController
                                                   cancelButtonTitle:[HTBUtility localizedStringForKey:@"cancel" withDefault:@"Cancel"]
                                              destructiveButtonTitle:[HTBUtility localizedStringForKey:@"logout" withDefault:@"Logout"]
                                                   otherButtonTitles:nil];
    [actionSheet showInView:self.navigationController.parentViewController.view];
}

- (void)dismiss
{
    [self.rootView.commentTextView resignFirstResponder];
    [(HTBHatenaBookmarkViewController *)self.navigationController.parentViewController dismissHatenaBookmarkViewControllerCompleted:NO];
}

- (void)loadEntry
{
    [self.rootView.myBookmarkActivityIndicatorView startAnimating];
    [self.rootView.bookmarkActivityIndicatorView startAnimating];
    _entryRequestFinised = NO;
    _canonicalRequestFinished = NO;
    [[HTBHatenaBookmarkManager sharedManager] getBookmarkEntryWithURL:self.URL success:^(HTBBookmarkEntry *entry) {
        _entryRequestFinised = YES;
        [self setEntry:entry];
        [self handleCanonicalURL];
        [self.rootView.bookmarkActivityIndicatorView stopAnimating];
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
        
        _entryRequestFinised = YES;
        [self handleCanonicalURL];
        // handle auth
        [self.rootView.bookmarkActivityIndicatorView stopAnimating];
    }];
    
    [[HTBHatenaBookmarkManager sharedManager] getCanonicalEntryWithURL:self.URL success:^(HTBCanonicalEntry *entry) {
        _canonicalRequestFinished = YES;
        _canonicalEntry = entry;
        [self handleCanonicalURL];
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
        _canonicalRequestFinished = YES;
        [self handleCanonicalURL];
        // handle auth
    }];
    
    [[HTBHatenaBookmarkManager sharedManager] getBookmarkedDataEntryWithURL:self.URL success:^(HTBBookmarkedDataEntry *entry) {
        [self setBookmarkedDataEntry:entry];
        [self resumeViewStates];
        [self clearViewStates];
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
        
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
        [self resumeViewStates];
        [self clearViewStates];
        [self.rootView.myBookmarkActivityIndicatorView stopAnimating];
    }];
    [[HTBHatenaBookmarkManager sharedManager] getMyEntryWithSuccess:^(HTBMyEntry *myEntry) {
        self.rootView.toolbarView.myEntry = myEntry;
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
    }];
    [[HTBHatenaBookmarkManager sharedManager] getMyTagsWithSuccess:^(HTBMyTagsEntry *myTagsEntry) {
        self.rootView.tagTextField.myTags = [myTagsEntry.sortedTags valueForKeyPath:@"tag"];
    } failure:^(NSError *error) {
        [self handleHTTPError:error];
    }];
}

// Save/resume states for iOS 5 memory warnings
- (void)saveViewStates
{
    _textBuffer = self.rootView.commentTextView.text;
    _tagBuffer = self.rootView.tagTextField.text;
    _optionsBuffer = self.rootView.toolbarView.selectedPostOptions;
}

- (void)resumeViewStates
{
    if (_textBuffer) {
        self.rootView.commentTextView.text = _textBuffer;
    }
    if (_tagBuffer) {
        self.rootView.tagTextField.text = _tagBuffer;
    }
    if (_optionsBuffer) {
        self.rootView.toolbarView.lastPostOptions = _optionsBuffer;
    }
}

- (void)clearViewStates
{
    _textBuffer = nil;
    _tagBuffer = nil;
    _optionsBuffer = 0;
}

@end
