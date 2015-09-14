//
//  SettingsBaseViewController.h
//  SimuStock
//
//  Created by jhss on 13-9-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"
#import "AppUpdateInfo.h"
@interface SettingsBaseViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          UIPickerViewDelegate,
                          UIAlertViewDelegate, UIGestureRecognizerDelegate> {
  UIImageView *colorView;

  UITableView *settingsTableView;
  NSArray *settingList;
  NSArray *settingImagesArray;
  //选择器
  NSArray *pickerData;
  UIImageView *pickerBackImageView;

  //存放选中的数据
  NSString *tempPicker;
  NSInteger pickIndex;
  //手动侧滑控件
  SimuTouchMoveView *stmv_touchView;
  //是否有升级提示
  BOOL stmv_isNewVersion;
  //表格顶部，底部视图
  UIView *headView;
  UIView *footView;
  //记录推送状态
  NSString *pigeonStatus;
  //退出登录提示框
  UIAlertView *logonOutAlertView;
  //给我评分
  UIAlertView *scoreAlertView;
  //退出登录按钮
  UIButton *footerButton;

  UIView *popBackView;
}
@property(strong, nonatomic) UIImageView *headImageView;
- (void)refreshCurrentPage;
@end
