//
//  NSString+Bounds.m
//  InEvent
//
//  Created by Pedro Góes on 31/05/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "NSString+Bounds.h"
#import "NSAttributedString+Bounds.h"

@implementation NSString (Bounds)

- (CGFloat)getProbableHeightWithFont:(UIFont *)font forHorizontalConstrain:(CGFloat)width {
    return [[[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]}] getProbableHeightForHorizontalConstrain:width];
}

- (CGFloat)getProbableWidthWithFont:(UIFont *)font forHorizontalConstrain:(CGFloat)width {
        return [[[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]}] getProbableWidthForHorizontalConstrain:width];
}

@end
