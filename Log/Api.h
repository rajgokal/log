
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "LogEntry.h"

@interface Api : NSObject 

@property (strong, nonatomic) NSString* endPoint;

- (id) initWithEndPoint: (NSString*) endPoint;
- (void) loginWithUserName: (NSString*) userName andPasswordHash: (NSString*) passwordHash withCallback: (void (^)(id error, NSString* userId)) callback;
- (void) logoutWithCallback: (void (^)(id error)) callback;
- (void) syncLogEntry: (LogEntry*) entry withCallback: (void (^)(id error, NSString* entryId)) callback;

@end
