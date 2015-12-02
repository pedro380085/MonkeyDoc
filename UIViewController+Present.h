//
//  UIViewController+Present.h
//  InEvent
//
//  Created by Pedro Góes on 23/01/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Present)

- (void)configureController:(UIViewController *)viewController completion:(void (^)(void))completion;
- (void)configureController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)configureController:(UIViewController *)viewController animated:(BOOL)animated dismissPreviousController:(BOOL)dismissPrevious completion:(void (^)(void))completion;

@end
