//
//  UIViewController+Present.m
//  InEvent
//
//  Created by Pedro Góes on 23/01/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "UIViewController+Present.h"
#import "AppDelegate.h"

@implementation UIViewController (Present)

- (void)configureController:(UIViewController *)viewController completion:(void (^)(void))completion {
    [self configureController:viewController animated:YES dismissPreviousController:NO completion:completion];
}

- (void)configureController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [self configureController:viewController animated:animated dismissPreviousController:NO completion:completion];
}

- (void)configureController:(UIViewController *)viewController animated:(BOOL)animated dismissPreviousController:(BOOL)dismissPrevious completion:(void (^)(void))completion {
    
    // Remove any previous controller
    if (dismissPrevious) [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:NO completion:nil];
    
    // Configure our modal transition
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    // Present our controller
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (![root presentedViewController]) {
        [root presentViewController:viewController animated:animated completion:completion];
    }
}

@end
