//
//  Core.h
//  dataflow
//
//  Created by Kendrick Taylor on 2/27/13.
//  Copyright (c) 2013 Sano Intelligence Inc. All rights reserved.
//

#import "Api.h"

@interface Application : NSObject

+ (id)Api;
+ (void) init;

+ (NSString*) get: (NSString*)key;
+ (void) set: (NSString*)key value: (id) value;

+ (NSNumber *) epochNow;
+ (NSString*) sha256:(NSString*)input;
+ (NSString*) uuid;

+ (bool) isLoggedIn;

@end


