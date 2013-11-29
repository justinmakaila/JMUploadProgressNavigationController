//
//  JMProgressView.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView.h>

/**
 *  The delegate for JMProgressView
 */
@protocol JMProgressViewDelegate <NSObject>

/**
 *  Called when an upload finished
 */
- (void)uploadFinished;

/**
 *  Called when the retry button is pressed
 */
- (void)retryButtonPressed;

/**
 *  Called when the cancel button is pressed
 */
- (void)cancelButtonPressed;

@optional
/**
 *  Called when the progress view is updated
 */
- (void)progressViewUpdated:(id)sender;

@end

/**
 *  The JMProgressView is a FXBlurView (UIView) subclass 
 *  used to keep track of upload progress
 */
@interface JMProgressView : FXBlurView

/**
 *  The delegate
 */
@property (unsafe_unretained) id<JMProgressViewDelegate> delegate;

/**
 *  The progress view used to visually display upload progress
 */
@property (strong, nonatomic) UIProgressView *progressView;

/**
 *  The label used to display the percentage uploaded
 */
@property (strong, nonatomic) UILabel *progressLabel;

/**
 *  The label used to display a message for the current upload state
 */
@property (strong, nonatomic) UILabel *messageLabel;

/**
 *  The cancel button
 */
@property (strong, nonatomic) UIButton *cancelButton;

/**
 *  The retry button
 */
@property (strong, nonatomic) UIButton *retryButton;

/**
 *  Custom message to use while uploading
 */
@property (strong, nonatomic) NSString *uploadingMessage;

/**
 *  Custom message to use while cancelling
 */
@property (strong, nonatomic) NSString *cancelledMessage;

/**
 *  Custom message to use while finishing
 */
@property (strong, nonatomic) NSString *finishedMessage;

/**
 *  Updates the progress view with the current progress
 *
 *  @param progress The percentage of progress made
 */
- (void)updateProgressView:(float)progress;

/**
 *  Sets up the progress view with default values for starting
 */
- (void)start;
/**
 *  Sets up the progress view with default values for cancelling
 */
- (void)cancel;
/**
 *  Pauses the progress view at its current progress
 */
- (void)pause;
/**
 *  Sets up the progress view with default values for failure
 */
- (void)failed;

@end
