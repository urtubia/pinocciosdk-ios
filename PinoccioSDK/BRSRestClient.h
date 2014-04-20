//
//  BRSRestClient.h
//  PinoccioSDK
//
//  Created by hector urtubia on 4/13/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

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
-(void) put:(void(^)(BRSRestClientResponse*)) predicate;
-(void) delete:(void(^)(BRSRestClientResponse*)) predicate;
-(void) update:(void(^)(BRSRestClientResponse*)) predicate;
-(void) patch:(void(^)(BRSRestClientResponse*)) predicate;
*/
@property (nonatomic, copy) NSObject* jsonData;
@property (nonatomic, readonly) NSString* urlString;

@end
