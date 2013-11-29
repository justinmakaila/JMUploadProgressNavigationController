//
//  JMAPIExample.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAPIExample : NSObject

@property (strong, nonatomic) NSNumber *uploadProgress;
@property (nonatomic, getter = isSuspended) BOOL suspended;

+ (instancetype)sharedClient;

- (void)startOperation;
- (void)suspendOperation;
- (void)cancelOperation;

@end

@protocol JMAPIExampleDelegate <NSObject>
@optional
- (void)operationWillStart;
- (void)operationDidStart;
- (void)operationWillStop;
- (void)operationDidStop;
- (void)operationWillSuspend;
- (void)operationDidSuspend;
@end
