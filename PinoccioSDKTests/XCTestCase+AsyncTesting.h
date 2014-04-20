//
//  XCTestCase+AsyncTesting.h
//  PinoccioSDK
//
//  Created by hector urtubia on 4/14/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>


enum {
    XCTAsyncTestCaseStatusUnknown = 0,
    XCTAsyncTestCaseStatusWaiting,
    XCTAsyncTestCaseStatusSucceeded,
    XCTAsyncTestCaseStatusFailed,
    XCTAsyncTestCaseStatusCancelled,
};
typedef NSUInteger XCTAsyncTestCaseStatus;


@interface XCTestCase (AsyncTesting)

- (void)waitForStatus:(XCTAsyncTestCaseStatus)status timeout:(NSTimeInterval)timeout;
- (void)waitForTimeout:(NSTimeInterval)timeout;
- (void)notify:(XCTAsyncTestCaseStatus)status;

@end