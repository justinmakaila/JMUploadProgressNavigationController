//
//  JMUploadProgressViewController.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMProgressView.h"

@interface JMUploadProgressViewController : UINavigationController <JMProgressViewDelegate>

@property (readonly, nonatomic, getter = isShowingUploadProgressView) BOOL showingUploadProgressView;

- (void)uploadStarted;
- (void)setUploadProgress:(float)progress;
- (void)uploadCancelled;

@end

extern NSString *const JMCancelUploadNotification;
extern NSString *const JMRetryUploadNotification;
