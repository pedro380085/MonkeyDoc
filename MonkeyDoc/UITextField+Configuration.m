//
//  UITextField+Configuration.m
//  InEvent
//
//  Created by Pedro Góes on 16/01/15.
//  Copyright (c) 2015 Estúdio Trilha. All rights reserved.
//

#import "UITextField+Configuration.h"
#import "ColorThemeController.h"

@implementation UITextField (Configuration)

- (void)configureTextFieldForEditing {
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 10.0)]];
    [self.layer setBorderColor:[ColorThemeController borderColor].CGColor];
    [self.layer setBorderWidth:1.0f];
}

- (void)configureTextField {
    [self setTextColor:[ColorThemeController mainTextColor]];
}

@end
