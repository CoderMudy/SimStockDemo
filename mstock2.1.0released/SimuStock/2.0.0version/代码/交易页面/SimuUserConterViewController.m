

//
//  simuUserConterViewController.m
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuUserConterViewController.h"
#import "GetUserACLData.h"
#import "NetShoppingMallBaseViewController.h"
#import "simuCancellationViewController.h"
#import "FoundMasterPurchViewConroller.h"
#import "PosttionTableViewCell.h"
#import "simuUserConterListWrapper.h"
#import "CapitalFirstViewCell.h"
#import "simuRealTradeVC.h"
#import "MyChestsViewController.h"
///基本数据类型
#import "CacheUtil.h"

///模拟账户资金重置

///网络请求库

/// log日志
#import "event_view_log.h"
#import "FishanimationViewCell.h"
#import "SimuTopTimeBarView.h"
#import "CapitalDetailViewCell.h"
//续约按钮点击界面
#import "ActulTradingRenewContractViewController.h"
///单笔配资的实盘详情页面
#import "InfomationDisplayViewController.h"
#import "SimuConfigConst.h"

@implementation SimuUserConterViewController {
  OnWFShowValueChangedNotification *onWFShowValueChangedNotification;
}

- (id)initWithMainViewController:(SimuMainViewController *)controller {
  if (self = [super init]) {
    _mainVC = controller;
    positionList = [[DataArray alloc] init];
    self.wfContractInfoArray = [[DataArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  isPeizi = [SimuConfigConst isShowWithFund];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    isvc_stateBarHeight = 20;
  } else {
    isvc_stateBarHeight = 0;
  }
  _wfcurrentlist = [[WFCurrentContractList alloc] init];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common]; //
  scvc_topTimeBarView = nil;
  scvc_selectedRow.row = -1;
  scvc_selectedRow.section = -1;
  scvc_notselHeight = 90;
  scvc_pagedata = [[UserAccountPageData alloc] init];

  //创建上方时间显示控件
  [self creatTopTimeBarView];

  _Main_tableView.delegate = self;
  _Main_tableView.dataSource = self;
  _Main_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _Main_tableView.backgroundColor = [UIColor whiteColor];
  _Main_tableView.showsVerticalScrollIndicator = NO;

  //通知服务器注册
  //主页面
  [self registNotifationServerse];

  onWFShowValueChangedNotification = [[OnWFShowValueChangedNotification alloc] init];
  __weak SimuUserConterViewController *weakSelf = self;
  onWFShowValueChangedNotification.onWFShowValueChanged = ^{
    [weakSelf resetWithFundView];
  };

  /// 网络请求，判断是否要显示配资
  [SimuConfigConst requestServerOnlineConfig];
}

- (void)enableScrollsToTop:(BOOL)scrollsToTop {
  _Main_tableView.scrollsToTop = scrollsToTop;
}

- (void)resetWithFundView {
  isPeizi = [SimuConfigConst isShowWithFund];
  [self.Main_tableView reloadData];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark
#pragma mark 对外接口

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  ///整个界面三个接口调用刷新
  [self refreshButtonPressDown];

  NSLog(@"0 will appear");
  [_capitalfirstviewCell.timeUtil resumeTimer];
  [scvc_topTimeBarView timeVisible:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"0 will viewWillDisappear");
  [scvc_topTimeBarView timeVisible:NO];
  [_capitalfirstviewCell.timeUtil stopTimer];
}

//重新刷新页面数据
- (void)refreshpagedata {
  [self refreshButtonPressDown];
}

#pragma mark
#pragma mark 通知注册
- (void)registNotifationServerse {
  //注册登陆成功监听LogoutSuccess
  __weak SimuUserConterViewController *weakSelf = self;
  _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  _loginLogoutNotification.onLoginLogout = ^{
    [weakSelf onLoginLogoutEvent];
  };

  ///申请配资成功后，消息中心回调，刷新配资账户的信息
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(getWFContracts)
                                               name:@"RefreshWithWFContracts"
                                             object:nil];
}

//登录成功通知
- (void)onLoginLogoutEvent {

  [self.wfContractInfoArray reset];
  _wfcurrentlist = nil;
  //清除持仓缓存
  [positionList reset];

  if ([SimuUtil isLogined]) {
    if (self.wftableviewHeaderView) {
      [self.wftableviewHeaderView indicatorViewstartAnimating];
    }
    [self getWFContracts];
    ///优顾模拟账户
    [self performSelector:@selector(getIniteDataFormNet) withObject:nil afterDelay:0.1];
    //    //获取用户权限列表（聊股吧）
    [GetUserACLData sharedUserACLData];
    [self reloadTable];
  } else {
    [self reloadTable];
  }
}

//非法登录
- (void)invalidLogon {
  if (![SimuUtil isLogined]) {
    return;
  }
  [SimuUser onLoginOut];
}

#pragma mark
#pragma mark animationViewDelegate
- (void)logInMethod {
  [_mainVC simuUserLogInMethod];
}

#pragma mark
#pragma mark-------创建控件------------------
//创上方闹钟和时间显示控件
- (void)creatTopTimeBarView {
  if (scvc_topTimeBarView == nil) {
    scvc_topTimeBarView = [[[NSBundle mainBundle] loadNibNamed:@"SimuTopTimeBarView"
                                                         owner:self
                                                       options:nil] lastObject];
    [scvc_topTimeBarView startUpdateTime];
    [self.view addSubview:scvc_topTimeBarView];
  }
}

#pragma mark

#pragma mark
#pragma mark SimuleftButtonDelegate
//加入资金和帐户充值按钮点击
- (void)ButtonPressUp:(NSInteger)index {
  if (index == 100) {
    //加入资金
    [AppDelegate pushViewControllerFromRight:[[FoundMasterPurchViewConroller alloc] init]];
  } else if (index == 101) {
    //重置帐户
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"账户重置"
                                                    message:@"您确定要重置当前账户吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 10000;
    [alert show];
  }
}
#pragma mark
#pragma mark UIAlertViewDelegate 协议回调函数
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView && alertView.tag == 10000) {
    //账户重置
    if (buttonIndex == 1) {
      [self getUserAllProducteWithDiamondsFormNet];
    }
  } else if (alertView.tag == 9999) {
    if (buttonIndex == 0) {
      AccountsViewController *vc = [[AccountsViewController alloc] initWithPageTitle:@"交易登录"
                                                                     withCompanyName:nil
                                                                     onLoginCallBack:nil];
      [AppDelegate pushViewControllerFromRight:vc];
    }
  }
}

#pragma mark
#pragma mark 打开商城函数
//打开商城，购买重置卡
- (void)openMailView {
  NetShoppingMallBaseViewController *iSimuStockViewController =
      [[NetShoppingMallBaseViewController alloc] initWithPageType:Mall_Buy_Props];

  [AppDelegate pushViewControllerFromRight:iSimuStockViewController];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"0018"];
}

#pragma mark
#pragma mark 展示页面

#pragma mark SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  ///有网
  [scvc_topTimeBarView forceRefresh];
  if ([SimuUtil isLogined]) {
    ///优顾实盘配资数据
    [self getWFContracts];
    ///优顾模拟账户
    [self getIniteDataFormNet];
  }
}
#pragma mark
#pragma mark UITableViewDataSource
//表格组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  ///根据网络请求，是否要开启配资界面
  if (isPeizi) {
    return 3;
  }
  return 2;
}
//各个组行个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else if (section == 1 && isPeizi) {
    return 2 + _wfContractInfoArray.array.count;
  } else {
    return 2 + positionList.array.count;
  }
}
//头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0.01f;
  }
  return 26.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return nil;
  } else if (section == 1 && isPeizi) {
    if (!_wftableviewHeaderView) {
      _wftableviewHeaderView =
          [TableViewHeaderView getTableViewHeaderView:@"优顾配资交易"
                                        andsmallTitle:@"我出钱，您炒股，收益全归您"
                                           andRefresh:YES];
      ///跑马灯刷新
      __weak SimuUserConterViewController *weakSelf = self;
      _wftableviewHeaderView.block = ^{
        if (weakSelf) {
          [weakSelf.capitalfirstviewCell refreshMarqueeData];
          if ([SimuUtil isLogined]) {
            [weakSelf getWFContracts];
          }
        }
      };
    }
    return _wftableviewHeaderView;
  } else {
    if (!_simutableviewHeaderView) {
      _simutableviewHeaderView = [TableViewHeaderView getTableViewHeaderView:@"优顾模拟账户"
                                                               andsmallTitle:nil
                                                                  andRefresh:NO];
      ///模拟账户
      __weak SimuUserConterViewController *weakSelf = self;
      _simutableviewHeaderView.block = ^{
        if (weakSelf) {
          [weakSelf getIniteDataFormNet];
        }
      };
    }
    if ([SimuUtil isLogined]) {
      _simutableviewHeaderView.showRefreshButton = YES;
    } else {
      _simutableviewHeaderView.showRefreshButton = NO;
    }
    ssvc_positionLable.hidden = ![SimuUtil isLogined];
    if ([SimuUtil isLogined]) {
      if (!ssvc_positionLable) {
        ssvc_positionLable =
            [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 120 - 44, 0, 120, 53.0 / 2)];
        ssvc_positionLable.backgroundColor = [UIColor clearColor];
        ssvc_positionLable.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];

        ssvc_positionLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
        ssvc_positionLable.textAlignment = NSTextAlignmentRight;
      }
      //防止显示null
      if (!scvc_pagedata || !scvc_pagedata.positionRate) {
        ssvc_positionLable.text = @"0.00%%仓";
      } else {
        ssvc_positionLable.text = [NSString stringWithFormat:@"%@仓", scvc_pagedata.positionRate];
      }
      [_simutableviewHeaderView addSubview:ssvc_positionLable];
    }
    return _simutableviewHeaderView;
  }
}

//各个组里行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 60.f;
  } else if (indexPath.section == 1 && isPeizi) {
    ///有配资时配资cell的高度
    if (indexPath.row == 0) {
      if ([SimuUtil isLogined]) { ///登录成功后，用户的账户信息cell的高度
        return _wfcurrentlist.hasWFAccount ? 0.f : 190.f;
      } else { ////有配资，当用户还没开通配资的跑马灯cell 的高度
        return 190.0f;
      }
    } else if (indexPath.row == 1) { //配资的单笔cell的高度
      if ([SimuUtil isLogined]) {
        return _wfcurrentlist.hasWFAccount ? 158.f : 0.f;
      } else {
        return 0.f;
      }
    } else {
      return 97.0f;
    }
  } else {
    ///模拟账户各cell的高度
    if (indexPath.row == 0) {
      return [SimuUtil isLogined] ? 0.f : 145.0f + !isPeizi * (self.view.height - 145 - 60 - 26 - 48);
    } else if (indexPath.row == 1) {
      return [SimuUtil isLogined] ? 145.0f : 0.f;
    } else {
      if (indexPath.row == scvc_selectedRow.row) {
        //当前选中行高度
        return PositionHeight;
      } else {
        //非当前选中行高度
        return scvc_notselHeight;
      }
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimuScrollButViewCell"];
    if (!cell) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"SimuScrollButViewCell"
                                            owner:self
                                          options:nil] lastObject];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
  } else if (indexPath.section == 1 && isPeizi) {
    if (indexPath.row == 0) { ///跑马灯
      if (!_capitalfirstviewCell) {
        _capitalfirstviewCell = [[[NSBundle mainBundle] loadNibNamed:@"CapitalFirstViewCell"
                                                               owner:self
                                                             options:nil] lastObject];
        _capitalfirstviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        ///跑马灯 网络请求结束以后，回调
        __weak SimuUserConterViewController *weakSelf = self;
        _capitalfirstviewCell.block = ^{
          if (weakSelf) {
            [weakSelf.wftableviewHeaderView indicatorViewStopAnimating];
          }
        };
      }
      _capitalfirstviewCell.isLogin = [SimuUtil isLogined];
      return _capitalfirstviewCell;
    } else if (indexPath.row == 1) { ///用户配资账户
      if (!_capitaldetailviewCell) {
        _capitaldetailviewCell = [[[NSBundle mainBundle] loadNibNamed:@"CapitalDetailViewCell"
                                                                owner:self
                                                              options:nil] lastObject];
        _capitaldetailviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      [_capitaldetailviewCell giveWithUIAssignment:_wfcurrentlist];
      return _capitaldetailviewCell;
    } else {
      UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SingleCapitaldetailsCell"
                                                             owner:self
                                                           options:nil] lastObject];
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      ((SingleCapitaldetailsCell *)cell).delegate = self;

      if (self.wfContractInfoArray.array.count > 0) {
        WFContractInfo *wfInfo = [self.wfContractInfoArray.array objectAtIndex:indexPath.row - 2];
        if (wfInfo.verifyStatus == 1) {
          cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [(SingleCapitaldetailsCell *)cell giveWithCellUIData:wfInfo];
        ((SingleCapitaldetailsCell *)cell).RenewalBtn.tag = indexPath.row - 2;
      }
      return cell;
    }
  } else {
    ///模拟账户各cell的高度
    if (indexPath.row == 0) { ///喷水鱼
      if (!_fishanimationviewCell) {
        _fishanimationviewCell = [[[NSBundle mainBundle] loadNibNamed:@"FishanimationViewCell"
                                                                owner:self
                                                              options:nil] lastObject];
        _fishanimationviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      _fishanimationviewCell.contentView.backgroundColor = [UIColor clearColor];
      return _fishanimationviewCell;
    } else if (indexPath.row == 1) {
      if (!_simulationviewCell) {
        _simulationviewCell = [[[NSBundle mainBundle] loadNibNamed:@"SimulationViewCell"
                                                             owner:self
                                                           options:nil] lastObject];
        _simulationviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _simulationviewCell.delegate = self;
      }

      if (scvc_pagedata) {
        [_simulationviewCell resetData:scvc_pagedata];
      }
      return _simulationviewCell;
    } else { //模拟持仓股票
      UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PosttionTableViewCell"
                                                             owner:self
                                                           options:nil] lastObject];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;

      //模拟持仓股票
      PositionInfoView *infoView = [[PositionInfoView alloc] initWithUserId:[SimuUtil getUserID]
                                                                withMatchId:@"1"
                                                                  withFrame:cell.bounds];
      [infoView createButton];
      ((PosttionTableViewCell *)cell).positionView = infoView;
      [cell addSubview:infoView];
      //重新设置下cell.positionView的Uid，更新新登录的用户id，否则导致交易明细显示为空
      ((PosttionTableViewCell *)cell).positionView.uid = [SimuUtil getUserID];
      [self setPositionItem:(PosttionTableViewCell *)cell IndexPath:indexPath];
      return cell;
    }
  }
}
/// SingleCapitaldetailsCell 代理方法
- (void)reneWalbtnClick:(NSInteger)index {
  if (self.wfcurrentlist) {
    if (self.wfContractInfoArray.array.count > index) {
      WFContractInfo *wfinfo = [self.wfContractInfoArray.array objectAtIndex:index];
      ActulTradingRenewContractViewController *actulTradingRenew =
          [[ActulTradingRenewContractViewController alloc] initWithContractNo:wfinfo.contractNo
                                                                    andProdId:wfinfo.operatorNo];
      [AppDelegate pushViewControllerFromRight:actulTradingRenew];
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if ((indexPath.section == 2 || (indexPath.section == 1 && !isPeizi)) && indexPath.row > 1) {
    PosttionTableViewCell *cell = (PosttionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    PositionInfoView *view = cell.positionView;
    if (indexPath.section == scvc_selectedRow.section && indexPath.row == scvc_selectedRow.row) {
      [tableView beginUpdates];
      if (view)
        [view presentForPosition:scvc_notselHeight];

      scvc_selectedRow.row = -1;
      scvc_selectedRow.section = -1;
      [tableView endUpdates];
    } else {
      [tableView beginUpdates];
      if (scvc_selectedRow.row != -1 && scvc_selectedRow.section != -1) {
        PosttionTableViewCell *cell = (PosttionTableViewCell *)
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:scvc_selectedRow.row
                                                                inSection:scvc_selectedRow.section]];
        PositionInfoView *presentview = cell.positionView;
        if (presentview) {
          [presentview presentForPosition:scvc_notselHeight]; // present
        }
      }
      scvc_selectedRow.row = indexPath.row;
      scvc_selectedRow.section = indexPath.section;
      if (view) {

        [view present:PositionHeight];
      }
      [tableView endUpdates];
    }
  } else if (isPeizi && indexPath.section == 1 && indexPath.row > 1) {
    WFContractInfo *wfInfo = [self.wfContractInfoArray.array objectAtIndex:indexPath.row - 2];
    if (wfInfo.verifyStatus == 1) {
      InfomationDisplayViewController *infomationVC =
          [[InfomationDisplayViewController alloc] initWithHsUserId:wfInfo.hsUserId
                                                withHomsFundAccount:wfInfo.homsFundAccount
                                                  withHomsCombineld:wfInfo.homsCombineId
                                                     withOperatorNo:wfInfo.operatorNo
                                                      withContracNo:wfInfo.contractNo];
      [AppDelegate pushViewControllerFromRight:infomationVC];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                     withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)setPositionItem:(PosttionTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
  cell.positionView.triangleImage.hidden = NO;

  CGRect rect;
  if (indexPath.section == scvc_selectedRow.section && indexPath.row == scvc_selectedRow.row) {
    rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, PositionHeight);
    cell.positionView.triangleImage.hidden = YES;
  } else {
    rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, scvc_notselHeight);
  }
  NSString *user_id = [SimuUtil getUserID];
  if (user_id) {
    [cell.positionView setPosition:positionList.array[indexPath.row - 2]
                         withFrame:rect
                     withTraceFlag:0];
  }
}

#pragma mark 网络访问函数
//取得初始化需要的数据
- (void)getIniteDataFormNet {
  [self getMyCounterInfo];
}
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

- (void)stopLoading {
  if (self.endRefreshCallBack) {
    self.endRefreshCallBack();
  }
}

- (void)beginLoading {
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
}

- (void)reloadTable {
  if (positionList.dataBinded && positionList.array.count == 0 && !isPeizi) {
    if (_littleCattleView == nil) {
      _littleCattleView =
          [[LittleCattleView alloc] initWithFrame:self.view.bounds information:@"暂无持仓"];
    }
    [_littleCattleView isCry:NO];
    CGFloat height = _Main_tableView.height - _simulationviewCell.bottom;
    [_littleCattleView resetFrame:CGRectMake(0, 0, _littleCattleView.width, height > 200 ? height : 200)];
    _Main_tableView.tableFooterView = _littleCattleView;
  } else {
    _Main_tableView.tableFooterView = nil;
  }
  [_Main_tableView reloadData];
}

//获得帐户信息
- (void)getMyCounterInfo {
  if (!positionList.dataBinded) {
    UserAccountPageData *currentPositionInfo = [CacheUtil loadUserAccountPositions];
    if (currentPositionInfo) {
      [self bindUserAccountData:currentPositionInfo saveToCache:NO];
    }
  }

  if (![SimuUtil isExistNetwork]) {
    [self.simutableviewHeaderView indicatorViewStopAnimating];
    [self setNoNetwork];
    return;
  }
  if (![SimuUtil isLogined]) {
    [self.simutableviewHeaderView indicatorViewStopAnimating];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuUserConterViewController *weakSelf = self;

  callback.onCheckQuitOrStopProgressBar = ^{
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.simutableviewHeaderView indicatorViewStopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUserAccountData:(UserAccountPageData *)obj saveToCache:YES];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  [UserAccountPageData requestAccountDataWithMatchId:@"1" withCallback:callback];
}

- (void)bindUserAccountData:(UserAccountPageData *)data saveToCache:(BOOL)save {
  if (save) {
    [CacheUtil saveUserAccountPositions:data];
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:AccountTotalProfitNotification
                                                      object:nil
                                                    userInfo:@{
                                                      @"totalProfit" : data.totalProfit
                                                    }];

  //帐户信息 (新接口)
  scvc_pagedata.profitrate = data.profitrate;
  scvc_pagedata.totalAssets = data.totalAssets;
  scvc_pagedata.fundBalance = data.fundBalance;
  scvc_pagedata.positionValue = data.positionValue;
  scvc_pagedata.floatProfit = data.floatProfit;
  scvc_pagedata.positionRate = data.positionRate;

  positionList.dataBinded = YES;
  [positionList.array removeAllObjects];
  [positionList.array addObjectsFromArray:data.postionArray];

  [self reloadTable];
}

#pragma mark----------获取优顾实盘配资数据接口
- (void)getWFContracts {
  if (isPeizi) {
    ///优顾实盘配资数据
    [self getCapitalPassData];
  }
}

- (void)getCapitalPassData {
  if (!_wfContractInfoArray.dataBinded) {
    WFCurrentContractList *cache = [CacheUtil loadWFCurrentContractList];
    if (cache) {
      [self bindWFCurrentContractList:cache saveCache:NO];
    }
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self.wftableviewHeaderView indicatorViewStopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuUserConterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.wftableviewHeaderView indicatorViewStopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFCurrentContractList *wfList = (WFCurrentContractList *)obj;
      [strongSelf bindWFCurrentContractList:wfList saveCache:YES];
    };
  };
  [WFProductContract inquireWFProductCurrentContractandCallback:callback];
}

- (void)bindWFCurrentContractList:(WFCurrentContractList *)wfList saveCache:(BOOL)saveCache {
  if (saveCache) {
    [CacheUtil saveWFCurrentContractList:wfList];
  }
  _wfContractInfoArray.dataBinded = YES;
  self.wfcurrentlist = wfList;

  if (saveCache) {
    if (wfList.hasWFAccount) { //有配资账号，延迟显示
      _capitalfirstviewCell.isWFamount = NO;
      [self getCapitalAuditData];
    } else { //无配资账号，直接显示
      [self.wftableviewHeaderView indicatorViewStopAnimating];
      [self addFormalConstracts];
      _capitalfirstviewCell.isWFamount = YES;
      [self reloadTable];
    }
  } else { //缓存数据，直接显示
    [self addFormalConstracts];
    [self reloadTable];
  }
}

- (void)addFormalConstracts {
  [self.wfContractInfoArray.array removeAllObjects];
  if (_wfcurrentlist.list.count > 0) {
    [self.wfContractInfoArray.array addObjectsFromArray:_wfcurrentlist.list];
  }
}

/** 正在申请配资的合约列表 */
- (void)getCapitalAuditData {
  //  [self.wftableviewHeaderView indicatorViewstartAnimating];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuUserConterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addFormalConstracts];
      [strongSelf.wftableviewHeaderView indicatorViewStopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf bindPendingConstact:(WFCurrentContractQueryOrderInfoList *)obj];
  };
  callback.onFailed = ^{
    [weakSelf.Main_tableView reloadData];
    [BaseRequester defaultFailedHandler]();
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [weakSelf.Main_tableView reloadData];
    [BaseRequester defaultErrorHandler](error, ex);
  };

  [WFProductContract inquireWFProductCurrentContractQueryOrderInfoCallback:callback];
}

- (void)bindPendingConstact:(WFCurrentContractQueryOrderInfoList *)wfQueryInfo {
  if (wfQueryInfo.isExist) {
    __block NSMutableArray *contractArrayM = [NSMutableArray array];
    __block NSMutableArray *currentContractArrayM = [NSMutableArray array];
    [self.wfContractInfoArray.array enumerateObjectsUsingBlock:^(WFContractInfo *info, NSUInteger idx, BOOL *stop) {
      [contractArrayM addObject:info.contractNo];
    }];
    [_wfcurrentlist.list enumerateObjectsUsingBlock:^(WFContractInfo *info, NSUInteger idx, BOOL *stop) {
      [currentContractArrayM addObject:info.contractNo];
    }];
    [wfQueryInfo.list enumerateObjectsUsingBlock:^(WFContractInfo *info, NSUInteger idx, BOOL *stop) {
      if (![contractArrayM containsObject:info.contractNo]) {
        [self.wfContractInfoArray.array insertObject:info atIndex:idx];
      }
      if (![currentContractArrayM containsObject:info.contractNo]) {
        [_wfcurrentlist.list insertObject:info atIndex:idx];
      }
    }];
    [CacheUtil saveWFCurrentContractList:_wfcurrentlist];
  }
  [self reloadTable];
}

#pragma mark----------（1）取得用户宝箱内所有用钻石兑换的商品----------
//取得用户宝箱内所有用钻石兑换的商品（钻石商城使用的新接口）
- (void)getUserAllProducteWithDiamondsFormNet {
  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuUserConterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    SimuUserConterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindsimuUserConterPropsMyChestPageData:(simuUserConterPropsMyChestListWrapper *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  [simuUserConterPropsMyChestListWrapper requestPositionDataWithCallback:callback];
}
//数据绑定
- (void)bindsimuUserConterPropsMyChestPageData:(simuUserConterPropsMyChestListWrapper *)obj {
  //我的宝箱全部东西
  NSArray *chestArray = obj.PropsMyChestdataArray;
  BOOL m_isExitResetCard = NO;
  NSString *prodictId = nil;
  for (simuUserConterPropsMyChestListWrapper *data in chestArray) {
    NSString *pboxType = data.mPboxID;
    if (pboxType && [pboxType hasPrefix:@"D030100"]) {
      m_isExitResetCard = YES;
      prodictId = [NSString stringWithString:data.mPboxID];
    }
  }
  if (m_isExitResetCard) {
    //存在重置卡
    [AppDelegate pushViewControllerFromRight:[[MyChestsViewController alloc] init]];
  } else {
    //不存在重置卡，进入商店
    [self openMailView];
  }
}

@end
