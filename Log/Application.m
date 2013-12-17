//
//  Core.m
//  dataflow
//
//  Created by Kendrick Taylor on 2/27/13.
//  Copyright (c) 2013 Sano Intelligence Inc. All rights reserved.
//

#import "Application.h"
#import <CommonCrypto/CommonDigest.h>
#import "Database.h"

@implementation Application

+ (void) init{


}

+ (bool) isLoggedIn{
    NSString *sessionId = [Application get: @"SessionId"];
    if(!sessionId){ sessionId = @""; }
    return(![sessionId isEqual: @""]);
}
 
+ (NSString*) get: (NSString*)key{
    return [Database get: key];
}

+ (void) set: (NSString*)key value:(NSString*)val{
    [Database set: key value: val];
}

+ (NSString*) uuid{ return([[NSUUID UUID] UUIDString]); }


+ (id)Api{

    static Api *instance = nil;
    
    // home
    //NSString *endPoint = @"http://10.10.0.135:80/api";
    
    // production
    NSString *endPoint = @"http://context.gokal.co/api";

    if (!instance){
        instance = [[Api alloc] initWithEndPoint: endPoint];
    }

    return instance;
}

+ (NSNumber *) epochNow{
    return([NSNumber numberWithDouble: [[NSDate date]timeIntervalSince1970]]);
}

+ (NSString*) sha256:(NSString*)input
{   
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
