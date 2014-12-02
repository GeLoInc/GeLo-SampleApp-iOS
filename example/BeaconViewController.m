//
//  BeaconViewController.m
//  example
//
//  Created by Thomas Peterson on 5/9/14.
//  Copyright (c) 2014 GeLo Inc. All rights reserved.
//

#import "BeaconViewController.h"
#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GeLoSDK/GeLoSDK.h>

@interface BeaconViewController () {
	NSArray *_beacons;
}

@end

@implementation BeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconFound:) name:kGeLoBeaconFound object:nil];
    [self tryToStartScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[GeLoBeaconManager sharedInstance] stopScanningForBeacons];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoBeaconFound object:nil];
}

- (void)tryToStartScanning {
    NSInteger status = [CLLocationManager authorizationStatus];
    if([CLLocationManager locationServicesEnabled]){
        if(status == kCLAuthorizationStatusDenied) {
            NSLog(@"CL Denied");
        }else if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"CL Authorized");
            [[GeLoBeaconManager sharedInstance] startScanningForBeacons];
        }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            NSLog(@"You didn't ask for CL permission");
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Services"
                                                        message:@"This app contains location sensitive content that utilizes location services. Please go to settings and enable Location Services."
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)beaconFound:(NSNotification *)sender {
	//knownTourBeacons will only return beacons if a current tour is set in the platform.
	_beacons = [[GeLoBeaconManager sharedInstance] knownTourBeacons];
	[self.tableView reloadData];
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
    return [_beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	GeLoBeacon *beacon = _beacons[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)beacon.beaconId];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"infoSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		GeLoBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
		GeLoBeaconInfo *info = [beacon info];
		DetailViewController *vc = [segue destinationViewController];
		[vc setBeaconInfo:info];
    }
}

@end
