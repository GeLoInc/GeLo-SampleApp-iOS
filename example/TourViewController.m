//
//  MasterViewController.m
//  example
//
//  Created by Matthew Seeley on 10/17/13.
//  Copyright (c) 2013 GeLo Inc. All rights reserved.
//

#import <GeLoSDK/GeLoSDK.h>
#import <Foundation/Foundation.h>

#import "TourViewController.h"
#import "DetailViewController.h"

@interface TourViewController () {
    NSMutableArray *_objects;
	GeLoSite *_site;
}
@end

@implementation TourViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _objects = [[NSMutableArray alloc] init];

	//Platform access requires OAuth credentials provided by the GeLo platform.
    [[GeLoPlatformManager sharedInstance] setOAuth2ClientID:<#(NSString *)#> username:<#(NSString *)#> andPassword:<#(NSString *)#>];
	[[GeLoPlatformManager sharedInstance] loadSiteById:<#(NSInteger)#>];
	[[GeLoPlatformManager sharedInstance] shouldCache:YES];
}
- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siteLoaded:) name:kGeLoSiteLoaded object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siteLoaded:) name:kGeLoSiteUpToDate object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[GeLoBeaconManager sharedInstance] stopScanningForBeacons];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoSiteLoaded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGeLoSiteUpToDate object:nil];
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
    return _site.tours.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    GeLoTour *tour = _site.tours[indexPath.row];
    cell.textLabel.text = tour.name;

    return cell;
}

- (void)siteLoaded:(NSNotification *)sender
{
	_site = sender.object[@"site"];
	[[GeLoPlatformManager sharedInstance] setCurrentSite:_site];
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beaconsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GeLoTour *tour = _site.tours[indexPath.row];
        [[GeLoPlatformManager sharedInstance] setCurrentTour:tour];
    }
}

@end
