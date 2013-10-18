//
//  MasterViewController.m
//  example
//
//  Created by Matthew Seeley on 10/17/13.
//  Copyright (c) 2013 GeLo Inc. All rights reserved.
//

#import <GeLoSDK/GeLoSDK.h>
#import <Foundation/Foundation.h>

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tours = [[GeLoCache sharedCache] loadTours];
    _sites = [[GeLoCache sharedCache] loadSites];
    [[GeLoBeaconManager sharedInstance] knownSites];
    [[GeLoBeaconManager sharedInstance] loadTourById:[NSNumber numberWithInt:22] ];
    

	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBeacon:) name:kGeLoBeaconFound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nearestBeacon:) name:kGeLoNearestBeaconChanged object:nil];
    [[GeLoBeaconManager sharedInstance] startScanningForBeacons];
    NSLog(@"Scanning for Beacons!!!");
}
- (void)viewWillDisappear:(BOOL)animated{
    [[GeLoBeaconManager sharedInstance] stopScanningForBeacons];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoBeaconFound object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoNearestBeaconChanged object:nil];
    NSLog(@"Stop all the Scannin!!!");
}

- (void)foundBeacon:(NSNotification *)sender {
    // do something with the discovered beacon here
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%d",[beacon beaconId]];
    NSLog(@"Found Beacon : %@",str);
}

- (void)nearestBeacon:(NSNotification *)sender {
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%d",[beacon beaconId]];
    GeLoBeaconInfo *beaconInfo = [beacon info];
    NSString *name = [beaconInfo name];
    NSString *description = [beaconInfo description];
    NSLog(@"Nearest Beacon Changed : %@",str);
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    // Not-working Object (Beacon) example
    [_objects insertObject:beacon atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    GeLoBeacon *beacon = _objects[indexPath.row];
    GeLoBeaconInfo *beaconInfo = [beacon info];
    
    cell.textLabel.text = [beaconInfo name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
