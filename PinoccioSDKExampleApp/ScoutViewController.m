//
//  ScoutViewController.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/26/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "ScoutViewController.h"
#import "BRSAppDelegate.h"

@interface ScoutViewController ()
@property (nonatomic) BRSAppDelegate *appDelegate;

@end

@implementation ScoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.scout[@"name"];
    _appDelegate = (BRSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.batteryProgressView.hidden = true;
    [self.appDelegate.pinoccioSDK runBitlashCommand:self.troop[@"id"] scoutId:self.scout[@"id"] command:@"power.report()" responsePredicate:^(NSDictionary *response) {
        if(response[@"data"] != nil){
            NSString *reply = response[@"data"][@"reply"];
            NSError *error;
            id json = [NSJSONSerialization JSONObjectWithData:[reply dataUsingEncoding:NSASCIIStringEncoding]
                                                      options:kNilOptions
                                                        error:&error];
            NSNumber *val = json[@"battery"];
            self.batteryProgressView.hidden = false;
            self.batteryProgressView.progress = [val floatValue] / 100;
        }else{
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ledStateSwitchValueChanged:(id)sender
{
    NSString *command = @"led.on()";
    if(![self.ledStateSwitch isOn]){
        command = @"led.off()";
    }
    [self.appDelegate.pinoccioSDK runBitlashCommand:self.troop[@"id"] scoutId:self.scout[@"id"] command:command responsePredicate:^(NSDictionary *response) {
            // Ignore response
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
