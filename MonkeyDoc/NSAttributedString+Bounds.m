//
//  NSAttributedString+Bounds.m
//  InEvent
//
//  Created by Pedro Góes on 01/06/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "NSAttributedString+Bounds.h"

@implementation NSAttributedString (Bounds)

- (CGFloat)getProbableHeightForHorizontalConstrain:(CGFloat)width {
    return [self getProbableRectWithSize:CGSizeMake(width, CGFLOAT_MAX)].size.height;
}

- (CGFloat)getProbableWidthForHorizontalConstrain:(CGFloat)width {
    return [self getProbableRectWithSize:CGSizeMake(width, CGFLOAT_MAX)].size.width;
}

- (CGRect)getProbableRectWithSize:(CGSize)size {
    
    // Empty struct
    CGRect rect = CGRectZero;
    
    // Only process case we don't have an empty string
    if (![self isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]) {
        
        // Calculate frame
        rect = CGRectIntegral([self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil]);
        
    }
    
    return rect;
    
}

@end
