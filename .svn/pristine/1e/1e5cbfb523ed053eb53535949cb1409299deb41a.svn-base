//
//  BrokerageAccountListVC.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
//侧栏
#import "BrokerNameListTableView.h"
//开户
#import "OpenAccountViewController.h"
//是否登录
#import "FullScreenLogonViewController.h"

/**
 * 券商开户ViewController  由券商列表 和 券商简介组成
 */
@interface BrokerageAccountListVC : BaseViewController {
  //右上角的客服或者开户点击按钮
  UIButton *customerServiceOrAccountButton;
}
///券商列表
@property(strong, nonatomic) BrokerNameListTableView *brokerNameTableView;
///开户简介
@property(strong, nonatomic) OpenAccountViewController *openAccountVC;
///登录界面的回调block
@property(copy, nonatomic) OnLoginCallBack onLoginCallBack;
/** init + 登录判断 */
- (id)initWithOnLoginCallbalck:(OnLoginCallBack)onLoginCallback;

@end
