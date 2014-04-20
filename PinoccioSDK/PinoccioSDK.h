//
//  PinoccioSDK.h
//  PinoccioSDK
//
//  Created by hector urtubia on 4/12/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

// Based on documentation available here:
// https://docs.pinocc.io/api.html

#import <Foundation/Foundation.h>

@interface PinoccioSDK : NSObject

@property (readonly) NSString* token;
@property (readonly) BOOL isReadOnly;
@property (readonly) BOOL isLoggedIn;

+(void) login:(NSString*)username password:(NSString *)password response:(void(^)(PinoccioSDK*)) sdkInstance;
-(void) logout;
-(void) getTroops:(void(^)(NSArray*)) troopsPredicate;
-(void) getScoutsInTroop:(NSString*) troopId scoutsPredicate:(void(^)(NSArray*)) scoutsPredicate;
-(void) runBitlashCommand:(NSString*) troopId scoutId:(NSString*) scoutId command:(NSString*) command responsePredicate:(void(^)(NSDictionary*)) responsePredicate;

@end
