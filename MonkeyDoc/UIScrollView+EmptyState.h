//
//  UIScrollView+EmptyState.h
//  InEvent
//
//  Created by Pedro Góes on 02/05/14.
//  Copyright (c) 2014 Pedro G√≥es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (EmptyState)

- (NSInteger)emptyStateForImageNamed:(NSString *)imageName withTitle:(NSString *)title withDescription:(NSString *)descript forArray:(NSArray *)array inSection:(NSInteger)section;

@end
