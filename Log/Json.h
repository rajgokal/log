
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Json : NSObject 

+ (NSDictionary *) parse: (NSString*) jsonString;
+ (NSString *) stringify: (NSDictionary*) dict;

@end
