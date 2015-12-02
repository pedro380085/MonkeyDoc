//
//  UIFont+System.m
//  InEvent
//
//  Created by Pedro Góes on 8/13/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "UIFont+System.h"

@implementation UIFont (System)

+ (UIFont *)mediumSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];    
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)ultraLightSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}

@end
