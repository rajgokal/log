//
//  LogEntry.m
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "LogEntry.h"
#import "Json.h"

@implementation LogEntry

@synthesize entryId = _entryId;
@synthesize name = _name;
@synthesize timestamp = _timestamp;
@synthesize synced = _synced;
@synthesize value = _value;

- (id)init
{
    self = [super init];
    if (self) {
        _entryId = @"";
        _timestamp = [[NSNumber alloc] initWithInteger: 0];
        _name = @"";
        _value = 0;
        _synced = 0;
    }
    return self;
}

- (id)initWithRecord: (FMResultSet*) rs{
    
    self = [self init];
    
    if(self){
        self.entryId = [rs stringForColumn:@"Id"];
        self.timestamp = [NSNumber numberWithDouble: [rs doubleForColumn:@"Timestamp"]];
        self.name = [rs stringForColumn:@"Name"];
        self.value = [NSNumber numberWithDouble: [rs doubleForColumn:@"Value"]];
        self.synced = [NSNumber numberWithInt: [rs intForColumn:@"Synced"]];
    }
    
    return self;
}


- (NSString*)stringFromTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_timestamp doubleValue]]];
    return string;
}

- (NSString*) toJson{
    return([Json stringify: [self toDictionary]]);
}

- (NSDictionary*) toDictionary{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"Id"] = _entryId;
    dict[@"Timestamp"] = _timestamp;
    dict[@"Name"] = _name;
    dict[@"Value"] = _value;
    
    return(dict);
}

@end