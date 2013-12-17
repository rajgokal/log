//
//  LogEntry.h
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMResultSet.h"

@interface LogEntry : NSObject

@property (strong, nonatomic) NSString *entryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *timestamp;
@property (strong, nonatomic) NSNumber *synced;
@property (strong, nonatomic) NSNumber *value;

- (id)init;
- (id)initWithRecord: (FMResultSet*) rs;

- (NSString*) toJson;
- (NSDictionary*) toDictionary;

@end
