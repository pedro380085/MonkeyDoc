//
//  UIViewController+Loading.h
//  hey!
//
//  Created by Pedro Góes on 14/07/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

- (void)startLoadingView;
- (void)startLoadingViewWithText:(NSString *)text;
- (void)stopLoadingView;
- (void)stopLoadingViewWithText:(NSString *)text;

@end
