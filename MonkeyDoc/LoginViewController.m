//
//  LoginViewController.m
//  Hey
//
//  Created by Pedro Góes on 20/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DeviceToken.h"
#import "PersonToken.h"
#import "UITextField+Components.h"
#import "AFHTTPRequestOperationManager.h"
#import "HTTPManager.h"
#import "UIViewController+Loading.h"
#import "UsernameCharacters.h"

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
    
    // Write our server/device data
    long serverTimestamp = (long)([[responseObject objectForKey:@"timestamp"] doubleValue] / 1000.0f);
    long deviceTimestamp = (long)[[NSDate date] timeIntervalSince1970];
    long timeDelta = (serverTimestamp - deviceTimestamp);
    [[DeviceToken sharedInstance] setObject:[NSString stringWithFormat:@"%ld", timeDelta] forKey:@"timeDelta"];
}

- (void)saveUserDefaults:(id)responseObject {
    [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"username"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Facebook Methods

- (IBAction)authenticateUser:(id)sender {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_friends"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
                     
        if (error == nil && FBSession.activeSession.state == FBSessionStateOpen) {
            
            // Start loading
            [self startLoadingView];
            
            // Save our current user
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *fbToken = FBSession.activeSession.accessTokenData.accessToken;
            NSString *deviceID = [[DeviceToken sharedInstance] objectForKey:@"deviceID"];
            
            NSDictionary *parameters = @{@"fbToken": fbToken, @"model": @"1", @"deviceId": deviceID};

            [manager POST:[ROOT_DOMAIN stringByAppendingString:@"/api/user/facebook"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                // Save on our bin
                [self saveObjectToBin:responseObject];
                
                // Save on defaults
                [self saveUserDefaults:responseObject];
                
                // Stop loading
                [self stopLoadingView];
                
                // Check current username
                if ([[responseObject objectForKey:@"username"] rangeOfString:@"fb:"].location == NSNotFound) {
                    // We have a logged in facebook user
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadData" object:nil];
                    }];
                } else {
                    // Try to find another username
                    [self performSegueWithIdentifier:@"UsernameViewController" sender:self];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // Stop loading
                [self stopLoadingView];
            }];
            
         } else {
             // There was an error logging in
             NSString *alertText;
             NSString *alertTitle;
             
             // If the error requires people using an app to make an action outside of the app in order to recover
             if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
                 alertTitle = @"Something went wrong";
                 alertText = [FBErrorUtility userMessageForError:error];
                 
             } else {
                 // If the user cancelled login, do nothing
                 if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                     alertTitle = @"Login Error";
                     alertText = @"Your current login has been canceled";
                     
                     // Handle session closures that happen outside of the app
                 } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                     alertTitle = @"Session Error";
                     alertText = @"Your current session is no longer valid. Please log in again.";
                     
                     // Here we will handle all other errors with a generic error message.
                     // We recommend you check our Handling Errors guide for more information
                     // https://developers.facebook.com/docs/ios/errors/
                 } else {
                     // Get more error information from the error
                     NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                     
                     // Show the user an error message
                     alertTitle = @"Something went wrong";
                     alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                 }
             }
             
             // Show error for user
             ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:alertText message:alertTitle delegate:nil cancelButtonTitle:nil otherButtonTitle:@"Ok"];
             [alertView show];
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
        
        NSDictionary *parameters = @{@"username": [self.usernameField.text lowercaseString], @"password": [self.passwordField.text lowercaseString], @"model": @"1", @"deviceId": [[DeviceToken sharedInstance] objectForKey:@"deviceID"]};
        
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

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:USERNAME_CHARACTERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

@end
