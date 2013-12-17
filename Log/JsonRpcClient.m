
#import "JsonRpcClient.h"
#import "Json.h"

@interface JsonRpcClient () {
    NSURLConnection* _connection;
    NSMutableData* _receivedData;
    void (^_callback)(id, NSDictionary*);
    bool _finished;
}

@end

@implementation JsonRpcClient

@synthesize endPoint = _endPoint;
@synthesize sessionId = _sessionId;

//- (id) initWithEndPoint: (NSString*) endPoint (NSString*) andPort: port
- (id) initWithEndPoint: (NSString*) endPoint{ 
    self = [super init];

    if(self){
        self.endPoint = endPoint;
        NSLog(@"endpoint: %@", self.endPoint);
        _connection = nil;
        _receivedData = nil;
        _callback = nil;
        _sessionId = @"";
        _finished = false;
    }

    return self;
}

-(void) callMethod: (NSString*) methodName withParams: (NSArray*) params andCallback: (void (^)(id, NSDictionary*)) callback{
    [self sendDictionary: @{ @"method" : methodName, @"params": params, @"sessionId" : _sessionId } withCallback: callback ];
}

- (void) sendDictionary: (NSDictionary*) dict withCallback: (void (^)(id, NSDictionary*)) callback{
     //if there is a connection going on just cancel it.
    [_connection cancel];

    _callback = callback;

    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    _receivedData = data;

    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString: self.endPoint];

    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];

    [request setHTTPMethod:@"POST"];
    
    NSString *postData = [Json stringify: dict ];

    //[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];

    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _connection = connection;

    //start the connection
    [connection start];

    while(!_finished) { [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"CONNECTION ERROR: %@", error);
    if(_callback){ _callback(error, nil); }
    _finished = true;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    //initialize convert the received data to string with UTF8 encoding
    NSString *recieved = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"Receieved: %@" , recieved);

    NSDictionary *response = [Json parse: recieved];

    if(_callback){
        if(response[@"error"] == [NSNull null]){ _callback(nil, response[@"result"][0]); }
        else{ _callback(response[@"error"], nil); }
    }

    _finished = true;
}

@end
