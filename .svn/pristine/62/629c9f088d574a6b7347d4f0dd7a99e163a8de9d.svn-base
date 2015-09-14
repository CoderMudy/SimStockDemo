//
//  tztViewController.h
//  tztphonekh
//
//  Created by yangares on 14-1-10.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztkhWebView.h"
#ifndef tztCameraNon
#import "tztCameraViewController.h"
#import "CameraImageHelper.h"
#endif

@interface tztkhViewController : tztkhBaseUIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    tztkhWebView* _webView;
    NSString* _strParam;
    int  _nPhotoType;
    BOOL _bShowLeftALL; //左侧按钮总是显示
    BOOL _bShowLeftBtn;//左侧按钮显示控制（这个控制是在整个其他的web页面打开的时候避免和首页无按钮冲突）
#ifndef tztCameraNon
    tztCameraViewController *_ptztCameraVC;
#endif
}
@property (nonatomic,retain) NSString* strParam;
@property (nonatomic,retain) tztkhWebView* webView;
#ifndef tztCameraNon
@property(nonatomic, retain)tztCameraViewController *ptztCameraVC;
#endif
@property int nPhotoType;
@property BOOL bShowLeftALL;
@property BOOL bShowLeftBtn;
- (void)onWebViewNext:(int)nType;
- (void)onSetWebViewUrl:(NSString*)strUrl;
@end
