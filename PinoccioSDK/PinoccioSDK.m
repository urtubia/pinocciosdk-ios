//
//  PinoccioSDK.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/12/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "PinoccioSDK.h"
#import "BRSRestClient.h"

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
