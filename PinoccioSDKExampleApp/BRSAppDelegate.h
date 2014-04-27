//
//  BRSAppDelegate.h
//  PinoccioSDKExampleApp
//
//  Created by hector urtubia on 4/24/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinoccioSDK.h"

@interface BRSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PinoccioSDK *pinoccioSDK;

@end
