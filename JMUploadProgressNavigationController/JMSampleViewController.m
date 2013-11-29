//
//  PDetailViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMSampleViewController.h"
#import "JMUploadProgressViewController.h"

@interface JMSampleViewController () {
    float progress;
    NSTimer *timer;
}

@property (strong, nonatomic) JMUploadProgressViewController *navController;

@end

@implementation JMSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelUploadReceived:) name:JMCancelUploadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryUploadReceived:) name:JMRetryUploadNotification object:nil];
    
    self.view.backgroundColor = [UIColor redColor];
    progress = 0.0f;
}

- (IBAction)buttonPressed:(UIButton*)sender {
    if (!self.navController) {
        self.navController = (JMUploadProgressViewController*)self.navigationController;
    }
    
    if ([sender isEqual:self.showButton]) {
        if (timer) {
            [self stopTimer];
        }
        
        [self.navController uploadStarted];
        [self startTimer];
    }else {
        [self.navController uploadCancelled];
        [self stopTimer];
        progress = 0.0f;
    }
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                             target:self
                                           selector:@selector(updateProgress:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)stopTimer {
    if ([timer isValid]) {
        [timer invalidate];
    }
    
    timer = nil;
}

- (void)updateProgress:(NSTimer*)sender {
    int random = arc4random() % 101;
    
    [self.navController setUploadProgress:random];
    
    if (random >= 100.0) {
        [self stopTimer];
        progress = 0.0f;
        [self.navController uploadFinished];
    }
}

#pragma mark - Notifications

- (void)cancelUploadReceived:(NSNotification*)notification {
    [self.navController uploadCancelled];
    [self stopTimer];
}

- (void)retryUploadReceived:(NSNotification*)notification {
    NSLog(@"Got retry");
}

@end
