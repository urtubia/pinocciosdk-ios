//
//  PinoccioSDKTests.m
//  PinoccioSDKTests
//
//  Created by hector urtubia on 4/12/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PinoccioSDK.h"
#import "XCTestCase+AsyncTesting.h"

@interface PinoccioSDKFunctionalTests : XCTestCase
@property (nonatomic, readonly) NSString *validEmail;
@property (nonatomic, readonly) NSString *validPassword;
@property (nonatomic, readonly) NSString *invalidEmail;
@property (nonatomic, readonly) NSString *invalidPassword;
@property (nonatomic, readonly) NSString *validTroopName;
@property (nonatomic, readonly) NSString *validScoutName;
@end

@implementation PinoccioSDKFunctionalTests

- (void)setUp
{
    [super setUp];
    _validEmail = @"ENTER_VALID_EMAIL";
    _validPassword = @"ENTER_VALID_PASSWORD";
    _invalidEmail = @"test@tester.com";
    _invalidPassword = @"asdfasdfsadfasdf";
    _validTroopName = @"ENTER_VALID_TROOP_NAME";
    _validScoutName = @"ENTER_VALID_CONNECTED_SCOUT_NAME";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSuccesfulLogin
{
    [PinoccioSDK login:self.validEmail password:self.validPassword response:^(PinoccioSDK *response) {
        if(response != nil){
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }else{
            XCTFail(@"Not able to login correctly");
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
    }];
    [self waitForTimeout:10];
}

- (void)testFailedLogin
{
    [PinoccioSDK login:self.invalidEmail password:self.invalidPassword response:^(PinoccioSDK *response) {
        if(response != nil){
            XCTFail(@"Not supossed to get a token with ficticious login credentials");
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }else{
            
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
        
    }];
    [self waitForTimeout:10];
}

- (void) testGetTroops
{
    [PinoccioSDK login:self.validEmail password:self.validPassword response:^(PinoccioSDK *response) {
        if(response != nil){
            PinoccioSDK *sdk = response;
            [sdk getTroops:^(NSArray *troops) {
                bool foundValidTroop = false;
                if([troops count] < 1){
                    XCTFail(@"Unable to login");
                }
                for(NSDictionary *troop in troops){
                    NSLog(@"%@", troop[@"name"]);
                    if([self.validTroopName isEqualToString:troop[@"name"]]){
                        foundValidTroop = true;
                    }
                }
                if(foundValidTroop)
                    [self notify:XCTAsyncTestCaseStatusSucceeded];
            }];
            
        }else{
            XCTFail(@"Unable to login");
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
        
    }];
    [self waitForTimeout:10];
}

- (void) testGetScouts
{
    [PinoccioSDK login:self.validEmail password:self.validPassword response:^(PinoccioSDK *response) {
        if(response != nil){
            PinoccioSDK *sdk = response;
            [sdk getTroops:^(NSArray *troops) {
                if([troops count] < 1){
                    XCTFail(@"Unable to login");
                }
                for(NSDictionary *troop in troops){
                    NSLog(@"%@", troop[@"name"]);
                    if([self.validTroopName isEqualToString:troop[@"name"]]){
                        NSString *troop_id = troop[@"id"];
                        [sdk getScoutsInTroop:troop_id scoutsPredicate:^(NSArray *scouts) {
                            bool foundValidScout = false;
                            for(NSDictionary *scout in scouts){
                                NSLog(@"%@", scout[@"name"]);
                                if([self.validScoutName isEqualToString:scout[@"name"]]){
                                    foundValidScout = true;
                                }
                            };
                            if(foundValidScout) {
                                [self notify:XCTAsyncTestCaseStatusSucceeded];
                            }
                        }];
                    }
                }
                
            }];
            
        }else{
            XCTFail(@"Unable to login");
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
        
    }];
    [self waitForTimeout:10];
}

- (void) testGetScoutsIssueCommand
{
    [PinoccioSDK login:self.validEmail password:self.validPassword response:^(PinoccioSDK *response) {
        if(response != nil){
            PinoccioSDK *pinoccioSdk = response;
            [pinoccioSdk getTroops:^(NSArray *troops) {
                if([troops count] < 1){
                    XCTFail(@"No troops found");
                }
                for(NSDictionary *troop in troops){
                    NSLog(@"%@", troop[@"name"]);
                    if([self.validTroopName isEqualToString:troop[@"name"]]){
                        NSString *troop_id = troop[@"id"];
                        [pinoccioSdk getScoutsInTroop:troop_id scoutsPredicate:^(NSArray *scouts) {
                            
                            for(NSDictionary *scout in scouts){
                                NSLog(@"%@", scout[@"name"]);
                                if([self.validScoutName isEqualToString:scout[@"name"]]){
                                    [pinoccioSdk runBitlashCommand:troop_id scoutId:scout[@"id"] command:@"led.blink(0,0,255,1000)" responsePredicate:^(NSDictionary *response) {
                                        if(response[@"data"] != nil){
                                           [self notify:XCTAsyncTestCaseStatusSucceeded];
                                        }else{
                                            XCTFail(@"Failed issuing bitlash command");
                                            [self notify:XCTAsyncTestCaseStatusFailed];
                                        }
                                        
                                    }];
                                }
                            };
                        }];
                    }
                }
                
            }];
            
        }else{
            XCTFail(@"Unable to login");
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
        
    }];
    [self waitForTimeout:60];
}


@end
