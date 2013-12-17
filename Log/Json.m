
#import "Json.h"

@implementation Json

+ (NSString *) stringify: (NSDictionary*) dict{
    NSError *error; 
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                       //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if(jsonData){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{ NSLog(@"JSON STRINGIFY ERROR: %@", error); return @""; }
}

+ (NSDictionary *) parse: (NSString*) jsonString{
    NSError *error; 
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:0
                                                         error:&error];
    if(dict){ return(dict); }
    else{ NSLog(@"JSON PARSE ERROR: %@", error); return(nil); }
}
    
@end
