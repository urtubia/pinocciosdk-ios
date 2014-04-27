pinocciosdk-ios
===============

A SDK to allow pinoccio talk to native iOS apps. The goal is to abstract the pinoccio api available at https://docs.pinocc.io/api.html and to make as simple as possible to integrate into your own applications.

## Adding the SDK
Take the files:

    PinoccioSDK/PinoccioSDK.h
    PinoccioSDK/PinoccioSDK.m
    
And add them to your project. That's it! Take a look at the header file for the currently available functionality. That's it!

## Using the SDK
The following is a method that will make all your scouts on all your troops blink blue for a second:

    -(void) blinkAllScouts
    {
        NSString *hqEmail = @"email@email.com";
        NSString *hqPassword = @"password";
        [PinoccioSDK login:hqEmail password:hqPassword response:^(PinoccioSDK *pinoccioSdk) {
            if(pinoccioSdk != nil){
                [pinoccioSdk getTroops:^(NSArray *troops) {
                    for(NSDictionary *troop in troops){
                        NSLog(@"%@", troop[@"name"]);
                        NSString *troop_id = troop[@"id"];
                        [pinoccioSdk getScoutsInTroop:troop_id scoutsPredicate:^(NSArray *scouts) {
                            for(NSDictionary *scout in scouts){
                                NSLog(@"--- %@", scout[@"name"]);
                                NSString *scout_id = scout[@"id"];
                                [pinoccioSdk runBitlashCommand:troop_id scoutId:scout_id command:@"led.blink(0,0,255,1000)" responsePredicate:^(NSDictionary *response) {}];
                            
                            };
                        }];
                    
                    }
                
                }];
            }else{
                NSLog(@"Login failed");
            }
        }];
    }

## Sample Application
The Xcode project also includes a sample application that consumes the sdk. To run it, select the "PinoccioExampleApp" target from the IDE. The sources for the sample app are under the `PinoccioSDKExampleApp` directory.
The following is a demo capture of the sample app:

![gid demo](https://raw.githubusercontent.com/urtubia/pinocciosdk-ios/master/sampleapp-demo.gif)

### Considerations
* All methods do their work asynchronously. Expect the receiver blocks on used on most calls to be returned on a different thread.
* I'm still working on implementing more functionality from the api at https://docs.pinocc.io/api.html Stay tuned.
* The functional test on this project will work only if you configure it with your hq username, password, troop and scout's name.
