//
//  UIViewController+Loading.m
//  hey!
//
//  Created by Pedro Góes on 14/07/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "MBProgressHUD.h"

@implementation UIViewController (Loading)

#pragma mark - Person Methods

- (void)startLoadingView {
    [self startLoadingViewWithText:NSLocalizedString(@"Loading", nil)];
}

- (void)startLoadingViewWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

- (void)stopLoadingView {
    [self stopLoadingViewWithText:nil];
}

- (void)stopLoadingViewWithText:(NSString *)text {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (text != nil) [MBProgressHUD HUDForView:self.view].labelText = text;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
