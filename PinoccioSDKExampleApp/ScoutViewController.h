//
//  ScoutViewController.h
//  PinoccioSDK
//
//  Created by hector urtubia on 4/26/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoutViewController : UIViewController

-(IBAction)ledStateSwitchValueChanged:(id) sender;

@property (nonatomic, copy) NSDictionary* scout;
@property (nonatomic, copy) NSDictionary* troop;

@property (nonatomic) IBOutlet UISwitch *ledStateSwitch;

@property (nonatomic) IBOutlet UIProgressView *batteryProgressView;

@end
