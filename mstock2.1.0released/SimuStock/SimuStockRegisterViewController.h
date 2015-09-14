//
//  SimuStockRegisterViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdWayLogon.h"

/*
 *   登陆页面XIB(暂未使用）
 */
@interface SimuStockRegisterViewController : UIViewController {
  ThirdWayLogon *_thirdWayLogon;
}

@property(assign, nonatomic) NSInteger isOtherLogin;

@property(weak, nonatomic) IBOutlet UIButton *QQLogoButton;
@property(weak, nonatomic) IBOutlet UIButton *WeiXinButton;
@property(weak, nonatomic) IBOutlet UIButton *WeiboButton;
@property(weak, nonatomic) IBOutlet UIButton *phoneOrUserNameButton;

/** 设置按钮，只在侧边栏出现 */
@property(weak, nonatomic) IBOutlet UIButton *settingButton;

@end
