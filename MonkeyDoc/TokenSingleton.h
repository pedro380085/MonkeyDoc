//
//  TokenSingleton.h
//  hey!
//
//  Created by Pedro Góes on 16/07/14.
//  Copyright (c) 2014 Est‚Äö√†√∂‚Äö√†¬¥dio Trilha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TokenSingleton <NSObject>

#pragma mark - Singleton
+ (instancetype)sharedInstance;

@end
