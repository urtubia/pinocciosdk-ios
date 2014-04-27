//
//  BRSViewController.m
//  PinoccioSDKExampleApp
//
//  Created by hector urtubia on 4/24/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "BRSViewController.h"
#import "BRSAppDelegate.h"

//  http://stackoverflow.com/questions/8190980/ios-make-segue-wait-for-login-success

@interface BRSViewController ()

@end

@implementation BRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.activityIndicatorView.hidden = TRUE;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)showLoginUnsuccesful
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to login" message:@"Unable to login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

-(IBAction)loginButtonClicked:(id)sender
{
    BRSAppDelegate *appDelegate = (BRSAppDelegate*)[[UIApplication sharedApplication] delegate];
    _activityIndicatorView.hidden = FALSE;
    [_activityIndicatorView startAnimating];
    [PinoccioSDK login:_usernameTextField.text password:_passwordTextField.text response:^(PinoccioSDK *sdk) {
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.hidden = TRUE;
        if(sdk == nil){
            [self showLoginUnsuccesful];
        }else{
            appDelegate.pinoccioSDK = sdk;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}
@end
