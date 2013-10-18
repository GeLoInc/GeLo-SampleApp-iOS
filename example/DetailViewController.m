//
//  DetailViewController.m
//  example
//
//  Created by Matthew Seeley on 10/17/13.
//  Copyright (c) 2013 GeLo Inc. All rights reserved.
//

#import "DetailViewController.h"
#import <GeLoSDK/GeLoSDK.h>

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}
- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        // Get Beacon and Beacon Info
        GeLoBeacon *beacon = self.detailItem;
        GeLoBeaconInfo *beaconInfo = [beacon info];
        
        // Set title
        self.title = [beaconInfo name];

        // Set Site and Tour Name
        NSString *siteName = [[[GeLoBeaconManager sharedInstance] currentSite] name];
        NSString *tourName = [[[GeLoBeaconManager sharedInstance] currentTour] name];
        NSString *promptString = [NSString stringWithFormat:@"%@ : %@", siteName, tourName];
        [[self navigationItem] setPrompt: promptString];
        
        // Set Image (if beacon has one present)
        if (beaconInfo.images.count) {
            NSLog(@"Beacon contains an image, loading...");
            self.beaconImageView.image = [[GeLoCache sharedCache] loadImage:beaconInfo.images[0]];
        }
        
        // Set Description Text
        self.beaconDescriptionTextView.text = [beaconInfo description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Resize subview when rotating
    [self.scrollView setAutoresizesSubviews:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
