
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JsonRpcClient : NSObject 

@property (strong, nonatomic) NSString* endPoint;
@property (strong, nonatomic) NSString* sessionId;

- (id) initWithEndPoint: (NSString*) endPoint;
- (void) callMethod: (NSString*) methodName withParams: (NSArray*) params andCallback: (void (^)(id, NSDictionary*)) callback;

@end
