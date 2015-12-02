//
//  PersonToken.m
//  InEvent
//
//  Created by Pedro Góes on 06/04/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "PersonToken.h"

@implementation PersonToken

#pragma mark - Singleton

+ (PersonToken *)sharedInstance
{
    static PersonToken *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PersonToken alloc] init];
        // Load the data that is already stored
        [sharedInstance setAllowedKeys:@[@"tokenID",
                                         @"uid",
                                         @"fbid",
                                         @"name",
                                         @"username"]];
    });
    return sharedInstance;
}

@end
