//
//  JMProgressView.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView.h>

@protocol JMProgressViewDelegate <NSObject>

- (void)uploadFinished;

- (void)retryButtonPressed;
- (void)cancelButtonPressed;

@optional
- (void)progressViewUpdated;

@end

@interface JMProgressView : FXBlurView

@property (unsafe_unretained) id<JMProgressViewDelegate> delegate;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (weak, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) UIButton *retryButton;

@property (strong, nonatomic) NSString *uploadingMessage;
@property (strong, nonatomic) NSString *cancelledMessage;
@property (strong, nonatomic) NSString *finishedMessage;

- (void)updateProgressView:(float)progress;

- (void)start;
- (void)cancel;

@end
