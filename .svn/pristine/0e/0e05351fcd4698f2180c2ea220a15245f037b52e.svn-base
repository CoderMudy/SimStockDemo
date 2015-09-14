//
//  AccountsViewController.h
//  SimuStock
//
//  Created by Mac on 15-3-2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "StockLogonViewController.h"
#import "OpenAccountViewController.h"
#import "DataArray.h"
#import "FullScreenLogonViewController.h"

/** 登录界面 */
@interface AccountsViewController : BaseViewController {
  //右侧栏承接界面
  UIView *detailView;
  //右上角的客服或者开户点击按钮
  UIButton *customerServiceOrAccountButton;
  ///是否实盘开户转户页面
  BOOL isOpenStockAccountPage;
  ///是否实盘交易登录页面
  BOOL isLoginStockAccountPage;

  ///传入参数：指定的券商，在selectedCellIndex= -1 时有效
  NSString *_selectedCompanyName;
}
@property(copy, nonatomic) OnLoginCallBack onLoginCallBack;

@property(strong, nonatomic) OpenAccountViewController *openAccoutnVC;

@property(strong, nonatomic) StockLogonViewController *stockLogonVC;

/** 界面功能 */
@property(nonatomic, strong) NSString *pageTitle;
/** 券商列表 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyList *companyList;
/** 当前公司 */
@property(nonatomic, strong) RealTradeSecuritiesCompany *currentCompany;
/** 当前开户类型 */
@property(nonatomic, strong) RealTradeSecuritiesAccountType *currentAccountType;

/** 使用页面名称和指定的券商初始化页面 */
- (id)initWithPageTitle:(NSString *)pageTitile
        withCompanyName:(NSString *)selectedCompanyName
        onLoginCallBack:(OnLoginCallBack)onLoginCallBack;

/** 检查实盘的登录状态，
 * 如果未登录，显示登录方式选择页面，待登录成功后执行回调block，
 * 否则，直接执行回调block
 */
+ (void)checkLogonRealTradeAndDoBlock:(OnLoginCallBack)block;

@end
