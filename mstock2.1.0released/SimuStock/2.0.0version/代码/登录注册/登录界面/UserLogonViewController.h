//
//  UserLogonViewController.h
//  SimuStock
//
//  Created by jhss on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"


#define side_edge_width 20
#define arrow_up   1
#define arrow_down 2
@interface UserLogonViewController
    : BaseViewController <UITextFieldDelegate, UITableViewDataSource,
                          UITableViewDelegate, UIApplicationDelegate,
                          UIAlertViewDelegate> {

  UIImageView *arrowImageView;
  /** 用户名历史记录 */
  NSArray *historyUserNameArray;
  UITableView *historyTableView;
  UIImageView *tableViewBackgroundImageView;
  UIView *tableViewBackgroundView;
  /** 新用户注册image */
  UIButton *newUserHeadImageButton;
  /** 注册新用户 */
  UIButton *newUserIconButton;
  /** 忘记密码 */
  UIButton *lossPasswordIconButton;
  /** 用户名输入栏 */
  UITextField *userNameTextField;
  /** 密码输入栏 */
  UITextField *passwordTextField;

  /** 分割线 */
  UILabel *firstCuttingLineLabel;
  /** 注册新用户label */
  UILabel *newUserLabel;
  /** 忘记密码label */
  UILabel *lossPasswordLabel;
  
  /** 右上角登录按钮 */
  UIButton *logonButton;
  //箭头类型
  NSInteger arrowType;
                            
}

@end
