//
//  UIViewController+BarButtons.m
//  InEvent
//
//  Created by Pedro Góes on 7/21/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "UIViewController+BarButtons.h"
#import "ETFlatBarButtonItem.h"
#import "ColorThemeController.h"

@implementation UIViewController (BarButtons)

#pragma mark - Bar Methods

- (void)loadBackButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissController)];
    self.navigationItem.leftBarButtonItem.tintColor = [ColorThemeController navigationBarTextColor];
    self.navigationItem.leftBarButtonItem.accessibilityLabel = NSLocalizedString(@"Go back", nil);
    self.navigationItem.leftBarButtonItem.accessibilityTraits = UIAccessibilityTraitSummaryElement;
}

- (void)loadSearchButton {
    self.navigationItem.rightBarButtonItem = [[ETFlatBarButtonItem alloc] initCustomButtonWithImage:[UIImage imageNamed:@"search_filled-32"] frame:CGRectMake(-6, 0, 48.0, 36.0) insets:UIEdgeInsetsMake(5.0, 11.0, 5.0, 11.0) target:self action:@selector(showSearchBox)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"Search", nil);
    self.navigationItem.rightBarButtonItem.accessibilityTraits = UIAccessibilityTraitSummaryElement;
}

- (void)loadMenuButton {
    self.navigationItem.rightBarButtonItem = [[ETFlatBarButtonItem alloc] initCustomButtonWithImage:[UIImage imageNamed:@"settings_filled-32"] frame:CGRectMake(0, 0, 42.0, 30.0) insets:UIEdgeInsetsMake(5.0, 11.0, 5.0, 11.0) target:self action:@selector(showAlertController)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"Actions", nil);
    self.navigationItem.rightBarButtonItem.accessibilityTraits = UIAccessibilityTraitSummaryElement;
}

- (void)loadSlideButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(showSlideView)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"Insert", nil);
    self.navigationItem.rightBarButtonItem.accessibilityTraits = UIAccessibilityTraitSummaryElement;
}

@end
