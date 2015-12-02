//
//  LoginViewController.m
//  Hey
//
//  Created by Pedro Góes on 20/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PersonToken.h"
#import "UITextField+Components.h"
#import "AFHTTPRequestOperationManager.h"
#import "HTTPManager.h"
#import "UIViewController+Loading.h"

@interface LoginViewController () {
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].delegate.window.backgroundColor = [ColorThemeController buttonBackgroundColorNormal];
    self.view.backgroundColor = [ColorThemeController buttonBackgroundColorNormal];
    
    self.splitLabel.layer.cornerRadius = self.splitLabel.frame.size.width / 2.0f;
    
    [self.usernameField createLeftPadding];
    [self.usernameField createRightPaddingWithError];
    [self.usernameField createBorder];
    [self.passwordField createLeftPadding];
    [self.passwordField createBorder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (IBAction)resignKeyboard:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark - Private Methods

- (void)saveObjectToBin:(id)responseObject {
    // Save on our bin
    [[PersonToken sharedInstance] setObject:[responseObject objectForKey:@"token"] forKey:@"tokenID"];
    [[PersonToken sharedInstance] setObject:[responseObject objectForKey:@"_id"] forKey:@"uid"];
    [[PersonToken sharedInstance] setObject:[responseObject objectForKey:@"fbid"] forKey:@"fbid"];
    [[PersonToken sharedInstance] setObject:[responseObject objectForKey:@"name"] forKey:@"name"];
    [[PersonToken sharedInstance] setObject:[responseObject objectForKey:@"username"] forKey:@"username"];
}

- (void)saveUserDefaults:(id)responseObject {
    [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"username"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Facebook Methods

- (IBAction)authenticateUser:(id)sender {
    
    [[[FBSDKLoginManager alloc] init] logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:
     ^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         if (error == nil && [FBSDKAccessToken currentAccessToken]) {
             
             // Save block for later
//             returnBlock = callbackBlock;
             
             // Start loading
             [self startLoadingView];
             
             // Return our callback
//             apiBlock([[FBSDKAccessToken currentAccessToken] tokenString]);
             
         } else {
             
             // There was an error logging in
             NSString *alertTitle = NSLocalizedString(@"Warning", nil);
             NSString *alertText = NSLocalizedString(@"Your current session is not valid. Please log in again.", nil);
             
             // Show error for user
             [[[ETAlertView alloc] initWithTitle:alertTitle message:alertText confirmationButtonTitle:@"Ok"] show];
         }
     }];
}

#pragma mark - Person Methods

- (IBAction)logUser:(id)sender {
    
    if ([self.usernameField.text length] != 0 && [self.passwordField.text length] != 0) {
        
        // Start loading
        [self startLoadingView];
        
        // Save our current user
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameters = @{@"username": [self.usernameField.text lowercaseString], @"password": [self.passwordField.text lowercaseString]};
        
        [manager POST:[ROOT_DOMAIN stringByAppendingString:@"/api/user"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            // Save on our bin
            [self saveObjectToBin:responseObject];
            
            // Save on defaults
            [self saveUserDefaults:responseObject];
            
            // Stop loading
            [self stopLoadingView];
            
            // We have a logged in facebook user
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadData" object:nil];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // Stop loading
            [self stopLoadingView];
            // Show error
            self.usernameField.rightViewMode = UITextFieldViewModeAlways;
        }];
    }
}

@end
