//
//  JMTestViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMTestViewController.h"
#import "JMExampleNavigationController.h"

@interface JMTestViewController ()

@property (strong, nonatomic) JMExampleNavigationController *navController;

@end

@implementation JMTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navController = (JMExampleNavigationController*)self.navigationController;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelUploadReceived:) name:JMCancelUploadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryUploadReceived:) name:JMRetryUploadNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)buttonPressed:(UIButton*)sender {
    if (sender == self.pauseButton) {
        if (self.pauseButton.isSelected) {
            [[JMAPIExample sharedClient] startOperation];
            self.pauseButton.selected = NO;
        }else {
            [[JMAPIExample sharedClient] suspendOperation];
            self.pauseButton.selected = YES;
        }
    }else if (sender == self.cancelButton) {
        [[JMAPIExample sharedClient] cancelOperation];
        [self.navController uploadCancelled];
    }else if (sender == self.failButton) {
        [[JMAPIExample sharedClient] suspendOperation];
        [self.navController uploadFailed];
    }
}

#pragma mark - Notifications

- (void)cancelUploadReceived:(NSNotification*)notification {
    [self.navController uploadCancelled];
}

- (void)retryUploadReceived:(NSNotification*)notification {
    NSLog(@"Got retry");
}

@end
