//
//  NSString+Bounds.h
//  InEvent
//
//  Created by Pedro Góes on 31/05/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Bounds)

- (CGFloat)getProbableHeightWithFont:(UIFont *)font forHorizontalConstrain:(CGFloat)width;
- (CGFloat)getProbableWidthWithFont:(UIFont *)font forHorizontalConstrain:(CGFloat)width;

@end
