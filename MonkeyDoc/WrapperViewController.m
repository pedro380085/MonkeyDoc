//
//  WrapperViewController.m
//  InEvent
//
//  Created by Pedro Góes on 18/12/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import "WrapperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "ETFlatBarButtonItem.h"
#import "CompanyMacro.h"
#import "HumanViewController.h"
#import "UIViewController+Present.h"
#import "UIViewController+Loading.h"
#import "UIColor+Hex.h"

#define UNIQUE_LOADER 1

@interface WrapperViewController () {
    BOOL shouldCancelKeyboardAnimation;
    CGRect keyboardFrame;
    CGRect componentFrame;
    CGFloat currentViewShift;
    UITapGestureRecognizer *behindRecognizer;
}

@property (strong, nonatomic) UIBarButtonItem *barButtonItem;

@end

@implementation WrapperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyboardFrame = CGRectZero;
        componentFrame = CGRectZero;
        currentViewShift = 0.0f;
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Wrapper
    [self.view.layer setCornerRadius:2.0f];
    [self.view.layer setMasksToBounds:YES];
    
    // Navigation bar
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // View controller
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveKeyboardSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveKeyboardSize:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    // Push queue to our server
    [[INTrackingToken sharedInstance] pushQueueToServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Keyboard Notifications

- (void)saveKeyboardSize:(NSNotification*)notification {
    CGRect keyboardFrameOriginal = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    keyboardFrame = [mainSubviewOfWindow convertRect:keyboardFrameOriginal fromView:window];
    
    if (!CGRectEqualToRect(componentFrame, CGRectZero)) {
        [self checkKeyboardForPreponentParentView:nil];
        componentFrame = CGRectZero;
    }
}

- (void)checkKeyboardForPreponentParentView:(UIView *)component {
    
    // Wait until the next cycle to hide the keyboard
    shouldCancelKeyboardAnimation = NO;
    
    // Process the keyboard state
    if (component) {
        // Convert frame
        CGRect correctFrame = [component convertRect:component.bounds toView:nil];
        
        // Move by our current view shift
        correctFrame.origin.y -= currentViewShift;
        
        // Move keyboard if tab bar is present
        if (self.tabBarController) correctFrame.origin.y -= self.tabBarController.tabBar.frame.size.height;
        
        if (keyboardFrame.size.height == 0.0) {
            componentFrame = correctFrame;
        } else {
            [self calculateViewShift:correctFrame];
        }
    } else {
        [self calculateViewShift:componentFrame];
    }
}

- (void)calculateViewShift:(CGRect)frame {
    // Find the beyboard height
    CGFloat keyboardHeight = (keyboardFrame.size.height / [[UIScreen mainScreen] scale]);
    // Get the middle of the frame
    CGFloat viewAbsolutePosition = (self.view.frame.size.height - frame.size.height - keyboardHeight) / 2.0f;
    
    // Recalculate height for status bar and navigation bar
    if (self.navigationController && viewAbsolutePosition <= self.navigationController.navigationBar.frame.size.height) {
        viewAbsolutePosition = self.navigationController.navigationBar.frame.size.height + 20.0f;
    } else if (viewAbsolutePosition <= 20.0f)  {
        viewAbsolutePosition = 20.0f;
    }
    
    // Move the view to its calculated position
    [self shiftParentView:viewAbsolutePosition - (currentViewShift + frame.origin.y)];
}

- (void)shiftParentView:(CGFloat)shift {
    
    CGRect rect = self.view.frame;

    currentViewShift += shift;
    rect.origin.y += shift;
    
    [UIView animateWithDuration:0.23f animations:^{
        self.view.frame = rect;
    }];
}

#pragma mark - Tap Behind methods

- (void)allocTapBehind {
    // Add the gesture recognizer
    behindRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [behindRecognizer setNumberOfTapsRequired:1];
    [behindRecognizer setCancelsTouchesInView:NO]; // So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:behindRecognizer];
}

- (void)deallocTapBehind {
    // Remove the gesture recognizer
    [self.view.window removeGestureRecognizer:behindRecognizer];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; // Passing nil gives us coordinates in the window
        
        // Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside.
        // If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Public Methods

- (void)removePerson {

    [[INTrackingToken sharedInstance] addToQueueWithTarget:@"action/logout" atTarget:[[[INEventToken sharedInstance] objectForKey:@"eventID"] integerValue]];
    
    // Remove Facebook Login
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKLoginManager alloc] init] logOut];
    }
    
    // Remove InEvent Login
    if ([[INPersonToken sharedInstance] isPersonAuthenticated]) {
        
        // Remove from previous channels
        [[[INPersonDeviceAPIController alloc] initWithDelegate:nil] dismissAuthenticatedAtCompany:[APP_COMPANYID integerValue] withModel:@"1" withDeviceKey:[[INDeviceToken sharedInstance] objectForKey:@"deviceID"]];
        
        // Wipe user data
        [[INPersonToken sharedInstance] removePerson];
    }
    
    // Update the current state of the schedule controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventCurrentState" object:nil userInfo:nil];
    
    // Check for person session
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"person"}];
}

- (void)removeEvent {
    
    [[INTrackingToken sharedInstance] addToQueueWithTarget:@"action/event/exit" atTarget:[[[INEventToken sharedInstance] objectForKey:@"eventID"] integerValue]];
    
    // Remove the tokenID and enterprise
    [[INEventToken sharedInstance] removeEvent];
    
    // Check for event session
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"enterprise"}];
}

#pragma mark - Item Badge

- (void)clearBadge {
    if (self.tabBarItem.badgeValue != nil && _badgeTarget != nil) {
        [[[INPersonBadgeAPIController alloc] initWithDelegate:self] clearAuthenticatedAtEventWithTarget:_badgeTarget];
        self.tabBarItem.badgeValue = nil;
    }
}

#pragma mark - View Controller Delegate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Resign all view's first responders
    [self.view endEditing:YES];
    
    // Clean the keyboard size
    keyboardFrame = CGRectZero;
}

#pragma mark - Split View Controller Delegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    self.barButtonItem = barButtonItem;
    [self showRootPopoverButtonItem];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self invalidateRootPopoverButtonItem];
    self.barButtonItem = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - Split View Controller Rotation Methods

- (void)showRootPopoverButtonItem {
    // Append the button into the ones that we already have
    NSMutableArray *barButtons = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    if (_barButtonItem && ![barButtons containsObject:_barButtonItem]) [barButtons addObject:_barButtonItem];
    [self.navigationItem setLeftBarButtonItems:barButtons animated:YES];
}

- (void)invalidateRootPopoverButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    NSMutableArray *barButtons = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [barButtons removeObject:_barButtonItem];
    [self.navigationItem setLeftBarButtonItems:barButtons animated:YES];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // Move view if necessary
    if (currentViewShift != 0.0f) {
        [self performSelector:@selector(checkKeyboardForPreponentParentView:) withObject:textField afterDelay:0.4f];
        shouldCancelKeyboardAnimation = YES;
    } else {
        [self checkKeyboardForPreponentParentView:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    // Move view down if necessary
    if (shouldCancelKeyboardAnimation == NO) {
        [self shiftParentView:-(currentViewShift)];
    }
    
    return YES;
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    // Move view if necessary
    if (currentViewShift != 0.0f) {
        [self performSelector:@selector(checkKeyboardForPreponentParentView:) withObject:textView afterDelay:0.4f];
        shouldCancelKeyboardAnimation = YES;
    } else {
        [self checkKeyboardForPreponentParentView:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    // Move view down if necessary
    if (shouldCancelKeyboardAnimation == NO) {
        [self shiftParentView:-(currentViewShift)];
    }
    
    return YES;
}

#pragma mark - INAPIController Delegate

- (void)apiController:(INAPIController *)apiController didPartiallyReceiveDictionaryFromServer:(CGFloat)percentage {
    
    // Shows a loader on top of the screen indicating progress
    UIView *loaderView;
    
    // Find previous loader
    for (UIView *view in self.view.subviews) {
        if (view.tag == UNIQUE_LOADER) loaderView = view;
    }
    
    if (loaderView == nil) {
        UIView *loaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [loaderView setBackgroundColor:[ColorThemeController positiveColor]];
        [loaderView setTag:UNIQUE_LOADER];
        [self.view addSubview:loaderView];
    }
    
    // Calculate and display current progress
    [loaderView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width * percentage, 4.0f)];
    
    // Remove view after a while
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [loaderView removeFromSuperview];
    });
}

- (void)apiController:(INAPIController *)apiController didLoadDictionaryFromServer:(NSDictionary *)dictionary {
    // Stop loading view
    [self stopLoadingView];
}

- (void)apiController:(INAPIController *)apiController didFailWithError:(NSError *)error {
    
    // Stop loading view
    [self stopLoadingView];
    
    // Implement a method that allows every failing requisition to be reloaded
    
    if ((int)(error.code / 100) == 5) {
        // We have a server error
        [[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Oh oh.. It appears that our server is having some trouble. Do you want to try again?", nil) negativeButtonTitle:NSLocalizedString(@"No", nil) positiveButtonTitle:NSLocalizedString(@"Yes", nil) negativeBlock:nil positiveBlock:^{
            if (apiController != nil) {
                [apiController startAsyncronousDownload];
            }
        }] show];
     
    } else if (error.code == 403 || error.code == 405 || error.code == 406) {
        // We have a server error
        [[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"The operation you are trying to perform is not acceptable...", nil) confirmationButtonTitle:@"Ok"] show];
        
    } else if (error.code == 401) {
        // We have a server error
        [[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"It appears that your credentials expired! Can you log again?", nil) confirmationButtonTitle:@"Ok" confirmationBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"person"}];
        }] show];
        
        // We check which permission we should remove
        if ([[INPersonToken sharedInstance] isPersonAuthenticated]) {
            [[INPersonToken sharedInstance] removePerson];
        }
        
        // Update the current state of the schedule controller
        if ([[INEventToken sharedInstance] isEventSelected]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eventCurrentState" object:nil userInfo:nil];
        }
        
    } else {
        // Default unknown error
        [[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Hum, it appears that the connectivity is unstable.. Do you want to try again?", nil) negativeButtonTitle:NSLocalizedString(@"No", nil) positiveButtonTitle:NSLocalizedString(@"Yes", nil) negativeBlock:nil positiveBlock:^{
            if (apiController != nil) {
                [apiController startAsyncronousDownload];
            }
        }] show];
    }
}

- (void)apiController:(INAPIController *)apiController didSaveForLaterWithError:(NSError *)error {
    
    // Stop loading view
    [self stopLoadingView];
    
    // Implement a custom view to be displayed to the user
    CGRect rect = CGRectMake((self.view.frame.size.width - 120.0f) / 2.0f, -120.0f, 120.0f, 120.0f);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor colorFromHexadecimalValue:@"#FDFDFD"]];
    [view.layer setBorderWidth:1.0f];
    [view.layer setBorderColor:[UIColor blackColor].CGColor];
    [view.layer setCornerRadius:4.0f];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sad-64"]];
    [imageView setFrame:CGRectMake((view.frame.size.width - imageView.frame.size.width) / 2.0f, (view.frame.size.height - imageView.frame.size.height) / 3.0f, imageView.frame.size.width, imageView.frame.size.height)];
    [view addSubview:imageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width * 0.1f, 78.0f, view.frame.size.width * 0.8f, 40.0f)];
    [label setText:NSLocalizedString(@"Saved offline", nil)];
    [label setTextColor:[ColorThemeController mainTextColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:2];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [view addSubview:label];
    
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(rect.origin.x, -4.0f, rect.size.width, rect.size.height);
    } completion:^(BOOL completion){
        [UIView animateWithDuration:0.2 delay:2.0 options:0 animations:^{
            view.frame = CGRectMake(rect.origin.x, -120.0f, rect.size.width, rect.size.height);
        } completion:^(BOOL completion){
            [view removeFromSuperview];
        }];
    }];
}

@end
