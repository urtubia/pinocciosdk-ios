//
//  BRSRestClient.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/13/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "BRSRestClient.h"
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
