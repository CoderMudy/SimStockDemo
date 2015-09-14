//
//  ChangeHeadImageController.h
//  SimuStock
//
//  Created by Mac on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 用于修改头像的控制器 */
@interface ChangeHeadImageController
    : NSObject <UIImagePickerControllerDelegate, UIActionSheetDelegate,
                UINavigationControllerDelegate> {

  /** 头像来源表视图 */
  UIActionSheet *sheet;

  /** 调用相机 */
  UIImagePickerController *imagePickerController;

  /** 头像保存在本地 */
  UIImage *headImage;
  /** 导航 */
  UINavigationController *_navigationController;
}

- (id)initWithNavigator:(UINavigationController *)navigationController;

/** 显示修改头像的菜单 */
- (void)showActionSheet;

@end
