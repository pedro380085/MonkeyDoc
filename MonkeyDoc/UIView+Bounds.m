//
//  UIView+Bounds.m
//  InEvent
//
//  Created by Pedro Góes on 31/05/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "UIView+Bounds.h"
#import "NSString+Bounds.h"
#import "NSAttributedString+Bounds.h"

@implementation UIView (Bounds)

/*
 
 Text
 
 */

- (void)resizeAndSetText:(NSString *)text {
    [self setText:text withMinimumHeight:0.0f andResize:YES];
}

- (void)resizeAndSetText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight {
    [self setText:text withMinimumHeight:mininumHeight andResize:YES];
}

- (CGFloat)getProbableHeightForText:(NSString *)text {
    return [self setText:text withMinimumHeight:0.0f andResize:NO];
}

- (CGFloat)getProbableHeightForText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight {
    return [self setText:text withMinimumHeight:mininumHeight andResize:NO];
}

- (CGFloat)setText:(NSString *)text withMinimumHeight:(CGFloat)mininumHeight andResize:(BOOL)resize {

    // Set our text for our text class
    if ([self respondsToSelector:@selector(setTitle:forState:)]) {
        [(UIButton *)self setTitle:text forState:UIControlStateNormal];
        
    } else if ([self respondsToSelector:@selector(text)]) {
        [(UILabel *)self setText:text];
    }
    
    // Get our text class font
    UIFont *font;
    if ([self respondsToSelector:@selector(setTitle:forState:)]) {
        font = [[(UIButton *)self titleLabel] font];
        
    } else if ([self respondsToSelector:@selector(text)]) {
        font = [(UILabel *)self font];
    }
    
    // Calculate final height
    CGFloat height = [text getProbableHeightWithFont:font forHorizontalConstrain:self.frame.size.width];
    height = (height > mininumHeight) ? height : mininumHeight;
    
    // Since it's a textView, we should remove default padding
    if ([self isKindOfClass:[UITextView class]]) {
        ((UITextView *)self).textContainer.lineFragmentPadding = 0;
        ((UITextView *)self).textContainerInset = UIEdgeInsetsZero;
    }
    
    // Update frame and contentSize
    if (resize) [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
    
    // Return our height
    return height;
}

/*
 
 Attributed Text
 
 */

- (void)resizeAndSetAttributedText:(NSAttributedString *)text {
    [self setAttributedText:text withMinimumHeight:0.0f andResize:YES];
}

- (void)resizeAndSetAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight {
    [self setAttributedText:text withMinimumHeight:mininumHeight andResize:YES];
}

- (CGFloat)getProbableHeightForAttributedText:(NSAttributedString *)text {
    return [self setAttributedText:text withMinimumHeight:0.0f andResize:NO];
}

- (CGFloat)getProbableHeightForAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight {
    return [self setAttributedText:text withMinimumHeight:mininumHeight andResize:NO];
}

- (CGFloat)setAttributedText:(NSAttributedString *)text withMinimumHeight:(CGFloat)mininumHeight andResize:(BOOL)resize {
    
    // Set our text for our text class
    if ([self respondsToSelector:@selector(setAttributedTitle:forState:)]) {
        [(UIButton *)self setAttributedTitle:text forState:UIControlStateNormal];
        
    } else if ([self respondsToSelector:@selector(attributedText)]) {
        [(UILabel *)self setAttributedText:text];
    }
    
    // Calculate final height
    CGFloat height = [text getProbableHeightForHorizontalConstrain:self.frame.size.width];
    height = (height > mininumHeight) ? height : mininumHeight;
    
    // Since it's a textView, we should remove default padding
    if ([self isKindOfClass:[UITextView class]]) {
        ((UITextView *)self).textContainer.lineFragmentPadding = 0;
        ((UITextView *)self).textContainerInset = UIEdgeInsetsZero;
    }
    
    // Update frame and contentSize
    if (resize) [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
    
    // Return our height
    return height;
}

@end
