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

    // Load Site and Tour - Content
    [[GeLoCache sharedCache] loadSite:[NSNumber numberWithInt:39]];
    [[GeLoCache sharedCache] loadTours];
    
    // Load Site and Tour - Beacon + Triggers
    [[GeLoBeaconManager sharedInstance] loadTourById:[NSNumber numberWithInt:81 ] ];
}
- (void)viewWillAppear:(BOOL)animated{
    // Register for notifications when beacons are found
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBeacon:) name:kGeLoBeaconFound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nearestBeacon:) name:kGeLoNearestBeaconChanged object:nil];
    
    // Have iOS begin scanning for Bluetooth beacons
    [[GeLoBeaconManager sharedInstance] startScanningForBeacons];
}
- (void)viewWillDisappear:(BOOL)animated{
    // When the view disappears, stop scanning for beacons and remove observers
    [[GeLoBeaconManager sharedInstance] stopScanningForBeacons];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoBeaconFound object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoNearestBeaconChanged object:nil];
}


- (void)foundBeacon:(NSNotification *)sender {
    // Do something with the discovered beacon here (unused for our application)
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)[beacon beaconId]];
//    NSLog(@"Found Beacon : %@",str);
}

- (void)nearestBeacon:(NSNotification *)sender {
    // Do something with the new nearest beacon here
    GeLoBeacon *beacon = sender.userInfo[@"beacon"];
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)[beacon beaconId]];
    GeLoBeaconInfo *beaconInfo = [beacon info];
    NSLog(@"Nearest Beacon Changed : %@",str);
    
    if (!_objects) {
        NSLog(@"No Objects!");
        _objects = [[NSMutableArray alloc] init];
    }
    
    // if we have a non-nil beacon with beaconInfo that's present
    if ([[beaconInfo name] length]){
        NSLog(@"Have a name!");
        
        NSString *address = [beaconInfo bannerAdUrl];
        NSLog(@"URL: %@", address);
        
        // Build the url and loadRequest
        NSString *urlString = [NSString stringWithFormat:@"%@",address];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        
        // and it's not already in our list
//        if ([_objects indexOfObject:beacon] == NSNotFound) {
//            NSLog(@"Not in the list");
//            
//            // Add that beacon to our list
        
//        DetailViewController *foo = [[DetailViewController alloc] init];
//        [foo setDetailItem:beacon];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController pushViewController: foo animated:YES];
    

////
//            
//            
//            [_objects insertObject:beacon atIndex:0];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
    }
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
