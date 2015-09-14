//
//  tztCameraView.h
//  tztMobile_GTKH
//
//  Created by 张 小龙 on 13-11-11.
//
//

#import <UIKit/UIKit.h>
#import "CameraImageHelper.h"


@protocol tztCameraViewDelegate <NSObject>

-(void)tztCameraViewController:(id)vc didFinishWithInfo:(UIImage*)pInfo;
-(void)onBack;

@end

@interface tztCameraView : UIView
{
    UIView * _imageView;
    UIButton * _BtnLeft;//左边按钮
    UIButton * _BtnRight;//右边按钮
    int         _nPicType;//0 身份证正面，1身份证反面
    NSString    *_nsURL;
    id      _tztDelegate;
    UIImage * _pImage;
    int   _nType;
}
@property (nonatomic,retain)UIView * imageView;
@property (nonatomic,retain)NSString* nsURL;
@property (nonatomic,retain)UIImage* pImage;
@property (nonatomic,retain)id      tztDelegate;
@property int nPicType;
@property int nType;
@end
