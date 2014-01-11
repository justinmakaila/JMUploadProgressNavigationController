//
//  JMProgressView.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMProgressView.h"
#import "UIColor+Hex.h"

/**
 *  Percentage limit to trigger the first action
 */
static CGFloat const kJMStop1 = 0.2;

/**
 *  Percentage limit to trigger the second action
 */
static CGFloat const kJMStop2 = 0.000001;

/**
 *  Maximum bounce amplitude
 */
static CGFloat const kBounceAmplitude = 20.0;

/**
 *  Duration of the first part of the bounce animation
 */
static NSTimeInterval const kBounceDuration1 = 0.2;

/**
 *  Duration of the second part of the bounce animation
 */
static NSTimeInterval const kBounceDuration2 = 0.1;

/**
 *  Lowest duration when swiping the cell to simulate velocity
 */
static NSTimeInterval const kJMDurationLowLimit = 0.25;

/**
 *  Highest duration when swiping the cell to simulate velocity
 */
static NSTimeInterval const kJMDurationHighLimit = 0.1;

typedef enum {
    kActionButtonStyleGo = 700,
    kActionButtonStyleRetry = 800
} JMActionButtonStyleTag;

@interface JMProgressView () <UIGestureRecognizerDelegate> {
    JMSwipeDirection direction;
    
    CGFloat currentPercentage;
}

@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *actionButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

static NSString *const kUploadingMessage = @"Finishing up";
static NSString *const kNoWiFiMessage    = @"Finish up without wifi?";
static NSString *const kPausedMessage    = @"Paused";
static NSString *const kFailedMessage    = @"Can't reach Present";
static NSString *const kCancelledMessage = @"Cancelled";
static NSString *const kFinishedMessage  = @"Finished!";

static NSString *const kRetryButtonText = @"Retry";
static NSString *const kGoButtonText = @"Go";

@implementation JMProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor colorWithHexString:@"212121"];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(320, CGRectGetMidY(self.bounds) - 15, 30, 30);
    [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"212121"];
    [self addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.imageView.layer.cornerRadius = 4.0f;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    self.progressView = [[LDProgressView alloc] init];
    self.progressView.frame = CGRectMake(70, 20, 240, 30);
    self.progressView.showText = @NO;
    self.progressView.type = LDProgressSolid;
    self.progressView.animate = @YES;
    self.progressView.background = [UIColor colorWithHexString:@"999"];
    self.progressView.color = [UIColor purpleColor];
    self.progressView.borderRadius = @4;
    self.progressView.clipsToBounds = YES;
    [self.contentView addSubview:self.progressView];
    
    [self setupProgressView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureReceived:)];
    self.panGesture.delegate = self;
    [self.contentView addGestureRecognizer:self.panGesture];
}

- (void)setupProgressView {
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.progressView.bounds), CGRectGetHeight(self.progressView.bounds))];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.statusLabel.textColor = [UIColor whiteColor];
    [self.progressView addSubview:self.statusLabel];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame = CGRectMake(190, 0, 50, 30);
    self.actionButton.clipsToBounds = YES;
    self.actionButton.backgroundColor = [UIColor blackColor];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.actionButton.hidden = YES;
    [self.progressView addSubview:self.actionButton];
}

- (void)setBackgroundImage:(UIImage *)image {
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)updateProgressView:(float)progress {
    self.progressView.progress = (progress / 100);
}

- (void)start {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kUploadingMessage.uppercaseString;
}

- (void)cancel {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kCancelledMessage.uppercaseString;
}

- (void)pause {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kPausedMessage.uppercaseString;
}

- (void)failed {
    self.statusLabel.text = kFailedMessage.uppercaseString;
    
    self.actionButton.tag = kActionButtonStyleRetry;
    [self.actionButton setTitle:kRetryButtonText forState:UIControlStateNormal];
    if (self.actionButton.isHidden) {
        self.actionButton.hidden = NO;
    }
}

- (void)requestUploadPermission {
    self.statusLabel.text = kNoWiFiMessage.uppercaseString;
    
    self.actionButton.tag = kActionButtonStyleGo;
    [self.actionButton setTitle:kGoButtonText forState:UIControlStateNormal];
    if (self.actionButton.isHidden) {
        self.actionButton.hidden = NO;
    }
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        CGPoint translation = [self.panGesture translationInView:self.contentView];
        return fabs(translation.x) > fabs(translation.y);
    }else {
        return YES;
    }
}

- (void)panGestureReceived:(UIPanGestureRecognizer*)gesture {
    UIGestureRecognizerState state = gesture.state;
    CGPoint translation = [gesture translationInView:self.contentView];
    CGPoint velocity = [gesture velocityInView:self.contentView];
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToDimension:CGRectGetWidth(self.bounds)];
    direction = [self directionWithPercentage:percentage];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.dragging = YES;
        
        if ((direction == kJMSwipeDirectionCenter || direction == kJMSwipeDirectionRight) && (velocity.x > 0 && self.contentView.center.x >= self.center.x)) {
            return;
        }
        
        CGPoint newCenter = { self.contentView.center.x + translation.x, self.contentView.center.y };
        self.contentView.center = newCenter;
        
        [gesture setTranslation:CGPointZero inView:self];
    }else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateEnded) {
        self.dragging = NO;
        
        currentPercentage = percentage;
        
        if (direction == kJMSwipeDirectionLeft && self.contentView.center.x < self.center.x) {
            [self animateToDelete];
        }else {
            [self bounceToOrigin];
        }
    }
}

#pragma mark - IBActions

- (void)actionButtonPressed:(UIButton*)sender {
    [_delegate actionButtonPressed:sender.tag];
}

- (void)cancelButtonPressed {
    if ([_delegate respondsToSelector:@selector(cancelButtonPressed)]) {
        [_delegate cancelButtonPressed];
    }
}

#pragma mark - Utilities

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToDimension:(CGFloat)dimension {
    CGFloat percentage = offset / dimension;
    
    if (percentage < -1.0) {
        percentage = -1.0;
    }else if (percentage > 1.0) {
        percentage = 1.0;
    }
    
    return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    CGFloat height = CGRectGetHeight(self.bounds);
    NSTimeInterval animationDurationDiff = kJMDurationHighLimit - kJMDurationLowLimit;
    CGFloat verticalVelocity = velocity.y;
    
    if (verticalVelocity < -height) {
        verticalVelocity = -height;
    }else if (verticalVelocity > height) {
        verticalVelocity = height;
    }
    
    return (kJMDurationHighLimit + kJMDurationLowLimit) - fabs(((verticalVelocity / height) * animationDurationDiff));
}

- (JMSwipeDirection)directionWithPercentage:(CGFloat)percentage {
    if (percentage < -kJMStop1) {
        return kJMSwipeDirectionLeft;
    }else if (percentage > kJMStop2) {
        return kJMSwipeDirectionRight;
    }else {
        return kJMSwipeDirectionCenter;
    }
}

#pragma mark - Animations

-(void)bounceToOrigin {
    CGFloat bounceDistance = kBounceAmplitude * currentPercentage;
    [UIView animateWithDuration:kBounceDuration1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = -bounceDistance;
                         self.contentView.frame = frame;
                         
                         CGRect cancelButtonFrame = self.cancelButton.frame;
                         cancelButtonFrame.origin.x = 320;
                         self.cancelButton.frame = cancelButtonFrame;
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:kBounceDuration2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGRect frame = self.contentView.frame;
                                              frame.origin.x = 0;
                                              self.contentView.frame = frame;
                                          }completion:nil];
                     }];
}

-(void)animateToDelete {
    [UIView animateWithDuration:kBounceDuration1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = { self.center.x - 100, self.contentView.center.y };
                         self.contentView.center = center;
                         
                         CGRect cancelButtonFrame = self.cancelButton.frame;
                         cancelButtonFrame.origin.x = CGRectGetMinX(cancelButtonFrame) - 100;
                         self.cancelButton.frame = cancelButtonFrame;
                     }completion:nil];
}

@end
