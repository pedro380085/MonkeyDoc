//
//  UITextField+Components.m
//  Hey
//
//  Created by Pedro Góes on 25/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "UITextField+Components.h"
#import "ColorThemeController.h"

@implementation UITextField (Components)

- (void)createLeftPadding {
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)createRightPaddingWithError {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error-50"]];
    [imageView setFrame:CGRectMake(0, (self.frame.size.height - 32.0f) / 2.0f, 32, 32)];
    [view addSubview:imageView];
    self.rightView = view;
    self.rightViewMode = UITextFieldViewModeNever;
}

- (void)createBorder {
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [ColorThemeController buttonBackgroundColorHighlighted].CGColor;
}


@end
