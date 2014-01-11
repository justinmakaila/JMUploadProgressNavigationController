//
//  JMAPIExample.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMAPIExample.h"

@interface JMAPIExample () {
    NSTimer *timer;
}

@end

static const float kTimerUpdateDelay = 0.5f;
static const int kProgressIncreaseAmount = 10;

@implementation JMAPIExample

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static JMAPIExample *sharedClient = nil;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[JMAPIExample alloc] init];
    });
    
    return sharedClient;
}

#pragma mark - Operations

- (void)startOperation {
    [self resumeTimer];
    self.uploadProgress = @0;
    self.suspended = NO;
}

- (void)suspendOperation {
    [timer invalidate];
    self.suspended = YES;
}

- (void)cancelOperation {
    if (timer.isValid) {
        [timer invalidate];
    }
    
    timer = nil;
}

- (void)updateProgress:(NSTimer*)sender {
    int progress = [self.uploadProgress intValue] + kProgressIncreaseAmount;
    self.uploadProgress = [NSNumber numberWithInt:progress];
    
    if (progress == 100) {
        [self cancelOperation];
    }
}

- (void)resumeTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:kTimerUpdateDelay
                                             target:self
                                           selector:@selector(updateProgress:)
                                           userInfo:nil
                                            repeats:YES];
}

@end
