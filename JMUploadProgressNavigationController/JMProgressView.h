//
//  JMProgressView.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LDProgressView.h>
#import <UIKit+AFNetworking.h>

/**
 *  The delegate for JMProgressView
 */
@protocol JMProgressViewDelegate <NSObject>

/**
 *  Called when the retry button is pressed
 */
- (void)actionButtonPressed:(NSInteger)tag;

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
 *  The JMProgressView is a UIView subclass 
 *  used to keep track of upload progress
 */
@interface JMProgressView : UIView

/**
 *  The delegate
 */
@property (unsafe_unretained) id<JMProgressViewDelegate> delegate;

/**
 *  Content view. Holds all content. Enables the swipe animation
 */
@property (strong, nonatomic) UIView *contentView;

/**
 *  Image to display to the left of the progress view
 */
@property (strong, nonatomic) UIImageView *imageView;

/**
 *  The progress view used to visually display upload progress
 */
@property (strong, nonatomic) LDProgressView *progressView;

/**
 *  Indicates whether or not the view is being dragged
 */
@property (nonatomic, getter = isDragging) BOOL dragging;

/**
 *  Inidcates whether or not the view is open
 */
@property (nonatomic, getter = isOpen) BOOL open;

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

/**
 *  Presents the message and action button requiring user permission to upload
 */
- (void)requestUploadPermission;

/**
 *  Animates the view to the closed position
 */
- (void)animateToClose;

/**
 *  Animates the view to the open positions
 */
- (void)animateToOpen;

@end
