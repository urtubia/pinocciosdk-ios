//
//  BRSViewController.h
//  PinoccioSDKExampleApp
//
//  Created by hector urtubia on 4/24/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRSViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField* usernameTextField;
@property (nonatomic) IBOutlet UITextField* passwordTextField;
@property (nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView;
-(IBAction) loginButtonClicked:(id) sender;

@end
