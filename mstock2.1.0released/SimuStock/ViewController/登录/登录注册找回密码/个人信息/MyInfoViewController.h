//
//  MyInfoViewController.h
//  SimuStock
//
//  Created by jhss on 14-7-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimuIndicatorView.h"
#import "SimTopBannerView.h"
#import "MyInfomationItem.h"
#import "ChangeHeadImageViewController.h"
#import "ChangeNickNameViewController.h"
#import "PersonalSignatureViewController.h"
#import "BindingPhoneViewController.h"
#import "ThirdWayLogon.h"
#import "FTWCache.h"
#import "ChangeHeadImageController.h"
#import "UserConst.h"
#import "PhoneRegisterViewController.h"
#import "UserInfoNotificationUtil.h"


#define userInfo_headImage_index 1
#define userInfo_signature_index 2

@interface MyInfoViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          UITextFieldDelegate, UIAlertViewDelegate,
                          verifyPhoneDelegate, bindThirdPartLoginDelegate,thirdBindPhoneDelegate> {
  /** 定义表格*/
  UITableView *myInformationTableView;

  /** 手机绑定的显示类型 */
  NSInteger isPhoneRegisterMode;

  /** 个人信息数据 */
  MyInfomationItem *item;
  /** 用户绑定_手机绑定 */
  BOOL userInfoBinded;

  ChangeHeadImageController *changeHeadImageController;

  /** 手机号，qq，sina选中栏 */
  NSInteger selectedRow;

  /** 微信、手机号，qq，sina绑定：row --> 绑定类型 */
  NSMutableDictionary *rowToBindTypeDic;
  /** 尚未完成的第三方绑定 */
  BindStatus *pendingBindStatus;
  NSString * _taskId;
}

///用户信息变更通知
@property(nonatomic, strong) UserInfoNotificationUtil *userInfoNotificationUtil;

/** 三方绑定解析返回昵称 */
@property(strong, nonatomic) NSString *thirdPartNickname;
/** 三方openID */
@property(strong, nonatomic) NSString *thirdPartOpenID;
/** 三方type */
@property(assign, nonatomic) UserBindType thirdPartType;
/** 绑定的手机号 */
@property(strong, nonatomic) NSString *bindPhoneNumber;
@property(strong, nonatomic) NSString *hintString;

- (id)initWithTaskId:(NSString *)taskId;
@end
