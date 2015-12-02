//
//  ColorThemeController.m
//  InEvent
//
//  Created by Pedro Góes on 22/02/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "ColorThemeController.h"

@implementation ColorThemeController

#pragma mark - Singleton

+ (ColorThemeController *)sharedInstance
{
    static ColorThemeController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ColorThemeController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Private

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    
    if (hexString != nil) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    } else {
        return [UIColor clearColor];
    }
}

#pragma mark - Global

+ (UIColor *)backgroundColor {
    return [ColorThemeController colorFromHexString:@"#FDFDFD"];
}

+ (UIColor *)borderColor {
    return [ColorThemeController colorFromHexString:@"#333333"];
}

+ (UIColor *)shadowColor {
    return [ColorThemeController colorFromHexString:@"#0B0B0B"];
}

+ (UIColor *)textColor {
	return [ColorThemeController colorFromHexString:@"#111111"];
}

#pragma mark - States

+ (UIColor *)buttonBackgroundColorNormal {
	return [ColorThemeController colorFromHexString:@"#1abc9c"];
}

+ (UIColor *)buttonBackgroundColorHighlighted {
	return [ColorThemeController colorFromHexString:@"#16a085"];
}

+ (UIColor *)buttonTextColor {
	return [ColorThemeController colorFromHexString:@"#FDFDFD"];
}

#pragma mark - Table View Cell

+ (UIColor *)tableViewCellBackgroundColor {
	return [ColorThemeController colorFromHexString:@"#F6F6F6"];
}

+ (UIColor *)tableViewCellSelectedBackgroundColor {
	return [ColorThemeController colorFromHexString:@"#EEEEEE"];
}

+ (UIColor *)tableViewCellBorderColor {
    return [ColorThemeController colorFromHexString:@"#E1E1E1"];
}

+ (UIColor *)tableViewCellShadowColor {
	return [ColorThemeController colorFromHexString:@"#AFAFAF"];
}

+ (UIColor *)tableViewCellTextColor {
	return [ColorThemeController colorFromHexString:@"#333333"];
}

+ (UIColor *)tableViewCellTextHighlightedColor {
	return [ColorThemeController colorFromHexString:@"#6D6D6D"];
}

@end
