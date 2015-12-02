//
//  MainViewController.m
//  MonkeyDoc
//
//  Created by Pedro Goes on 12/2/15.
//  Copyright © 2015 Pedro Goes. All rights reserved.
//

#import "MainViewController.h"
#import "PersonToken.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Whenever a person opens the app, check for a cached session
    if ([[PersonToken sharedInstance] objectForKey:@"tokenID"] == nil) {
        [self performSegueWithIdentifier:@"LoginViewController" sender:self];
    } else {
        [self performSegueWithIdentifier:@"MedicineViewController" sender:self];
    }
}

@end
