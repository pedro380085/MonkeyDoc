//
//  HTTPManager.h
//  Hey
//
//  Created by Pedro Góes on 26/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ROOT_DOMAIN @"https://heyme.co"

@class AFHTTPRequestOperationManager;

@interface HTTPManager : NSObject

- (id)initWithPath:(NSString *)aAliasedPath;
- (AFHTTPRequestOperationManager *)manager;

@end
