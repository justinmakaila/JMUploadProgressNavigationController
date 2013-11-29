//
//  PDetailViewController.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
