//
//  UIView+Bounds.h
//  InEvent
//
//  Created by Pedro Góes on 31/05/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Bounds)

// Text
- (void)resizeAndSetText:(NSString *)text;
- (void)resizeAndSetText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight;
- (CGFloat)getProbableHeightForText:(NSString *)text;
- (CGFloat)getProbableHeightForText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight;
- (CGFloat)setText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight andResize:(BOOL)resize;

// Attributed Text
- (void)resizeAndSetAttributedText:(NSAttributedString *)text;
- (void)resizeAndSetAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight;
- (CGFloat)getProbableHeightForAttributedText:(NSAttributedString *)text;
- (CGFloat)getProbableHeightForAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight;
- (CGFloat)setAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight andResize:(BOOL)resize;

@end
