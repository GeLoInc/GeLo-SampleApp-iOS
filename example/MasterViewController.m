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

    _objects = [[NSMutableArray alloc] init];

    [[GeLoCache sharedCache] loadSite:[NSNumber numberWithInt:3]];
    [[GeLoCache sharedCache] loadTours];

    [[GeLoBeaconManager sharedInstance] loadTourById:[NSNumber numberWithInt:22] ];
    [[GeLoBeaconManager sharedInstance] loadSiteById:[NSNumber numberWithInt:3 ] ];
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
    NSLog(@"Stop the Scanning!!!");
}

- (void) addBeacon: (GeLoBeacon *) beacon {
    GeLoBeaconInfo *beaconInfo = [beacon info];
    if ([[beaconInfo name] length]){
        // and it's not already in our list
        if ([_objects indexOfObject:beacon] == NSNotFound) {
            [_objects insertObject:beacon atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)foundBeacon:(NSNotification *)sender {
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%lu", (unsigned long)[beacon beaconId]];
    NSLog(@"Found Beacon : %@", str);

    // do something with the discovered beacon here
    [self performSelectorInBackground:@selector(addBeacon:) withObject:beacon];
}

- (void)nearestBeacon:(NSNotification *)sender {
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%lu", (unsigned long)[beacon beaconId]];
    NSLog(@"Nearest Beacon Changed : %@",str);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
