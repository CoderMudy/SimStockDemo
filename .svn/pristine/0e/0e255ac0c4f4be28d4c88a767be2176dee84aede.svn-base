//
//  StockLogonViewController.h
//  SimuStock
//
//  Created by Mac on 15-3-3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "TTTAttributedLabel.h"
#import "CustomizeNumberKeyBoard.h"
#import "RealTradeSecuritiesCompanyList.h"
#import "CheckNumberButton.h"
#import "RealTradeRequester.h"
#import "Image_TextButton.h"

#import "ActualQuotationUserPinlessData.h"

typedef NS_ENUM(NSUInteger, StockSortType) {
  /** 德邦 */
  StockSortTypeDeBang = 1,
  /** 东莞 */
  StockSortTypeDongGuan = 2,
};

/** 登录限制次数 */
#define login_entry_limit 5
/** 5分钟 */
#define five_minuteToSecond 300

@interface StockLogonViewController
    : UIViewController <TTTAttributedLabelDelegate,
                        customizeNumKeyBoardDelegate, UITextFieldDelegate> {
  /** 自定义密码键盘 */
  CustomizeNumberKeyBoard *customKeyBoard;
  /** 记录资金账号 */
  NSString *_fundAccountStr;
  /** 选择资金账号/客户号 */
  NSInteger selectdFundType;
  /** 证券信息 */
  RealTradeSecuritiesCompany *currentCompany;
  /** 客服电话 */
  Image_TextButton *sevicesBtn;
  /** 开户指引 */
  Image_TextButton *tradeGuideBtn;
  /** 是否同意用户使用协议 */
  BOOL isAcceptAgreement;
  /** 实盘操作所需信息 */
  id urlFactory;
  /** 实盘登录信息 */
  RealTradeLoginResponse *loginInfo;
}
@property(strong, nonatomic) NSString *tempStockCode;
#pragma mark - ui
/** 分割线 */
@property(weak, nonatomic) IBOutlet UIView *FTLineView;
@property(weak, nonatomic) IBOutlet UIView *SeLineView;
@property(strong, nonatomic) IBOutlet UIView *ThLineView;
@property(weak, nonatomic) IBOutlet UIView *VeLineView;

/** 客户号 */
@property(weak, nonatomic) IBOutlet UITextField *clientNumberTextField;
/** 交易密码 */
@property(weak, nonatomic) IBOutlet UITextField *tradePasswordTextField;
/** 交易密码屏蔽按钮 */
@property(weak, nonatomic) IBOutlet UIButton *overFundTFButton;
/** 验证码 */
@property(weak, nonatomic) IBOutlet UITextField *verifyNumberTextField;
/** 客户号与资金账号图标按钮 */
@property(weak, nonatomic) IBOutlet UIButton *clientNumTypeBtn;

/** 验证码图标 */
@property(weak, nonatomic) IBOutlet UIImageView *verifyNumImageView;
/** 验证码上部透明按钮 */
@property(weak, nonatomic) IBOutlet UIButton *verifyNumButton;
/** 验证码顶部菊花控件 */
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *verifyIndicator;
/** 选择器 */
@property(weak, nonatomic) IBOutlet UISwitch *saveInfoSwitch;
/** 实盘登录按钮 */
@property(weak, nonatomic) IBOutlet UIButton *firmLogonButton;
/** 券商客服 */
@property(weak, nonatomic) IBOutlet UIView *serviceView;
/** 交易指引 */
@property(weak, nonatomic) IBOutlet UIView *tradeGuideView;
/** 客户使用须知 */
@property(weak, nonatomic) IBOutlet UIView *clientGuideView;
/** 用户遵守协议按钮 */
@property(weak, nonatomic) IBOutlet UIButton *clientGuideSelectedBtn;
/** 对号图标 */
@property(weak, nonatomic) IBOutlet UIImageView *tickImageView;
/** 使用须知按钮 */
@property(weak, nonatomic) IBOutlet UIButton *noticeOfUseBtn;

@property(copy, nonatomic) OnLoginCallBack onLoginSuccessBlock;

/** 改变账号类型 */
- (IBAction)changeAccountType:(UIButton *)sender;
/** 刷新当前界面 */
- (void)refreshOpenAccountInfo:(RealTradeSecuritiesCompany *)obj;
/** 优顾协议 */
- (IBAction)acceptYouGuuAgreement:(UIButton *)sender;
/** 优顾交易协议 */
- (IBAction)showYouGuuTradeAgreement:(UIButton *)sender;



@end
