//
//  ScoutsTableViewController.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/26/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "ScoutsTableViewController.h"
#import "BRSAppDelegate.h"
#import "ScoutViewController.h"

static NSString *TableViewCellIdentifier = @"MyScoutCells";

@interface ScoutsTableViewController ()
@property (nonatomic, readonly) BRSAppDelegate* appDelegate;
@property (nonatomic, copy) NSArray* scouts;
@property (nonatomic, copy) NSDictionary* selectedScout;

@end

@implementation ScoutsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.troop[@"name"];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:TableViewCellIdentifier];
    _appDelegate = (BRSAppDelegate*) [[UIApplication sharedApplication] delegate];
    [_appDelegate.pinoccioSDK getScoutsInTroop:self.troop[@"id"] scoutsPredicate:^(NSArray *scouts) {
        self.scouts = scouts;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedScout = [self.scouts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"scoutSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scouts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
    if(self.scouts == nil){
        cell.textLabel.text = @"nil";
    }else{
        cell.textLabel.text = [self.scouts objectAtIndex:indexPath.row][@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"scoutSegue"]){
        ScoutViewController *nextViewController = segue.destinationViewController;
        nextViewController.scout = self.selectedScout;
        nextViewController.troop = self.troop;
    }
}


@end
