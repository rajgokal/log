//
//  Database.h
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "LogEntry.h"

@interface Database : NSObject

+ (bool) init;

+ (FMDatabase*) open;
+ (void) openWithCallaback: (void(^)(FMDatabase *db)) callback;

+ (bool) ensureTablesExist;
+ (bool) tableExists: (NSString*) tableName;
+ (bool) dropTables;
+ (bool) createTables;

+ (void) resyncAll;
+ (void) startBackgroundSync;
+ (bool) allRecordsAreSynced;

+ (NSString*) get: (NSString*)key;
+ (void) set: (NSString*)key value: (NSString*) value;

+ (void) saveLogEntry: (LogEntry*) entry withCallback: (void(^)(NSString*)) callback;

//+ (LogEntry*) getLogEntry: (NSString*) entryId;

+ (NSInteger) numberOfLogEntries;


@end
