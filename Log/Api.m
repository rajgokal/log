
#import "Api.h"
#import "JsonRpcClient.h"
#import "Application.h"

@interface Api () {
    NSString* _sessionId;
}

@end

@implementation Api

@synthesize endPoint = _endPoint;

- (JsonRpcClient*) makeClient{
    JsonRpcClient* rpcClient = [[JsonRpcClient alloc] initWithEndPoint: _endPoint];
    rpcClient.sessionId = _sessionId;
    return(rpcClient);
}

- (id) initWithEndPoint: (NSString*) endPoint{ 
    self = [super init];

    if(self){
        _endPoint = endPoint;
        _sessionId = [Application get: @"SessionId"];
        if(!_sessionId){ _sessionId = @""; }
    }

    return self;
}

- (void) logoutWithCallback: (void (^)(id error)) callback{

    _sessionId = @"";
    [Application set: @"SessionId" value: @""];
    [Application set: @"UserName" value: @""];

    callback(nil);
}

- (void) loginWithUserName: (NSString*) userName andPasswordHash: (NSString*) passwordHash withCallback: (void (^)(id error, NSString* userId)) callback{

    [[self makeClient] callMethod: @"login" withParams: @[userName, passwordHash] andCallback: ^(id error, NSDictionary* result){

        if(error){
            NSLog(@"Login Error: %@", error);
            callback(error, nil);
        }else{ 
            NSLog(@"Login User Id: %@", result[@"Id"]);

            NSString *userId = result[@"Id"];

            _sessionId = userId;
            [Application set: @"UserName" value: userName];
            [Application set: @"SessionId" value: userId];

            callback(nil, userId);
        }
    }];
}

- (void) syncLogEntry: (LogEntry*) entry withCallback: (void (^)(id error, NSString* entryId)) callback{

//    [[self makeClient] callMethod: @"syncLogEntry" withParams: @[[entry toDictionary]] andCallback: ^(id error, NSDictionary* result){
//        if(error){ 
//            NSLog(@"Log Entry Sync Error: %@", error);
//            callback(error, nil); 
//        }else{ 
//            NSLog(@"Log Entry Sync Success Id: %@", result[@"Id"]);
//            callback(nil, result[@"Id"]); 
//        }
//    }];
}

@end
