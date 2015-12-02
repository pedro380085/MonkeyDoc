//
//  ColorThemeController.h
//  InEvent
//
//  Created by Pedro Góes on 22/02/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorThemeController : UIColor

+ (ColorThemeController *)sharedInstance;

#pragma mark - Global

+ (UIColor *)backgroundColor;
+ (UIColor *)borderColor;
+ (UIColor *)shadowColor;
+ (UIColor *)textColor;

#pragma mark - Button

+ (UIColor *)buttonBackgroundColorNormal;
+ (UIColor *)buttonBackgroundColorHighlighted;
+ (UIColor *)buttonTextColor;

#pragma mark - Table View Cell

+ (UIColor *)tableViewCellBackgroundColor;
+ (UIColor *)tableViewCellSelectedBackgroundColor;
+ (UIColor *)tableViewCellBorderColor;
+ (UIColor *)tableViewCellShadowColor;
+ (UIColor *)tableViewCellTextColor;
+ (UIColor *)tableViewCellTextHighlightedColor;

@end
