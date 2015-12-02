//
//  UIViewController+Network.m
//  InEvent
//
//  Created by Pedro Góes on 7/21/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "UIViewController+Network.h"

@implementation UIViewController (Network)

#pragma mark - Loader

- (void)loadData {
    [self invokeDataMethodOnChildForPreviousCache:YES];
}

- (void)reloadData {
    [self invokeDataMethodOnChildForPreviousCache:NO];
}

- (void)invokeDataMethodOnChildForPreviousCache:(BOOL)previousCache {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(loadDataPreloadingPreviousCache:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(loadDataPreloadingPreviousCache:)];
    [invocation setArgument:&previousCache atIndex:2];
    [invocation invoke];
}

@end
