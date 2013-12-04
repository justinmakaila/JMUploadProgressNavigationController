//
//  JMTestViewController.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UIButton *failButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)buttonPressed:(UIButton*)sender;

@end
