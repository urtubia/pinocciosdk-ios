//
//  PinoccioSDK.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/12/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "PinoccioSDK.h"

@interface BRSRestClientResponse : NSObject
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) NSObject* json;
@property (nonatomic, readonly) NSError* error;
@property (nonatomic, readonly) int statusCode;
@end

@interface BRSRestClient : NSObject
-(id) initWithURLString:(NSString*) urlString;
-(void) get:(void(^)(BRSRestClientResponse*)) predicate;
-(void) post:(void(^)(BRSRestClientResponse*)) predicate;
/*
 TODO
 -(void) put:(void(^)(BRSRestClientResponse*)) predicate;
 -(void) delete:(void(^)(BRSRestClientResponse*)) predicate;
 -(void) update:(void(^)(BRSRestClientResponse*)) predicate;
 -(void) patch:(void(^)(BRSRestClientResponse*)) predicate;
 */
@property (nonatomic, copy) NSObject* jsonData;
@property (nonatomic, readonly) NSString* urlString;

@end

@interface BRSRestClientResponse()
-(void) setText:(NSString*) text;
-(void) setStatusCode:(int) statusCode;
@end

@implementation BRSRestClientResponse
-(void) setText:(NSString *)text
{
    _text = text;
    // TODO: if it can be converted to JSON, do it.
}

-(void) setStatusCode:(int)statusCode
{
    _statusCode = statusCode;
}
@end

@interface BRSRestClient()

@end

@implementation BRSRestClient

-(id) initWithURLString:(NSString *)urlString
{
    if(self = [super init]){
        _urlString = urlString;
    }
    return self;
}

-(void) setJsonData:(NSObject *)jsonData {
    _jsonData = jsonData;
}

-(void) get:(void (^)(BRSRestClientResponse *))predicate
{
    NSURL *url = [NSURL URLWithString: _urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse* urlResponse = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *connectionError) {
        BRSRestClientResponse *resp = [[BRSRestClientResponse alloc] init];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [resp setText:result];
        [resp setStatusCode:[urlResponse statusCode]];
        predicate(resp);
    }];
}

-(void) post:(void (^)(BRSRestClientResponse *))predicate
{
    NSURL *url = [NSURL URLWithString: _urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSError *jsonError = nil;
    NSData *jsonDataToUpload = nil;
    if(self.jsonData != nil){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.jsonData options:0 error:&jsonError];
        NSString *jsonDataString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        jsonDataToUpload = [jsonDataString dataUsingEncoding:NSASCIIStringEncoding];
    }
    if(jsonError == nil){
        if(jsonDataToUpload != nil){
            [request setValue:[NSString stringWithFormat:@"%d", [jsonDataToUpload length]] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonDataToUpload];
        }
        NSHTTPURLResponse* urlResponse = nil;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *connectionError) {
            BRSRestClientResponse *resp = [[BRSRestClientResponse alloc] init];
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [resp setText:result];
            [resp setStatusCode:[urlResponse statusCode]];
            predicate(resp);
        }];
    }
}


@end



@interface PinoccioSDKConfig : NSObject

@property (readonly) NSString* apiBaseUrl;

@end

@implementation PinoccioSDKConfig
-(id) init{
    if(self = [super init]){
        _apiBaseUrl = @"https://api.pinocc.io/v1";
    }
    return self;
}

@end

@interface PinoccioSDK ()
-(instancetype) initWithToken: (NSString*) token;

@property (readonly) PinoccioSDKConfig* config;

@end


@implementation PinoccioSDK

-(instancetype) init {
    [NSException raise:@"Use the factory methods to create instances of this object" format:@"" ];
    return nil;
}

-(instancetype) initWithToken:(NSString *)token{
    if(self = [super init]){
        _config = [[PinoccioSDKConfig alloc] init];
        _token = token;
        _isReadOnly = false;
        _isLoggedIn = true;
    }
    return self;
}

+(void) login:(NSString *)username password:(NSString *)password response:(void(^)(PinoccioSDK *)) response{
    PinoccioSDKConfig *_config = [[PinoccioSDKConfig alloc] init];
    BRSRestClient *restClient = [[BRSRestClient alloc] initWithURLString:[NSString stringWithFormat:@"%@/login", _config.apiBaseUrl]];
    [restClient setJsonData: @{@"email": username, @"password": password}];
    [restClient post:^(BRSRestClientResponse *restClientResponse) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[restClientResponse.text dataUsingEncoding:NSASCIIStringEncoding]
                                                  options:kNilOptions
                                                    error:&error];
        NSDictionary *dataResponse = json[@"data"];
        NSString *token = dataResponse[@"token"];
        if(token != nil){
            // Success
            PinoccioSDK *sdk = [[PinoccioSDK alloc] initWithToken:token];
            response(sdk);
        }else{
            // Fail
            response(nil);
        }
    }];
}

-(void) logout
{
    BRSRestClient *restClient = [[BRSRestClient alloc] initWithURLString:[NSString stringWithFormat:@"%@/logout?token=%@", _config.apiBaseUrl, self.token]];
    [restClient get:^(BRSRestClientResponse *restClientResponse) {
        _isLoggedIn = false;
        _token = @"";
    }];
    
}

-(void) getTroops:(void (^)(NSArray *))troopsPredicate
{
    BRSRestClient *restClient = [[BRSRestClient alloc] initWithURLString:[NSString stringWithFormat:@"%@/troops?token=%@", _config.apiBaseUrl, self.token]];
    [restClient get:^(BRSRestClientResponse *restClientResponse) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[restClientResponse.text dataUsingEncoding:NSASCIIStringEncoding]
                                                  options:kNilOptions
                                                    error:&error];
        NSArray* data = json[@"data"];
        if(data != nil){
            troopsPredicate(data);
        }else{
            troopsPredicate(nil);
        }
    }];
}

-(void) getScoutsInTroop:(NSString *)troopId scoutsPredicate:(void (^)(NSArray *))scoutsPredicate
{
    BRSRestClient *restClient = [[BRSRestClient alloc] initWithURLString:[NSString stringWithFormat:@"%@/%@/scouts?token=%@", _config.apiBaseUrl, troopId, self.token]];
    [restClient get:^(BRSRestClientResponse *restClientResponse) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[restClientResponse.text dataUsingEncoding:NSASCIIStringEncoding]
                                                  options:kNilOptions
                                                    error:&error];
        NSArray* data = json[@"data"];
        if(data != nil){
            scoutsPredicate(data);
        }else{
            scoutsPredicate(nil);
        }
    }];
}

-(void) runBitlashCommand:(NSString *)troopId scoutId:(NSString *)scoutId command:(NSString *)command responsePredicate:(void (^)(NSDictionary *))responsePredicate
{
    BRSRestClient *restClient = [[BRSRestClient alloc] initWithURLString:[NSString stringWithFormat:@"%@/%@/%@/command?token=%@", _config.apiBaseUrl, troopId, scoutId, self.token]];
    restClient.jsonData = @{@"command": command};
    [restClient post:^(BRSRestClientResponse *restClientResponse) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[restClientResponse.text dataUsingEncoding:NSASCIIStringEncoding]
                                                  options:kNilOptions
                                                    error:&error];
        responsePredicate(json);

    }];
}

@end
