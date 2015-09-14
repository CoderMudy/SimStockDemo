//
//  ChangeHeadImageController.m
//  SimuStock
//
//  Created by Mac on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChangeHeadImageController.h"
#import "ChangeHeadImageViewController.h"
#import "AppDelegate.h"
#import "ImageUtil.h"
#import "ChangeUserInfoRequest.h"
#import "NSString+MD5Addition.h"
#import "FTWCache.h"
#import "DoTaskStatic.h"
#import "TaskIdUtil.h"

@implementation ChangeHeadImageController

- (id)initWithNavigator:(UINavigationController *)navigationController {
  if (self = [super init]) {
    _navigationController = navigationController;
  }
  return self;
}

- (void)showActionSheet {
  sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像"
                                      delegate:self
                             cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                             otherButtonTitles:nil];
  sheet.delegate = self;
  int rowIndex = 0;
  [sheet addButtonWithTitle:@"系统头像"];
  rowIndex++;
  if ([UIImagePickerController
          isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    // 判断是否支持相机
    [sheet addButtonWithTitle:@"拍照"];
    rowIndex++;
  }
  [sheet addButtonWithTitle:@"从相册选择"];
  rowIndex++;
  [sheet addButtonWithTitle:@"取消"];
  sheet.cancelButtonIndex = rowIndex;

  [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark
#pragma mark----头像(sheetDelegate)-----
- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

  if ([@"取消" isEqualToString:buttonTitle]) {
    return;
  }

  if ([@"系统头像" isEqualToString:buttonTitle]) {
    [AppDelegate pushViewControllerFromRight:
                     [[ChangeHeadImageViewController alloc] init]];
    return;
  }

  UIImagePickerControllerSourceType sourceType =
      UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  BOOL imagePicker = NO;
  if ([@"拍照" isEqualToString:buttonTitle]) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker = YES;
  } else if ([@"从相册选择" isEqualToString:buttonTitle]) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker = YES;
  }
  if (imagePicker) {
    // 跳转到相机或相册页面
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [_navigationController presentViewController:imagePickerController
                                        animated:YES
                                      completion:^(){
                                      }];
  }
}
#pragma mark - image picker delegte
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:NO
                             completion:^{

                             }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *originalImage = info[UIImagePickerControllerEditedImage];
  if (!originalImage) {
    return;
  }
  UIImage *image =
      [ImageUtil imageWithImage:originalImage scaledToSize:originalImage.size];
  headImage = [image copy];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  headImage = [ImageUtil imageForUploadFromImage:headImage];
  NSData *picFile = UIImageJPEGRepresentation(headImage, 0.8);

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:@"头像修改成功"];

    CustomeAvatarRequestObject *headInfo = (CustomeAvatarRequestObject *)obj;
    NSString *key = [headInfo.headpic stringFromMD5];
    [FTWCache setObject:picFile forKey:key];
    [SimuUtil setUserImageURL:headInfo.headpic];
    [self onHeadImageChanged:headInfo.headpic];
  };

  JhssPostData *postData = [[JhssPostData alloc] init];
  postData.data = picFile;
  postData.contentType = @"image/jpeg";
  postData.filename = @"pic.jpg";
  //头像上传
  [ChangeUserInfoRequest changeNickname:nil
                       withNewSignature:nil
                             withSyspic:nil
                            withPicFile:postData
                withHttpRequestCallBack:callback];

  [picker dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (void)onHeadImageChanged:(NSString *)url {

  [NewShowLabel setMessageContent:@"头像修改成功"];
  if ([[SimuUtil getPersonalInfo] isEqualToString:@""]) {
    [SimuUtil setPersonalInfo:TASK_PERSONAL_INFO];
    [DoTaskStatic doTaskWithTaskType:TASK_PERSONAL_INFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalInfo"
                                                        object:nil];
  } else {
    NSLog(@"完善个人资料任务已完成！！！");
  }
  [SimuUtil setUserImageURL:url ? url : @""];
  [[NSNotificationCenter defaultCenter] postNotificationName:NT_HeadPic_Change
                                                      object:nil];
}

#pragma mark----------zxc实现ActionSheet的代理方法----------
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
  for (UIView *_currentView in actionSheet.subviews) {
    // NSLog(@"%@",actionSheet.subviews);
    //判断_currentView 是UILabel类或者UILabel的子类
    // isMemberOfClass 判断成员
    // isKindOfClass和isMemberOfClass返回值是BOOL
    if ([_currentView isKindOfClass:[UILabel class]]) {
      UILabel *label = [[UILabel alloc] initWithFrame:_currentView.frame];
      //强制转换
      label.text = [(UILabel *)_currentView text];
      [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
      label.textColor = [UIColor lightGrayColor];
      label.backgroundColor = [UIColor clearColor];
      [label sizeToFit];
      [label setCenter:CGPointMake(actionSheet.center.x, 25)];
      [label setFrame:CGRectIntegral(label.frame)];
      [actionSheet addSubview:label];
      _currentView.hidden = YES;
      break;
    }
  }
}

@end
