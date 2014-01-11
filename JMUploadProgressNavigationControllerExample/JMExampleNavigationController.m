//
//  JMExampleNavigationController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMExampleNavigationController.h"

@interface JMExampleNavigationController ()

@property (strong, nonatomic) JMAPIExample *apiClient;

@end

static void *pUploadProgressContext = &pUploadProgressContext;
static void *pUploadStatusContext = &pUploadStatusContext;

@implementation JMExampleNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelUpload) name:JMCancelUploadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryUpload) name:JMRetryUploadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeUpload) name:JMResumeUploadNotification object:nil];

    self.apiClient = [JMAPIExample sharedClient];
#warning Change to NO to see the progress view at the top of the screen
    self.positionBottom = YES;
    
    [self addObserver:self
           forKeyPath:@"self.apiClient.uploadProgress"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:pUploadProgressContext];
    
    [self addObserver:self
           forKeyPath:@"self.apiClient.suspended"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:pUploadStatusContext];
}

- (void)cancelUpload {
    NSLog(@"Cancel upload");
    [self.apiClient cancelOperation];
    [self uploadCancelled];
}

- (void)retryUpload {
    NSLog(@"Retry upload");
    [self.apiClient startOperation];
    [self uploadStarted];
}

- (void)resumeUpload {
    NSLog(@"Resume upload");
    [self.apiClient startOperation];
    [self uploadStarted];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == pUploadProgressContext) {
        NSNumber *new = [change objectForKey:@"new"];
        [self setUploadProgress:[new floatValue]];
    }else if (context == pUploadStatusContext) {
        NSNumber *new = [change objectForKey:@"new"];
        
        if ([new boolValue]) {
            [self uploadPaused];
        }else {
            [self uploadResumed];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
