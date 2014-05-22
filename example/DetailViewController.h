//
//  DetailViewController.h
//  example
//
//  Created by Matthew Seeley on 10/17/13.
//  Copyright (c) 2013 GeLo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GeLoSDK/GeLoSDK.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) GeLoBeaconInfo *detailItem;

@property (weak, nonatomic) IBOutlet UITextView *beaconDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *beaconImageView;

- (void)setBeaconInfo:(GeLoBeaconInfo *)newDetailItem;

@end
