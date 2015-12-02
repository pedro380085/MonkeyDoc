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

- (id)initWithPath:(NSString *)aAliasedPath
{
    self = [super init];
    if (self) {
        // Initialization code
        aliasedPath = aAliasedPath;
    }
    return self;
}

- (NSString *)generateTokenForPath:(NSString *)path forTime:(NSString *)time secret:(NSString *)secret {
    
    if (path != nil && time != nil && secret != nil) {
    
        const char *cPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cTime = [time cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cSecret = [secret cStringUsingEncoding:NSUTF8StringEncoding];
        
        unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
        CCHmacContext ctx;
        
        CCHmacInit(&ctx, kCCHmacAlgSHA1, cPath, strlen(cPath));
        CCHmacUpdate(&ctx, cSecret, strlen(cSecret));
        CCHmacUpdate(&ctx, cTime, strlen(cTime));
        CCHmacFinal(&ctx, cHMAC);
        
        // Now convert to NSData structure to make it usable again
//        NSData *HMAC = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
//
//        NSString *hash = [HMAC description];
//        hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
//        hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
//        hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
//        return hash;
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02lx", (unsigned long)cHMAC[i]];
        }
        return output;
        
    } else {
        return @"";
    }
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
//    [manager.requestSerializer setValue:secret forHTTPHeaderField:@"X-AUTH-TOKEN"];
    
    return manager;
}

@end
