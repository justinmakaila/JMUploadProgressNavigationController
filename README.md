JMUploadProgressNavigationController
=============================

UINavigationController subclass that includes methods to show/hide an upload progress bar from the navigation bar.

##Usage:

###Installation:
Cocoapods:
`pod 'JMUploadProgressNavigationController'` *coming soon*

###API

+ Indicates whether or not the progress view is displayed  
`@property (readonly, nonatomic, getter = isShowingUploadProgressView) BOOL showingUploadProgressView;`

+ Called when the upload is started, shows the progress view  
`- (void)uploadStarted;`

+ Used to update the progress view  
@param progress A number between 0 and 100 representing the progress completed  
`- (void)setUploadProgress:(float)progress;`

+ Called when an upload is cancelled  
`- (void)uploadCancelled;`

+ Called when an upload is resumed  
`- (void)uploadResumed;`

+ Called when an upload is paused  
`- (void)uploadPaused;`

+ Called when an upload fails  
`- (void)uploadFailed;`
