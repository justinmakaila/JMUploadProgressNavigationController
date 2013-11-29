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

/**
 *  Indicates whether or not the progress view is displayed
 */
@property (readonly, nonatomic, getter = isShowingUploadProgressView) BOOL showingUploadProgressView;

/**
 *  Called when the upload is started, shows the progress view
 */
- (void)uploadStarted;

/**
 *  Used to update the progress view
 *
 *  @param progress A number between 0 and 100 representing the progress completed
 */
- (void)setUploadProgress:(float)progress;

/**
 *  Called when an upload is cancelled
 */
- (void)uploadCancelled;

/**
 *  Called when an upload is resumed
 */
- (void)uploadResumed;

/**
 *  Called when an upload is paused
 */
- (void)uploadPaused;

/**
 *  Called when an upload fails
 */
- (void)uploadFailed;

@end

/**
 *  Notification posted when the cancel button is pressed
 */
extern NSString *const JMCancelUploadNotification;
/**
 *  Notification posted when the retry button is pressed
 */
extern NSString *const JMRetryUploadNotification;
