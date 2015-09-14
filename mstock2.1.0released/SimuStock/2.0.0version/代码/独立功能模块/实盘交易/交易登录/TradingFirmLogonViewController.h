//
//  TradingFirmLogonViewController.h
//  SimuStock
//
//  Created by jhss on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "RealTradeSecuritiesCompanyList.h"
#import "RealTradeLoginResponse.h"
#import "RealTradeRequester.h"
#import "CustomizeNumberKeyBoard.h"
#import "RealTradeUrls.h"
#import "RealTradeTodayEntrust.h"
#import "CheckNumberButton.h"
#import "simuRealTradeVC.h"

#define tradeStock_verticalSpace 48
#define tradeStock_leftFixedSpace 90
#define login_entry_limit 5
#define five_minuteToSecond 300
#define arrow_up 1
#define arrow_down 2

@interface TradingFirmLogonViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          UITextFieldDelegate, customizeNumKeyBoardDelegate,
                          UITextFieldDelegate> {
  /** 验证码 */
  UIImageView *verifyNumberImageView;
  /** 保存按钮 */
  UIImageView *checkMarkImageView;
  /** 行1_下三角 */
  UIImageView *fsRowArrow;
  /** 行2_下三角 */
  UIImageView *seRowArrow;
  /** 证券平台array + 表格 */
  UITableView *stockPlatFormTableView;
  NSArray *stockPlatformArray;
  /** 账号类型 */
  UITableView *fundSortTableView;
  NSArray *fundSortArray;
  /** 选择股票平台 */
  UIButton *stockSortBtn;
  /** 选择资金账号 */
  UIButton *fundAccountBtn;
  /** 自定义密码键盘 */
  CustomizeNumberKeyBoard *customKeyBoard;
  /** 交易密码 */
  UITextField *tradePasswordTextField;
  /** 资金账号 */
  UITextField *fundAccountTextField;
  /** 记录资金账号 */
  NSString *_fundAccountStr;
  /** 验证码 */
  UITextField *verifyNumberTextfield;
  /** 保存账户信息 */
  CheckNumberButton *saveInfoSwitch;
  /**  CheckNumberButton *saveInfoButton; */
  /** 顶部label覆盖框 */
  UITextField *topTextField;
  /** 等待菊花 */
  UIActivityIndicatorView *indicator;
  /** 重刷透明按钮 */
  UIButton *verifyNumberBtn;
  /** 箭头类型 */
  NSInteger arrowType_stockSort;
  NSInteger arrowType_fundType;
}

@property(nonatomic, strong) RealTradeSecuritiesCompanyList *companyList;

@property(nonatomic, strong) RealTradeSecuritiesCompany *currentCompany;

@property(nonatomic, strong) RealTradeSecuritiesAccountType *currentAccountType;
@end
