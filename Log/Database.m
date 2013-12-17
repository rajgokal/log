//
//  Database.m
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "Database.h"
#import "Application.h"
#import "Api.h"

static NSString* _dbPath = @"";
static NSThread *_syncThread = nil;

@implementation Database

+ (bool) init{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _dbPath = [documentsDirectory stringByAppendingPathComponent:@"context.db"];
    
    NSLog(@"DB Path: %@", _dbPath);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:_dbPath]){ return(true); }
    
    FMDatabase *db = [Database open];
    if(!db){ return(false); }
    [db close];
    
    return([Database ensureTablesExist]);
}

+ (bool) tableExists: (NSString*) tableName{
    
    FMDatabase *db = [Database open];
    
    FMResultSet *s = [db executeQuery: @"SELECT name FROM sqlite_master WHERE type='table' AND name=?", tableName];
    NSLog(@"DB Error: %@", [db lastErrorMessage]);
    
    if ([s next]) {
        NSLog(@"Table: %@ exist.", tableName);
        NSLog(@"Table name: %@",  [s stringForColumn:@"name"]);
        [db close];
        return(true);
    }else{
        NSLog(@"Table: %@ doesn't exist.", tableName);
        [db close];
        return(false);
    }
}

+ (bool) ensureTablesExist{
    
    NSLog(@"ensuring tables exist");
    if(![Database tableExists: @"LogEntry"]){
        [Database createTables];
    }
    
    return(true);
}


+ (bool) dropTables{
    
    FMDatabase *db = [Database open];
    
    if(![db executeUpdate: @"DROP TABLE LogEntry;"]){ NSLog(@"DB Error: %@", [db lastErrorMessage]); return(false); }
    NSLog(@"Drop Table: LogEntry");
    
    if(![db executeUpdate: @"DROP TABLE Lookup;"]){ NSLog(@"DB Error: %@", [db lastErrorMessage]); return(false); }
    NSLog(@"Drop Table: Lookup");
    
    [db close];
    
    return(true);
}

+ (NSString*) get: (NSString*)key{
    FMDatabase *db = [Database open];
    
    FMResultSet *rs = [db executeQuery: @"SELECT Value FROM Lookup WHERE Key = ?;", key];
    
    if([rs next]){
        NSString *val = [rs stringForColumn:@"Value"];
        [db close];
        return(val);
    }else{
        [db close];
        return(nil);
    }
    
}

+ (void) set: (NSString*)key value: (NSString*) value{
    if([Database get: key]){
        FMDatabase *db = [Database open];
        [db executeUpdate: @"UPDATE Lookup SET Value = ? WHERE Key = ?;", value, key];
        [db close];
    }else{
        FMDatabase *db = [Database open];
        [db executeUpdate: @"INSERT INTO Lookup (Key, Value) VALUES (?, ?);", key, value];
        [db close];
    }
}

+ (void) resyncAll{
    
    FMDatabase *db = [Database open];
    [db executeUpdate: @"UPDATE LogEntry SET Synced = 0;"];
    [db close];
    
    db = [Database open];
    [db executeUpdate: @"UPDATE Image SET Synced = 0;"];
    [db close];
    
    [Database startBackgroundSync];
}

+ (bool) allRecordsAreSynced{
    
    FMDatabase *db = [Database open];
    
    db = [Database open];
    FMResultSet *rs = [db executeQuery: @"SELECT Id FROM LogEntry WHERE Synced = 0 LIMIT 1;"];
    
    bool allSynced = ![rs next];
    
    [db close];
    
    return(allSynced);
}

+ (void) syncLogEntries: (FMResultSet*) rs{
    
    static FMDatabase* db = nil;
    static NSMutableArray *syncedIds = nil;
    
    if(!rs){
        db = [Database open];
        rs = [db executeQuery: @"SELECT * FROM LogEntry WHERE Synced = 0;"];
        syncedIds = [[NSMutableArray alloc] init];
    }
    
    if(![rs next]){
        [db close];
        db = nil;
        for(uint32_t i = 0; i < [syncedIds count]; i++){
            [Database markLogEntryAsSynced: syncedIds[i]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSynced" object:self];
        }
        return;
    }
    
    LogEntry *fe = [[LogEntry alloc] initWithRecord: rs];
    
    NSLog(@"Sync log entry: %@", fe.entryId);
    
    [[Application Api] syncLogEntry: fe withCallback: ^(id error, NSString *result){
        if(error){ NSLog(@"LogEntry Sync ERROR: %@", error); }
        else{
            [syncedIds addObject: fe.entryId];
            NSLog(@"LogEntry Sync Result: %@", result);
        }
        [Database syncLogEntries: rs];
    }];
}

+ (void) syncProcess{
    
    NSLog(@"Running sync.");
    
    NSLog(@"Sync log entries");
    [Database syncLogEntries: nil];
}

+ (void) startSyncThread{
    
    if(!_syncThread || [_syncThread isFinished]){
        _syncThread = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(syncProcess)
                                                object:nil];
        
        [_syncThread start];
    }
}


+ (void) startBackgroundSync{
    static bool firstRun = true;
    
    if(firstRun){
        firstRun = false;
        
        [NSTimer scheduledTimerWithTimeInterval:30.0
                                         target:self
                                       selector:@selector(startSyncThread)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    [Database startSyncThread];
}

+ (void) markLogEntryAsSynced: (NSString*) entryId{
    if(entryId && ![entryId isEqual: @""]){
        FMDatabase *db = [Database open];
        [db executeUpdate: @"UPDATE LogEntry SET Synced = 1 WHERE Id = ?;", entryId];
        [db close];
    }
}

+ (void) saveLogEntry: (LogEntry*) entry withCallback: (void(^)(NSString*)) callback{
    
    if(entry.entryId && ![entry.entryId isEqual: @""]){
        [Database openWithCallaback: ^(FMDatabase *db){
            [db executeUpdate: @"UPDATE LogEntry SET Timestamp = ?, Name = ?, Value = ?, Synced = 0 WHERE Id = ?;", entry.timestamp, entry.name, entry.value, entry.entryId];
        }];
        if(callback){ callback(entry.entryId); }
    }else{
        [Database openWithCallaback: ^(FMDatabase *db){
            entry.entryId = [Application uuid];
            [db executeUpdate: @"INSERT INTO LogEntry (Id, Timestamp, Name, Value, Synced) VALUES (?, ?, ?, ?, 0);", entry.entryId, entry.timestamp, entry.name, entry.value];
        }];
        if(callback){ callback(entry.entryId); }
    }
    
    NSLog(@"%i log entries", [Database numberOfLogEntries]);
}

+ (NSInteger) numberOfLogEntries{
    
    FMDatabase *db = [Database open];
    FMResultSet *rs = [db executeQuery: @"SELECT COUNT(*) FROM LogEntry;"];
    
    NSInteger numRows = 0;
    
    if ([rs next]) {
        numRows = [rs intForColumnIndex: 0];
    }
    
    [db close];
    
    return(numRows);
}

+ (LogEntry*) getLogEntry: (NSInteger) itemNumber {
    
    FMDatabase *db = [Database open];
    
    FMResultSet *rs = [db executeQuery: @"SELECT Id, Timestamp, Name, Value, Synced FROM LogEntry ORDER BY Timestamp DESC LIMIT 1 OFFSET ?", [NSNumber numberWithInteger: itemNumber]];
    
    LogEntry* entry = nil;
    
    if ([rs next]) {
        
        entry = [[LogEntry alloc] initWithRecord: rs];
        
        //NSLog(@"Got Entry: %@", [entry toDictionary]);
    }
    
    [db close];
    
    return(entry);
}

+ (LogEntry*) getLastLogEntryNamed: (NSString *) name {
    
    FMDatabase *db = [Database open];
    
    FMResultSet *rs = [db executeQuery: @"SELECT Id, Timestamp, Name, Value, Synced FROM LogEntry WHERE Name = '?' ORDER BY Timestamp DESC LIMIT 1", name];
    
    LogEntry* entry = nil;
    
    if ([rs next]) {
        
        entry = [[LogEntry alloc] initWithRecord: rs];
        
        //NSLog(@"Got Entry: %@", [entry toDictionary]);
    }
    
    [db close];
    
    return(entry);
}

+ (bool) createTables{
    
    FMDatabase *db = [Database open];
    
    NSMutableString *query = [[NSMutableString alloc] init];
    
    [query appendString: @"CREATE TABLE LogEntry("];
    [query appendString: @"Id           TEXT,"];
    [query appendString: @"Timestamp    REAL,"];
    [query appendString: @"Name         REAL,"];
    [query appendString: @"Value        REAL,"];
    [query appendString: @"Synced       INTEGER)"];
    
    if(![db executeUpdate: query]){ NSLog(@"DB Error: %@", [db lastErrorMessage]); return(false); }
    
    query = [[NSMutableString alloc] init];
    
    [query appendString: @"CREATE TABLE Lookup("];
    [query appendString: @"Key           TEXT,"];
    [query appendString: @"Value         TEXT)"];
    
    if(![db executeUpdate: query]){ NSLog(@"DB Error: %@", [db lastErrorMessage]); return(false); }
    
    [db close];
    
    return(true);
}

+ (FMDatabase*) open{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    if([db open]){ return(db); }
    else{ NSLog(@"DB Open Error: %@", [db lastErrorMessage]); return(nil); }
}

+ (void) openWithCallaback: (void(^)(FMDatabase *db)) callback{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    [queue inDatabase: callback];
}


@end
