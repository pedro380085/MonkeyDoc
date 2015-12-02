//
//  LoginViewController.h
//  Hey
//
//  Created by Pedro Góes on 20/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrapperViewController.h"

@interface LoginViewController : WrapperViewController

@property (strong, nonatomic) IBOutlet UILabel *splitLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)resignKeyboard:(id)sender;

@end
