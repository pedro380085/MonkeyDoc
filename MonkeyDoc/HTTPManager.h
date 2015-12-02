//
//  HTTPManager.h
//  Hey
//
//  Created by Pedro Góes on 26/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#define ROOT_DOMAIN @"http://miami-hackathon.brunolemos.heroku.com"

@class AFHTTPRequestOperationManager;

@interface HTTPManager : NSObject

- (AFHTTPRequestOperationManager *)manager;

@end
