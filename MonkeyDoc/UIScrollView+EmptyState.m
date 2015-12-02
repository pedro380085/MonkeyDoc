//
//  UITableView+EmptyState.m
//  InEvent
//
//  Created by Pedro Góes on 02/05/14.
//  Copyright (c) 2014 Pedro G√≥es. All rights reserved.
//

#import "UIScrollView+EmptyState.h"
#import "ColorThemeController.h"
#import "UIFont+System.h"

#define EMPTY_SCREEN 2

@implementation UIScrollView (EmptyState)

#pragma mark - Public methods

- (NSInteger)emptyStateForImageNamed:(NSString *)imageName withTitle:(NSString *)titleText withDescription:(NSString *)descriptText forArray:(NSArray *)array inSection:(NSInteger)section {
    
    // Remove old wrapper
    for (UIView *view in self.subviews) {
        if (view.tag == EMPTY_SCREEN) {
            [view removeFromSuperview];
        }
    }
    
    // Only show warning if data reads like that
    if ([array count] == 0 && section == 0) {

        // Create a wrapper
        CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        UIView *wrapper = [[UIView alloc] initWithFrame:rect];
        [wrapper setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [wrapper setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
        [wrapper setTag:EMPTY_SCREEN];
        
        // Add an image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 120.0f) * 0.5f, 46.0f, 120.0f, 120.0f)];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [imageView setAutoresizingMask:UIViewAutoresizingNone];
        [wrapper addSubview:imageView];
        
        // Add a title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 186.0f, self.frame.size.width - 30.0f, 30.0f)];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [title setText:titleText];
        [title setTextColor:[ColorThemeController mainTextColor]];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setNumberOfLines:1];
        [title setFont:[UIFont systemFontOfSize:21.0f]];
        [wrapper addSubview:title];
        
        // Add a description
        UILabel *descript = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 226.0f, self.frame.size.width - 30.0f, 70.0f)];
        [descript setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [descript setText:descriptText];
        [descript setTextColor:[ColorThemeController mainTextColor]];
        [descript setTextAlignment:NSTextAlignmentLeft];
        [descript setNumberOfLines:3];
        [descript setFont:[UIFont lightSystemFontOfSize:17.0f]];
        [wrapper addSubview:descript];
        
        BOOL didInsert = NO;
        
        // Try to find a scrollable view
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                [view addSubview:wrapper];
                didInsert = YES;
            }
        }
        
        // Append to main view in case we didn't find our target
        if (!didInsert) [self addSubview:wrapper];
    }
    
    return [array count];
}

@end
