#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
@interface tztkhvideoShowViewController : tztkhBaseUIViewController
{
    AVCaptureVideoPreviewLayer *_AVCapVideoSurface;
    UIImageView *_RemoteVideoMineImage;
    UIImageView *_RemoteVideoOtherImage;
    int _nRemoteUserId;
}
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *AVCapVideoSurface;
@property (nonatomic, retain) UIImageView *RemoteVideoMineImage;
@property (nonatomic, retain) UIImageView *RemoteVideoOtherImage;
@property int nRemoteUserId;

- (void) OnLocalVideoInit:(id)session;

- (void) OnLocalVideoRelease:(id)sender;

- (void) StartMineVideoChat;
- (void) StartOtherVideoChat:(int)userid;
- (void) FinishMineVideoChat;
- (void) FinishOtherVideoChat;
@end
