//
//  HTTPManager.m
//  Hey
//
//  Created by Pedro Góes on 26/06/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "HTTPManager.h"
#include <CommonCrypto/CommonHMAC.h>
#import "AFHTTPRequestOperationManager.h"
#import "PersonToken.h"

@implementation HTTPManager {
    NSString *aliasedPath;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (AFHTTPRequestOperationManager *)manager {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Add a serializer
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    // Add a specific timeout
    [manager.requestSerializer setTimeoutInterval:10.0f];
    
    // Set our username
    [manager.requestSerializer setValue:[[PersonToken sharedInstance] objectForKey:@"username"] forHTTPHeaderField:@"X-AUTH-USERNAME"];
    
    // Set an encrypted token
    [manager.requestSerializer setValue:[[PersonToken sharedInstance] objectForKey:@"tokenID"] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    
    return manager;
}

@end
