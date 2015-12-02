//
//  UILabel+Configuration.m
//  InEvent
//
//  Created by Pedro Góes on 12/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "UILabel+Configuration.h"
#import "ColorThemeController.h"

@implementation UILabel (Configuration)

- (void)configureLabel {
    [self setTextColor:[ColorThemeController mainTextColor]];
    [self setHighlightedTextColor:[ColorThemeController secondaryTextColor]];
}

- (void)configureLightLabel {
    [self setTextColor:[ColorThemeController secondaryTextColor]];
    [self setHighlightedTextColor:[ColorThemeController secondaryTextColor]];
}

- (void)configureHighlightedLabel {
    [self setTextColor:[ColorThemeController mainTextColor]];
    [self setHighlightedTextColor:[ColorThemeController secondaryTextColor]];
}

@end
