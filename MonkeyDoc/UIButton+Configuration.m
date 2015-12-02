//
//  UIButton+Configuration.m
//  InEvent
//
//  Created by Pedro Góes on 16/04/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "UIButton+Configuration.h"
#import "ColorThemeController.h"

@implementation UIButton (Configuration)

- (void)configureButton {
    [self setTitleColor:[ColorThemeController mainTextColor] forState:UIControlStateNormal];
    [self setTitleColor:[ColorThemeController secondaryTextColor] forState:UIControlStateHighlighted];
}

- (void)configureLightButton {
    [self setTitleColor:[ColorThemeController secondaryTextColor] forState:UIControlStateNormal];
    [self setTitleColor:[ColorThemeController secondaryTextColor] forState:UIControlStateHighlighted];
}

- (void)configureOpaqueButton {
    [self.layer setBorderColor:[self titleColorForState:UIControlStateNormal].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setCornerRadius:self.frame.size.height * 0.5f];
}

- (void)configureOpaqueButtonWithDefaultColor {
    [self configureOpaqueButton];
    [self setTitleColor:[ColorThemeController navigationBarBackgroundColor] forState:UIControlStateNormal];
}

- (void)configureThickButton {
    [self.layer setCornerRadius:self.frame.size.height * 0.5f];
}

- (void)configureThickButtonWithDefaultColor {
    [self configureThickButton];
    [self setBackgroundColor:[ColorThemeController navigationBarBackgroundColor]];
}

@end
