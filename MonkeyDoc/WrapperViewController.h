//
//  WrapperViewController.h
//  InEvent
//
//  Created by Pedro Góes on 18/12/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETAlertView.h"
#import "ColorThemeController.h"
#import "UIViewController+BarButtons.h"
#import "UIViewController+Network.h"

@protocol WrapperViewControllerDelegate <NSObject>

- (void)loadDataPreloadingPreviousCache:(BOOL)preload;

@end

@interface WrapperViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) NSString *badgeTarget;
@property (assign, nonatomic) BOOL controllerHasBeenPushed;

// Allocation
- (void)allocTapBehind;
- (void)deallocTapBehind;
- (void)handleTapBehind:(UITapGestureRecognizer *)sender;

@end
