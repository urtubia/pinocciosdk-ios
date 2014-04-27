//
//  TroopsTableViewController.m
//  PinoccioSDK
//
//  Created by hector urtubia on 4/26/14.
//  Copyright (c) 2014 Big Robot Studios, LLC. All rights reserved.
//

#import "TroopsTableViewController.h"
#import "BRSAppDelegate.h"
#import "ScoutsTableViewController.h"

static NSString *TableViewCellIdentifier = @"MyTroopCells";

@interface TroopsTableViewController ()

@property (readonly, nonatomic) BRSAppDelegate *appDelegate;
@property (nonatomic) NSMutableArray *troops;
@property (nonatomic) NSDictionary* selectedTroop;

@end

@implementation TroopsTableViewController

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
    self.title = @"Troops";
    //self.tableView.hidden = TRUE;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:TableViewCellIdentifier];
    _appDelegate = (BRSAppDelegate*) [[UIApplication sharedApplication] delegate];
    [_appDelegate.pinoccioSDK getTroops:^(NSArray *troops) {
        self.troops = [troops copy];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTroop = [self.troops objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"troopSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.troops count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
    if(self.troops == nil){
       cell.textLabel.text = @"nil";
    }else{
        cell.textLabel.text = [self.troops objectAtIndex:indexPath.row][@"name"];
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
    if([[segue identifier] isEqualToString:@"troopSegue"]){
        ScoutsTableViewController *nextViewController = segue.destinationViewController;
        nextViewController.troop = self.selectedTroop;
    }
}

@end
