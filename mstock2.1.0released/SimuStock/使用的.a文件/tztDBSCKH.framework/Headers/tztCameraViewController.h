#import <UIKit/UIKit.h>
#import "tztCameraView.h"
@interface tztCameraViewController : tztkhBaseUIViewController<tztCameraViewDelegate>
{
    tztCameraView * _pCameraView;
    int         _nPicType;//0 身份证正面，1身份证反面
    NSString*   _nsURL;
    id          _tztDelegate;
}
@property (nonatomic,retain)tztCameraView * pCameraView;
@property (nonatomic,retain)NSString*       nsURL;
@property (nonatomic,assign)id              tztDelegate;
@property int nPicType;
@end
