//
//  PDetailViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMSampleViewController.h"
#import "JMExampleNavigationController.h"

@interface JMSampleViewController ()

@property (strong, nonatomic) JMExampleNavigationController *navController;

@end

@implementation JMSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JMUploadProgressViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    if ([sender isEqual:self.showButton]) {
        [self.navController uploadStarted];
        [[JMAPIExample sharedClient] startOperation];
    }else if ([sender isEqual:self.hideButton]) {
        [self.navController uploadCancelled];
        [[JMAPIExample sharedClient] cancelOperation];
    }else if ([sender isEqual:self.startButton]) {
        if (self.startButton.isSelected) {
            [[JMAPIExample sharedClient] suspendOperation];
            self.startButton.selected = NO;
        }else {
            if (!self.navController.isShowingUploadProgressView) {
                [self.navController uploadStarted];
            }
            
            [[JMAPIExample sharedClient] startOperation];
            self.startButton.selected = YES;
        }
    }
}

#pragma mark - Notifications

- (void)cancelUploadReceived:(NSNotification*)notification {
    [self.navController uploadCancelled];
}

- (void)retryUploadReceived:(NSNotification*)notification {
    [[JMAPIExample sharedClient] cancelOperation];
    [[JMAPIExample sharedClient] startOperation];
}

@end
