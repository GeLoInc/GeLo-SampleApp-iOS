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

- (void)setBeaconInfo:(GeLoBeaconInfo *)newDetailItem
{
    if (self.detailItem != newDetailItem) {
        self.detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

// Update the user interface for the detail item.
- (void)configureView
{
    if (self.detailItem) {

		//These lines assume that the first item in the list of media 
		NSDictionary *media = [self.detailItem.mediaURLs objectAtIndex:0];
		NSString *mediaUrl = [media objectForKey:@"url"];
		NSString *imagePath = [[GeLoPlatformManager sharedInstance] getMediaPath:mediaUrl];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

		self.navigationController.title = self.detailItem.name;
        self.beaconDescriptionTextView.text = self.detailItem.description;
		self.beaconImageView.image = image;
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
