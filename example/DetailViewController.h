//
//  DetailViewController.h
//  example
//
//  Created by Matthew Seeley on 10/17/13.
//  Copyright (c) 2013 GeLo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
