//
//  MyIncomingViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyIncomingViewController.h"
#import "GameWebViewController.h"
#import "MyIncomingTableViewCell.h"
#import "WeiboToolTip.h"
#import "BindBankCardViewController.h"
#import "MyWalletData.h"
#import "ExchangeDiamondInitData.h"
#import "ExchangeDiamondData.h"
#import "AuthIsBindingPhoneData.h"
#import "MyInformationCenterData.h"
#import "NetLoadingWaitView.h"

@implementation MyIncomingTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MyIncomingTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 61.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MyIncomingTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectionStyle = UITableViewCellSelectionStyleGray;

  MyWalletFlowElement *element = self.dataArray.array[indexPath.row];
  [cell bindDataWith:element];
  [cell.cellBottomLinesView resetViewWidth:WIDTH_OF_SCREEN];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  //先请求单条数据，然后跳转到交易详情
  MyWalletFlowElement *element = self.dataArray.array[indexPath.row];
  //正在处理
  if (element.tradeStatus == 1) {
    [self requestWalletFlow:[NSString
                                stringWithFormat:@"%.2f", element.tradeFee]];
  }
}

#pragma mark 单条提现详情
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}
- (void)requestWalletFlow:(NSString *)tradeFee {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingTableAdapter *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      //根据返回情况决定弹出页面
      [strongSelf bindWalletFlowData:(BankInitDrawData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [BankInitDrawData requestGetWalletFlowData:tradeFee withCallback:callback];
}

- (void)bindWalletFlowData:(BankInitDrawData *)data {
  //弹出详细信息
  BindBankCardViewController *bankVC = [[BindBankCardViewController alloc]
      initWithBankBindedStatus:BankProcessing
                          data:data];
  [AppDelegate pushViewControllerFromRight:bankVC];
}

@end

/*
 *
 */
@implementation MyIncomingListViewController {
  int _start;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _start = 1;
  }
  return self;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MyWalletFlowData requestMyWalletFlowDataWithStart:
                        [self getRequestParamertsWithRefreshType:refreshType]
                                        withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"1";
  //诡异的接口设计，取最新的20条为（0，-20）
  if (refreshType == RefreshTypeLoaderMore) {
    start = [NSString stringWithFormat:@"%d", _start + 1];
  }

  return @{ @"start" : start };
}

- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    if (_start + 1 != [parameters[@"start"] intValue]) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    _start = [parameters[@"start"] intValue];
  }
  self.headerView.hidden = YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyIncomingTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无信息"];
}

@end

/*
 *
 */
@implementation MyIncomingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMyIncomingTable];
  [self createUI];
  [self refreshButtonPressDown];
}

- (void)createMyIncomingTable {
  __weak MyIncomingViewController *weakSelf = self;
  _tableVC = [[MyIncomingListViewController alloc]
      initWithFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN,
                               _clientView.bounds.size.height - 56)];
  _tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  _tableVC.headerView.hidden = YES;
  [self.clientView addSubview:_tableVC.view];
  [self addChildViewController:_tableVC];
}

- (void)createUI {
  //回拉效果
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar resetContentAndFlage:@"我的收入" Mode:TTBM_Mode_Leveltwo];

  //添加帮助按钮
  UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
  helpButton.frame = CGRectMake(WIDTH_OF_SCREEN - 46,CGRectGetMinY(_indicatorView.frame), 45, 45);
  [helpButton addTarget:self
                 action:@selector(buttonClick:)
       forControlEvents:UIControlEventTouchUpInside];
  [helpButton setImage:[UIImage imageNamed:@"helpIcon"]
              forState:UIControlStateNormal];
  helpButton.imageEdgeInsets = UIEdgeInsetsMake(12.25f, 12.25f, 12.25f, 12.25f);
  [helpButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                        forState:UIControlStateHighlighted];
  helpButton.tag = 101;
  [self.view addSubview:helpButton];

  //菊花左移40，让开帮助按钮
  [_indicatorView addOriginX:-46.5f];

  //添加客服热线按钮
  UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
  serviceButton.frame = _indicatorView.frame;
  serviceButton.width = 100;
  [serviceButton addOriginX:-100];
  serviceButton.titleLabel.font = [UIFont systemFontOfSize:15];
  serviceButton.titleLabel.numberOfLines = 0;
  [serviceButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                      forState:UIControlStateNormal];
  [serviceButton
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];

  [serviceButton setTitle:@"客服热线" forState:UIControlStateNormal];
  [serviceButton addTarget:self
                    action:@selector(buttonClick:)
          forControlEvents:UIControlEventTouchUpInside];
  serviceButton.tag = 102;
  [self.view addSubview:serviceButton];

  //灰色分割线
  UIView *separateLine =
      [[UIView alloc] initWithFrame:CGRectMake(0, _tableVC.view.height - 1,
                                               WIDTH_OF_SCREEN, 1)];
  separateLine.backgroundColor = [Globle colorFromHexRGB:@"#EBEBEB"];
  [_clientView addSubview:separateLine];

  //白色0.85透明背景图
  _whiteBackView = [[UIView alloc]
      initWithFrame:CGRectMake(0, _tableVC.view.height, WIDTH_OF_SCREEN, 56)];
  _whiteBackView.backgroundColor =
      [Globle colorFromHexRGB:Color_White alpha:0.85f];
  [_clientView addSubview:_whiteBackView];

  //可提现金
  _cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 125, 20)];
  _cashLabel.font = [UIFont systemFontOfSize:Font_Height_20_0];
  _cashLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _cashLabel.text = @"0.00";
  _cashLabel.textAlignment = NSTextAlignmentCenter;
  [_whiteBackView addSubview:_cashLabel];

  UILabel *titleLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 125, 11)];
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_11_0];
  titleLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  titleLabel.text = @"可提现金";
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [_whiteBackView addSubview:titleLabel];

  //兑钻石
  UIButton *diamondButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [diamondButton setFrame:CGRectMake(WIDTH_OF_SCREEN - 167.5f, 14.5f, 67, 31)];
  [diamondButton setBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [diamondButton setTitle:@"兑钻石" forState:UIControlStateNormal];
  diamondButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  [diamondButton
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [diamondButton addTarget:self
                    action:@selector(buttonClick:)
          forControlEvents:UIControlEventTouchUpInside];
  diamondButton.tag = 103;
  [_whiteBackView addSubview:diamondButton];

  //提现
  _cashButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_cashButton setFrame:CGRectMake(WIDTH_OF_SCREEN - 85.5f, 14.5f, 67, 31)];
  [_cashButton setBackgroundColor:[Globle colorFromHexRGB:Color_yellow_but]];
  [_cashButton setTitle:@"提现" forState:UIControlStateNormal];
  [_cashButton setTitle:@"处理中" forState:UIControlStateDisabled];
  _cashButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  [_cashButton setBackgroundImage:[SimuUtil imageFromColor:@"DE9200"]
                         forState:UIControlStateHighlighted];
  [_cashButton setBackgroundImage:[UIImage imageNamed:@"buttonPressDown"]
                         forState:UIControlStateDisabled];
  [_cashButton addTarget:self
                  action:@selector(buttonClick:)
        forControlEvents:UIControlEventTouchUpInside];
  _cashButton.tag = 104;

  [_whiteBackView addSubview:_cashButton];

  //提现菊花
  _cashIndicatorView =
      [[UIActivityIndicatorView alloc] initWithFrame:_cashButton.bounds];
  _cashIndicatorView.activityIndicatorViewStyle =
      UIActivityIndicatorViewStyleGray;
  _cashIndicatorView.hidden = YES;
  [_cashButton addSubview:_cashIndicatorView];
}

#pragma mark 菊花代理
- (void)refreshButtonPressDown {

  [_indicatorView startAnimating];
  //数据列表
  [_tableVC refreshButtonPressDown];
  //我的钱包
  [self requestMyWalletData];
  //兑换钻石初始化
  [self requestExchangeDiamondInitData];
}

#pragma mark - 按钮点击
- (void)buttonClick:(UIButton *)button {
  switch (button.tag - 100) {
  case 1: {
    [SchollWebViewController startWithTitle:@"收入分成说明"
                                    withUrl:@"http://www.youguu.com/opms/html/"
                                    @"article/32/2014/0925/2608.html"];
  } break;
  case 2: {
    //拨打客服号码
    NSString *number = @"01053599702";
    NSURL *backURL = [NSURL
        URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
    [[UIApplication sharedApplication] openURL:backURL];
  } break;
  case 3: {
    //兑换钻石
    if (_maxValue == 0) {
      [NewShowLabel setMessageContent:@"余额不足1元，无法兑换钻石"];
      return;
    }
    [WeiboToolTip
        showExchangeDiamondViewWithRatio:[NSString
                                             stringWithFormat:@"%d", _ratio]
                                maxValue:[NSString
                                             stringWithFormat:@"%d", _maxValue]
                               Sureblock:^(NSString *diamond) {
                                 [self
                                     requestExchangeDiamondDataDiamond:diamond];
                               }];
  } break;
  case 4: {
    //提现
    if ([_cashLabel.text floatValue] < 100.f) {
      [NewShowLabel setMessageContent:@"余额不足100元，不能提现"];
      return;
    }
    //检测手机是否绑定
    [self cashIndicatorViewStart:YES];
    [self requestAuthIsBindingPhoneData];
  } break;

  default:
    break;
  }
}

#pragma mark - 网络相关
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [_indicatorView stopAnimating];  //停止菊花
  [self cashIndicatorViewStart:NO];
}

#pragma mark 停止菊花
- (void)stopIndicatorView {
  [_indicatorView stopAnimating];
}

#pragma mark 现金菊花指示器
- (void)cashIndicatorViewStart:(BOOL)isStart {
  if (isStart) {
    _cashIndicatorView.hidden = NO;
    [_cashIndicatorView startAnimating];
    _cashButton.titleLabel.layer.opacity = 0.f;
    _cashButton.userInteractionEnabled = NO;
    [NetLoadingWaitView startAnimating];
  } else {
    _cashIndicatorView.hidden = YES;
    [_cashIndicatorView stopAnimating];
    _cashButton.titleLabel.layer.opacity = 1.f;
    _cashButton.userInteractionEnabled = YES;
    [NetLoadingWaitView stopAnimating];
  }
}

#pragma mark 申请提现初始化接口，用于判断是否绑定手机、银行卡等信息
- (void)requestBankInitDrawData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf cashIndicatorViewStart:NO];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //根据返回情况决定弹出页面
      [strongSelf bindBankInitDrawData:(BankInitDrawData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [BankInitDrawData requestBankInitDrawData:callback];
}

- (void)bindBankInitDrawData:(BankInitDrawData *)data {

  NSString *extraStatus = data.extraStatus;
  NSString *status = data.status;

  // 0301 未绑定银行卡，转到绑定银行卡页面
  if ([extraStatus isEqualToString:@"0301"]) {
    [self pushBindBankViewController:BankUnBinded data:data];

    // 0000 请求成功，直接到提现
  } else if ([status isEqualToString:@"0000"]) {
    [self pushBindBankViewController:BankBinded data:data];
  }
}

- (void)pushBindBankViewController:(BankBindedStatus)status
                              data:(BankInitDrawData *)data {
  BindBankCardViewController *viewcontroller =
      [[BindBankCardViewController alloc] initWithBankBindedStatus:status
                                                              data:data];
  viewcontroller.submitSuccessed = ^() {
    [self refreshButtonPressDown];
  };

  [SimuUtil performBlockOnMainThread:^{
    [AppDelegate pushViewControllerFromRight:viewcontroller];
  } withDelaySeconds:.5f];
}

#pragma mark 我的钱包
- (void)requestMyWalletData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
      [strongSelf stopIndicatorView];
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindMyWalletData:(MyWalletData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [MyWalletData requestMyWalletDataWithCallback:callback];
}

- (void)bindMyWalletData:(MyWalletData *)data {
  _cashLabel.text = [NSString stringWithFormat:@"%.2f", data.balance];
  _cashButton.enabled = (data.drawStatus == 1);

  //提现处理中
  if (data.drawStatus == 0) {
    _cashButton.enabled = NO;
  } else if (data.drawStatus == 1) {
    _cashButton.enabled = YES;
  }
}

#pragma mark 钻石兑换初始化，获得兑换比例、最大可兑换金额等
- (void)requestExchangeDiamondInitData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindExchangeDiamondInitData:(ExchangeDiamondInitData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exp) {
    //钻石不足等，在点击兑换按钮时检测并提示
  };

  [ExchangeDiamondInitData requestExchangeDiamondInitData:callback];
}

- (void)bindExchangeDiamondInitData:(ExchangeDiamondInitData *)data {
  _ratio = data.ratio;
  _maxValue = data.maxValue;
}

#pragma mark 钻石兑换
- (void)requestExchangeDiamondDataDiamond:(NSString *)diamond {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:@"兑换成功"];
      //刷新列表和余额
      [strongSelf refreshButtonPressDown];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [ExchangeDiamondData
      requestExchangeDiamondDataWithUserName:[SimuUtil getUserName]
                                    nickName:[SimuUtil getUserNickName]
                                     diamond:diamond
                                         fee:[NSString
                                                 stringWithFormat:
                                                     @"%d", [diamond intValue] *
                                                                _ratio]
                                    callback:callback];
}

#pragma mark 手机绑定
- (void)requestAuthIsBindingPhoneData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyIncomingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MyIncomingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      // 0000 已绑定手机
      [strongSelf requestBankInitDrawData];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exp) {
    MyIncomingViewController *strongSelf = weakSelf;

    if ([obj.status isEqualToString:@"0022"]) {
      [strongSelf cashIndicatorViewStart:NO];
      // 0022未绑定手机
      BindingPhoneViewController *bindingVC = [
          [BindingPhoneViewController alloc]
          initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)];
      bindingVC.titleStr = @"绑定";
      bindingVC.hintString = @"温" @"馨" @"提"
          @"示：绑定手机后，可通过手机号登录和找回密"
          @"码，提" @"高账" @"户安全性。";
      bindingVC.delegagte = strongSelf;
      [AppDelegate pushViewControllerFromRight:bindingVC];
    }
  };

  [AuthIsBindingPhoneData requestAuthIsBindingPhoneData:callback];
}

#pragma mark 根据以前的坑爹代码，真正的绑定手机需要再复写一遍整个流程。。。
- (void)returnVerifyPhoneNumber:(NSString *)phoneNumber
                      withTitle:(NSString *)title {
  if ([title isEqualToString:@"解绑"]) {
    HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
    //解析
    __weak MyIncomingViewController *weakSelf = self;
    callback.onCheckQuitOrStopProgressBar = ^{
      MyIncomingViewController *strongSelf = weakSelf;
      if (strongSelf) {
        return NO;
      } else
        return YES;
    };
    callback.onSuccess = ^(NSObject *obj) {
      MyIncomingViewController *strongSelf = weakSelf;
      if (strongSelf) {
        //绑定手机号成功后，初始化银行卡绑定
        [strongSelf cashIndicatorViewStart:YES];
        [self requestBankInitDrawData];
      }
    };

    [BindingPhone bindingPhoneWithPhoneNumber:phoneNumber
                                 withCallback:callback];
  }
}

@end
