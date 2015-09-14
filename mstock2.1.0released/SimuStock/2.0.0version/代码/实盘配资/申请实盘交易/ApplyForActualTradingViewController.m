//
//  ApplyForActualTradingViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ApplyForActualTradingViewController.h"
#import "ProcessInputData.h"
#import "WeiboToolTip.h"

#import "WFProductContract.h"
#import "WFInquireProductInfo.h"
#import "ConfirmPayView.h"

#import "DayAndMoneyTableViewCell.h"
#import "TotalTableViewCell.h"
#import "SchollWebViewController.h"
///身份验证
///获取用户账户金额
#import "NetLoadingWaitView.h"
#import "ComposeInterfaceUtil.h"
#import "WarningLineView.h"

/** 当前选中按钮中添加的图片与选中项上侧的间距 */
#define Selected_Image_Top_Margin 2
/** 当前选中按钮中添加的图片与选中项右侧的间距 */
#define Selected_Image_Right_Margin 3
/** 当前选中按钮中添加的图片宽高 */
#define Selected_Image_Side 15

/** 借款金额占实盘金额的默认比例 */
#define Default_Loan_Ratio 0.8

/** 实盘金额、费用信息视图之间的距离 */
#define Apply_ActulTrading_View_Margin 8

@interface ApplyForActualTradingViewController () <SimuIndicatorDelegate>

/** 申请配资产品入参 */
@property(strong, nonatomic) WFMakeNewContractParameter *applyForWFProductParameter;
/** 确认支付的视图 */
@property(strong, nonatomic) ConfirmPayView *payView;
/** 警戒线的视图 */
@property(strong, nonatomic) WarningLineView *warningView;

@end

@implementation ApplyForActualTradingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  /** 设置所有子控件 */
  [self setupSubviews];

  self.productInfo = [[WFProductListInfo alloc] init];
  self.days = [@[ @"", @"", @"", @"" ] mutableCopy];
  self.productInfo.amounts = [@[ @"", @"", @"", @"" ] mutableCopy];

  self.selectedAmount = nil;
  self.selectedDay = nil;

  [self CreatTableView];

  self.indicatorView.delegate = self;
  self.agreementButtonState = YES;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //创建支付视图
  [self createConfirmPayView];

  /** 刷新界面获得网络数据 */
  [self refreshButtonPressDown];
}

#pragma mark ——— 设置TableView ———
- (void)CreatTableView {
  _tableView =
      [[UITableView alloc] initWithFrame:self.clientView.bounds style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:_tableView];
  UINib *cellNib =
      [UINib nibWithNibName:NSStringFromClass([DayAndMoneyTableViewCell class]) bundle:nil];
  [_tableView registerNib:cellNib forCellReuseIdentifier:@"DayAndMoneyTableViewCell"];

  cellNib = [UINib nibWithNibName:NSStringFromClass([TotalTableViewCell class]) bundle:nil];
  [_tableView registerNib:cellNib forCellReuseIdentifier:@"TotalTableViewCell"];

  cellNib = [UINib nibWithNibName:NSStringFromClass([WarningLineView class]) bundle:nil];
  [_tableView registerNib:cellNib forCellReuseIdentifier:@"WarningLineView"];

  _tableView.showsVerticalScrollIndicator = NO;
  //  _tableView.bounces = NO;
}
/** 创建确认支付的视图 */
- (void)createConfirmPayView {
  self.payView = [ConfirmPayView createdConfirmPayInfoView];
  /** 设置frame  */
  self.payView.top = _clientView.height - 56;
  self.payView.left = 0;
  self.payView.width = WIDTH_OF_SCREEN;

  self.payView.payMoneyLabel.text = @"合计支付 ：";
  [self.clientView addSubview:self.payView];
  [self.clientView bringSubviewToFront:self.payView];
}
#pragma mark
#pragma mark----------UItableViewdelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}
/** 默认返回一个section */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = (self.productInfo.amounts.count + 3) / 4;
  NSInteger indexDay = (self.days.count + 3) / 4;
  if (index == 0) {
    index = 1;
  }
  if (indexDay == 0) {
    indexDay = 1;
  }
  if (indexPath.section == 0) {
    return 26 + 41 * index + 1;
  } else if (indexPath.section == 1) {
    return 31;
  } else if (indexPath.section == 2) {
    return 26 + 41 * indexDay + 1;
  } else if (indexPath.section == 3) {
    return 251.0f;
  }
  return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 2) {
    return 10.f;
  } else if (section == 3) {
    return 28;
  }
  return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] init];
  if (section == 2) {
    headerView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 10);
    headerView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    ;
  } else if (section == 3) {
    headerView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 28);
    headerView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    ;
  }
  return headerView;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell_Id = @"DayAndMoneyTableViewCell";
  Cell_Id = [self GetTableViewCellId:indexPath];

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Id];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  if (indexPath.section == 0) {
    amountCell = (DayAndMoneyTableViewCell *)cell;
  } else if (indexPath.section == 2) {
    dayCell = (DayAndMoneyTableViewCell *)cell;
  }

  DayAndMoneyViewButtonClickBlock block = ^(NSInteger selectedIndex, NSInteger section) {
    NSArray *cellArray = [self.tableView visibleCells];
    if (cellArray.count < 3) {
      return;
    }

    if (section == 0) {
      self.selectedAmount = self.productInfo.amounts[selectedIndex];
      self.days = self.productInfo.amountToDays[self.selectedAmount];

      if (self.selectedDay && [self.days containsObject:self.selectedDay]) {
        NSUInteger dayIndex = [self.days indexOfObject:self.selectedDay];
        [dayCell.selectedButtons
            setupCheckmarkImage:(UIButton *)(dayCell.selectedButtons.btnArray[dayIndex])];
      } else {
        self.selectedDay = nil;
      }

    } else {
      self.selectedDay = self.days[selectedIndex];
    }

    [self refreshWFProductInfo];
    [self.tableView reloadData];
  };

  if (indexPath.section == 0) {
    DayAndMoneyTableViewCell *tableViewcell = (DayAndMoneyTableViewCell *)cell;
    [tableViewcell bindMoney:self.productInfo];
    NSUInteger index = [self.productInfo.amounts indexOfObject:self.selectedAmount];
    tableViewcell.selectedButtons.block = block;
    if (index == NSNotFound) {
      [tableViewcell.selectedButtons clearAllChecked];
    } else {
      [tableViewcell.selectedButtons
          setupCheckmarkImage2:tableViewcell.selectedButtons.btnArray[index]];
    }
  } else if (indexPath.section == 2) {
    DayAndMoneyTableViewCell *tableViewcell = (DayAndMoneyTableViewCell *)cell;
    [tableViewcell bindDays:self.days];
    tableViewcell.selectedButtons.block = block;
    if (self.selectedDay == nil) {
      [tableViewcell.selectedButtons clearAllChecked];
    } else {
      NSArray *days = self.productInfo.amountToDays[self.selectedAmount];
      NSUInteger index = [days indexOfObject:self.selectedDay];
      if (index == NSNotFound) {
        [tableViewcell.selectedButtons clearAllChecked];
      } else {
        [tableViewcell.selectedButtons
            setupCheckmarkImage2:tableViewcell.selectedButtons.btnArray[index]];
      }
    }
  } else if (indexPath.section == 3) {
    TotalTableViewCell *tableViewCell = (TotalTableViewCell *)cell;
    ///冻结保证金
    [tableViewCell setupTradingInfoWithLabelStyle:tableViewCell.freezeDepositLabel
                                WithTradingNumber:self.frozenDeposit];
    ///管理费
    [tableViewCell setupTradingInfoWithLabelStyle:tableViewCell.managementFeeLable
                                WithTradingNumber:self.accountManagementFees];

    tableViewCell.block = ^(BOOL btnState) {
      self.agreementButtonState = btnState;
    };
    [self.payView.confirmPayButton addTarget:self
                                      action:@selector(clickOnPayBtn:)
                            forControlEvents:UIControlEventTouchUpInside];

  } else if (indexPath.section == 1) {
    self.warningView = (WarningLineView *)cell;
  }
  [cell setNeedsLayout];
  return cell;
}

- (NSString *)GetTableViewCellId:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 || indexPath.section == 2) {
    return @"DayAndMoneyTableViewCell";
  } else if (indexPath.section == 3) {
    return @"TotalTableViewCell";
  } else if (indexPath.section == 1) {
    return @"WarningLineView";
  }

  return nil;
}

#pragma mark ——— 设置子控件相关属性 ———
/** 设置所有子控件 */
- (void)setupSubviews {
  [self.topToolBar resetContentAndFlage:@"申请配资" Mode:TTBM_Mode_Sideslip];

  /** 设置顶部右侧“说明”按钮 */
  [self setupInstructionBtn];
}

/** 设置顶部右侧“说明”按钮 */
- (void)setupInstructionBtn {
  self.instructionBtn.frame =
      CGRectMake(CGRectGetMinX(_indicatorView.frame) - 45, CGRectGetMinY(_indicatorView.frame), 45,
                 CGRectGetHeight(_indicatorView.bounds));
  [self.instructionBtn setTitle:@"攻略" forState:UIControlStateNormal];
  self.instructionBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [self.instructionBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                            forState:UIControlStateNormal];
  [self.instructionBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                                 forState:UIControlStateHighlighted];
  [self.instructionBtn addTarget:self
                          action:@selector(clickOnInstructionBtn:)
                forControlEvents:UIControlEventTouchUpInside];
  [self.topToolBar addSubview:self.instructionBtn];
}
#pragma mark ——— 网络访问相关 ———
/** 查询配资产品网络接口 */
- (void)inquireProductInfo {
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }

  __weak ApplyForActualTradingViewController *weakSelf = self;
  HttpRequestCallBack *callback = [HttpRequestCallBack initWithOwner:self
                                                       cleanCallback:^{
                                                         [weakSelf.indicatorView stopAnimating];
                                                       }];

  //解析
  callback.onSuccess = ^(NSObject *obj) {
    ApplyForActualTradingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      [strongSelf inquireProductInfoOnSuccessWithResult:obj];
    }
  };
  [WFInquireProductInfo inquireWFProductInfoWithCallback:callback];
}

#pragma mark ——— 网络访问结果处理 ———
#pragma mark ——— 查询配资产品网络请求结果处理 ———
/** 查询配资产品网络请求成功处理函数 */
- (void)inquireProductInfoOnSuccessWithResult:(NSObject *)result {
  /// 数据模型赋值
  self.productInfo = (WFProductListInfo *)result;
  //设置优顾账户余额
  if (!self.productInfo.ygBalance || [self.productInfo.ygBalance doubleValue] >= 0) {
    self.payView.accountBalanceLabel.text =
        [[ProcessInputData convertMoneyString:self.productInfo.ygBalance]
            stringByAppendingString:@"元"];
  }

  [self refreshWFProductInfo];

  if (self.productInfo.defaultAmount && self.productInfo.amounts &&
      ![self.productInfo.defaultAmount isEqualToString:@"0"]) {
    self.selectedAmount = [self.productInfo.defaultAmount stringByAppendingString:@"00"];
    NSInteger index = [self.productInfo.amounts indexOfObject:self.selectedAmount];
    [amountCell.selectedButtons
        setupCheckmarkImage:(UIButton *)(amountCell.selectedButtons.btnArray[index])];
    self.days = self.productInfo.amountToDays[self.selectedAmount];

  } else {
    self.selectedAmount = nil;
    self.days = self.productInfo.days;
  }
  if (self.productInfo.defaultDay && self.days) {
    self.selectedDay = self.productInfo.defaultDay;
    if ([self.days containsObject:self.productInfo.defaultDay]) {
      NSInteger index = [self.productInfo.days indexOfObject:self.selectedDay];
      [dayCell.selectedButtons
          setupCheckmarkImage:(UIButton *)(dayCell.selectedButtons.btnArray[index])];
    } else {
      self.selectedDay = nil;
    }
  }
  [self.tableView reloadData];
}

/** 单击“立即申请”按钮响应函数 */
- (void)clickOnPayBtn:(UIButton *)clickedBtn {
  if (!self.productInfo) {
    [NewShowLabel setMessageContent:@"无数据，请刷新"];
    return;
  } else if (self.selectedAmount == nil) {
    [NewShowLabel setMessageContent:@"请选择操盘金额"];
    return;
  } else if (self.selectedDay == nil) {
    [NewShowLabel setMessageContent:@"请选择操盘天数"];
    return;
  } else if (self.agreementButtonState == NO) {
    [NewShowLabel setMessageContent:@"请" @"勾" @"选"
                                                  @"【已阅读并同意优顾用户配资协议】"];
    return;
  }
  if ([_indicatorView isAnimating]) {
    return;
  }

  [self.indicatorView startAnimating];
  [NetLoadingWaitView startAnimating];
  ///网络判断
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }

  ///检查账户余额：先检查资金池，然后查询账号余额
  __weak ApplyForActualTradingViewController *weakSelf = self;
  [WFPayUtil checkWFBalanceWithOwner:self
      withCleanCallBack:^{
        [weakSelf stopLoading];
      }
      andSurePayCallBack:^{
        /// 验证用户是否实名认证
        [WFPayUtil requestPayWithOwner:self
            withCleanCallBack:^{
              [weakSelf stopLoading];
            }
            productInfo:weakSelf.applyForWFProductParameter
            onWFContractReadyCallback:^(WFMakeNewContractResult *result) {
              [weakSelf applyForWFProductOnSuccessWithResult:result];
            }];
      }
      andTotalAmountCent:self.selectedOneProductInfo.totalAmount];
}

#pragma mark ——— 申请配资网络请求结果处理 ———
/** 申请配资成功处理函数 */
- (void)applyForWFProductOnSuccessWithResult:(NSObject *)obj {
  WFMakeNewContractResult *result = (WFMakeNewContractResult *)obj;
  if ([result.status isEqualToString:@"0000"]) {
    [NewShowLabel setMessageContent:@"配" @"资" @"申" @"请"
                                                         @"成功，请耐心等待工作人员审核"];
    if (self.applySucess && self.selectedOneProductInfo) {
      self.applySucess(self.selectedOneProductInfo);
    }

    ///配资成功，通知首页配资账户信息，刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWithWFContracts"
                                                        object:nil];
    [self leftButtonPress];
  }
}

#pragma mark ——— 联网指示器代理 ———
/** 点击刷新按钮响应函数 */
- (void)refreshButtonPressDown {
  [self inquireProductInfo];
}

#pragma mark ——— 刷新配资信息 ———
/** 刷新配资产品申请信息及页面费用信息 */
- (void)refreshWFProductInfo {

  NSArray *cellArray = [self.tableView visibleCells];

  if (self.selectedAmount) {
    self.warningView.warningNumber.text = [NSString
        stringWithFormat:@"≤%d",
                         (int)ceilf(
                             [self.productInfo.warnlineDic[self.selectedAmount] doubleValue] /
                             100)];

    self.warningView.flatNumber.text = [NSString
        stringWithFormat:@"≤%d",
                         (int)ceilf(
                             [self.productInfo.flatlineDic[self.selectedAmount] doubleValue] /
                             100)];
  }

  if (self.selectedAmount == nil || self.selectedDay == nil) {
    dayCell.timeLabel.text = @"";
    if (cellArray.count > 2) {
      self.frozenDeposit = @"";
      self.accountManagementFees = @"";
      self.totalAmount = @"";
    }
    return;
  }

  /// 获得实盘金额（单位：分）
  NSString *moneyAmountCent = self.selectedAmount;

  /// 得到借款时长
  NSString *prodTerm = self.selectedDay;

  /// 获得借款产品信息
  self.selectedOneProductInfo =
      [self.productInfo getOneProductInfoWithAmount:moneyAmountCent andDay:prodTerm];

  NSString *startDay = [ProcessInputData convertDateString:self.selectedOneProductInfo.startDay];
  NSString *endDay = [ProcessInputData convertDateString:self.selectedOneProductInfo.endDay];
  /// 设置配资起始时间及结束时间
  self.borrowingDate =
      [ProcessInputData convertDateStringToSimpleBWithStartDay:startDay andEndDay:endDay];

  /// 获得冻结保证金金额(单位：分)
  NSString *freezeDepositCent = self.selectedOneProductInfo.cashAmount;
  /// 获得冻结保证金金额（单位：元）
  self.frozenDeposit = [ProcessInputData convertMoneyString:freezeDepositCent];

  /// 获得管理费（单位：分）
  NSString *managementFeeCent = self.selectedOneProductInfo.mgrAmount;
  // 获得管理费（单位：元）
  self.accountManagementFees = [ProcessInputData convertMoneyString:managementFeeCent];

  /// 获得合计支付金额（单位：分）
  NSString *totalAmountCent = self.selectedOneProductInfo.totalAmount;
  /// 获得合计支付金额（单位：元）
  self.totalAmount = [ProcessInputData convertMoneyString:totalAmountCent];

  /// 获得借款金额（单位：分）
  NSString *loanAmountCent = [NSString
      stringWithFormat:@"%ld", (long)([self.selectedOneProductInfo.financingPrice integerValue] -
                                      [freezeDepositCent integerValue])];

  /// 设置配资申请参数
  self.applyForWFProductParameter.cashAmount = freezeDepositCent;
  self.applyForWFProductParameter.loanAmount = loanAmountCent;
  self.applyForWFProductParameter.prodId = self.selectedOneProductInfo.prodId;
  self.applyForWFProductParameter.prodTerm = prodTerm;
  self.applyForWFProductParameter.totalAmount = self.selectedOneProductInfo.totalAmount;
  self.applyForWFProductParameter.mgrAmount = managementFeeCent;

  self.payView.payMoneyNumberLabel.text =
      ((self.totalAmount == nil || [self.totalAmount isEqualToString:@""])
           ? @""
           : [self.totalAmount stringByAppendingString:@"元"]);
  dayCell.timeLabel.text = self.borrowingDate;
}

- (void)stopLoading {
  [self.indicatorView stopAnimating];
  [NetLoadingWaitView stopAnimating];
}

/** 单击导航栏“说明”按钮响应函数 */
- (void)clickOnInstructionBtn:(UIButton *)clickedBtn {
  [SchollWebViewController
      startWithTitle:@"配资攻略"
             withUrl:@"http://m.youguu.com/mobile/wap_financing/instructions/"];
}

#pragma mark ——— 子控件懒加载 ———
/** 懒加载顶部右侧“说明”按钮 */
- (UIButton *)instructionBtn {
  if (_instructionBtn == nil) {
    _instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _instructionBtn;
}

/** 懒加载申请配资产品入参 */
- (WFMakeNewContractParameter *)applyForWFProductParameter {
  if (_applyForWFProductParameter == nil) {
    _applyForWFProductParameter = [[WFMakeNewContractParameter alloc] init];
  }
  return _applyForWFProductParameter;
}

@end
