//
//  StockHeroRankListViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockHeroRankListViewController.h"
#import "StockMasterListWrapper.h"
#import "MasterRankingViewController.h"
#import "event_view_log.h"
#import "MobClick.h"
#import "RankingSortCell.h"

@implementation StockHeroRankListTableAdapter

- (id)initWithTableViewController:(BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList {
  self = [super initWithTableViewController:baseTableViewController withDataArray:dataList];
  if (self) {
    _dataMap = @{
      @0 : @{
        @"bg_icon" : @"f5b639",
        @"icon" : @"优顾推荐",
        @"ranklist" : @"优顾推荐榜",
        @"value_lbl" : @"",
        @"value" : @""
      },
      @1 : @{
        @"bg_icon" : @"FDA0A0",
        @"icon" : @"人气榜",
        @"ranklist" : @"人气排行榜",
        @"value_lbl" : @"",
        @"value" : @""
      },
      @2 : @{
        @"bg_icon" : @"63d4db",
        @"icon" : @"稳健牛人",
        @"ranklist" : @"稳健牛人榜",
        @"value_lbl" : @"",
        @"value" : @""
      },
      @3 : @{
        @"bg_icon" : @"c18df6",
        @"icon" : @"短线牛人",
        @"ranklist" : @"短线牛人榜",
        @"value_lbl" : @"",
        @"value" : @""
      },
      @4 : [@{
        @"bg_icon" : @"fda0a0",
        @"icon" : @"盈利榜",
        @"ranklist" : @"总盈利榜",
        @"value_lbl" : @"最高盈利率 ：",
        @"value" : @""
      } mutableCopy],
      @5 : [@{
        @"bg_icon" : @"fda0a0",
        @"icon" : @"成功率榜",
        @"ranklist" : @"成功率榜",
        @"value_lbl" : @"最高成功率 ：",
        @"value" : @""
      } mutableCopy],
      @6 : [@{
        @"bg_icon" : @"fda0a0",
        @"icon" : @"月盈利率",
        @"ranklist" : @"月盈利榜",
        @"value_lbl" : @"最高盈利率 ：",
        @"value" : @""
      } mutableCopy],
      @7 : [@{
        @"bg_icon" : @"fda0a0",
        @"icon" : @"周盈利率",
        @"ranklist" : @"周盈利榜",
        @"value_lbl" : @"最高盈利率 ：",
        @"value" : @""
      } mutableCopy],
    };
  }
  return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_dataMap count]; //加上分界线
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 51;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [Globle colorFromHexRGB:Color_White];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //释放选中效果
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //效果结束，切换下一页
  MasterRankingViewController *masterRankingVC = [[MasterRankingViewController alloc] init];
  switch (indexPath.row) {
  case 0:
    masterRankingVC.rankingSortNumber = @"1";
    masterRankingVC.rankingSortName = @"（推荐指数）";
    masterRankingVC.stepNumber = 0;
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-优顾推荐榜"];
    //纪录日志
    [MobClick beginLogPageView:@"炒股牛人-优顾推荐榜"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"325"];
    //详情中只记录持仓
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"327"];
    break;
  case 1:
    masterRankingVC.rankingSortNumber = @"2";
    masterRankingVC.rankingSortName = @"（人气值）";
    masterRankingVC.stepNumber = 0;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-人气榜单"];
    [MobClick beginLogPageView:@"炒股牛人-人气榜单"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"329"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"331"];
    break;
  case 2:
    masterRankingVC.rankingSortNumber = @"6";
    masterRankingVC.rankingSortName = @"（总盈利率）";
    masterRankingVC.stepNumber = 0;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-稳健牛人榜单"];
    [MobClick beginLogPageView:@"炒股牛人-稳健牛人榜单"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"329"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"331"];
    break;
  case 3:
    masterRankingVC.rankingSortNumber = @"7";
    masterRankingVC.rankingSortName = @"（总盈利率）";
    masterRankingVC.stepNumber = 0;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-短线牛人榜单"];
    [MobClick beginLogPageView:@"炒股牛人-短线牛人榜单"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"329"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"331"];
    break;

  case 4:
    masterRankingVC.rankingSortNumber = @"3";
    masterRankingVC.rankingSortName = @"（总盈利率）";
    masterRankingVC.stepNumber = 0;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-今日盈利榜"];
    [MobClick beginLogPageView:@"炒股牛人-今日盈利榜"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"333"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"335"];
    break;
  case 5:
    masterRankingVC.rankingSortNumber = @"4";
    masterRankingVC.rankingSortName = @"（成功率）";
    masterRankingVC.stepNumber = 2;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-周盈利榜"];
    [MobClick beginLogPageView:@"炒股牛人-周盈利榜"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"337"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"339"];
    break;
  case 6:
    masterRankingVC.rankingSortNumber = @"5";
    masterRankingVC.rankingSortName = @"（月盈利率）";
    masterRankingVC.stepNumber = 2;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-月盈利榜"];
    [MobClick beginLogPageView:@"炒股牛人-月盈利榜"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"341"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"343"];
    break;
  case 7:
    masterRankingVC.rankingSortNumber = @"8";
    masterRankingVC.rankingSortName = @"（周盈利率）";
    masterRankingVC.stepNumber = 2;
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                     andCode:@"炒股牛人-月盈利榜"];
    [MobClick beginLogPageView:@"炒股牛人-月盈利榜"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"341"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"343"];
    break;
  default:
    break;
  }
  masterRankingVC.rankingTitle = _dataMap[@(indexPath.row)][@"ranklist"];
  [AppDelegate pushViewControllerFromRight:masterRankingVC];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *ID = @"RankingSortCell";
  RankingSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    backView.backgroundColor = [Globle colorFromHexRGB:@"#9be5f2"];
    backView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = backView;
  }

  NSInteger row = indexPath.row;
  NSDictionary *dic = _dataMap[@(row)];
  if (dic) {
    cell.bgRankIcon.backgroundColor = [Globle colorFromHexRGB:dic[@"bg_icon"]];
    cell.rankingIconImageView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.rankingSortNameLabel.text = dic[@"ranklist"];
    cell.maxProfitLabel.text = dic[@"value_lbl"];
    if (row == 4 || row == 6 || row == 7) {
      [self setTextColorWithLabel:cell.maxProfitRateLabel
                        withValue:dic[@"value"]
                    showRiseColor:YES];
    } else {
      [self setTextColorWithLabel:cell.maxProfitRateLabel withValue:dic[@"value"] showRiseColor:NO];
    }
  } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blackCell"];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 10)];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
  }

  return cell;
}

- (void)setTextColorWithLabel:(UILabel *)label
                    withValue:(NSString *)text
                showRiseColor:(BOOL)showRiseColor {
  UIColor *textColor;
  if (showRiseColor) {
    CGFloat value =
        text.length > 0
            ? [[text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue]
            : 0.0f;
    if (value >= 0.0f) {
      textColor = [Globle colorFromHexRGB:@"ca332a"];
    } else {
      textColor = [Globle colorFromHexRGB:@"5a8a02"];
    }
  } else {
    textColor = [Globle colorFromHexRGB:@"454545"];
  }
  label.textColor = textColor;
  label.text = text;
}

@end

@implementation StockHeroRankListViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[StockHeroRankListTableAdapter alloc] initWithTableViewController:self
                                                             withDataArray:self.dataArray];
  }

  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
}

#pragma mark----------(1)判断用户是否有跟踪权限（暂时取消）----------
- (void)getDeadline {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockHeroRankListViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockHeroRankListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    StockHeroRankListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindStockMasterRuleListWrapper:(StockMasterRuleGetListWrapper *)obj];
    }
  };
  [StockMasterRuleGetListWrapper requestStockMastrbackListRuleGetWithCallback:callback];
}

#pragma mark----------RuleGet数据绑定----------
//数据绑定
- (void)bindStockMasterRuleListWrapper:(StockMasterRuleGetListWrapper *)obj {
  NSLog(@"obj.dataArrayRule+-+-+-%@", obj.dataArrayRule);
}

#pragma mark----------（2）用户利率最高值----------
- (void)getMaxProfitValue {
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }

  if (![SimuUtil isExistNetwork]) {
    [self endRefreshLoading];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockHeroRankListViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockHeroRankListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endRefreshLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    StockHeroRankListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindStockMasterHighestListWrapper:(StockMasterHighestListWrapper *)obj];
    }
  };
  [StockMasterHighestListWrapper requestStockMastrbackListHighestWithCallback:callback];
}

#pragma mark----------Highest数据绑定----------
- (void)bindStockMasterHighestListWrapper:(StockMasterHighestListWrapper *)obj {
  NSDictionary *dataMap = ((StockHeroRankListTableAdapter *)_tableAdapter).dataMap;
  dataMap[@4][@"value"] = obj.total;
  dataMap[@5][@"value"] = obj.suc;
  dataMap[@6][@"value"] = obj.month;
  dataMap[@7][@"value"] = obj.week;
  [self.tableView reloadData];
  self.dataArray.dataBinded = YES;
}
#pragma mark 对空做判断
- (NSString *)valueJudgmentsOnTheAir:(NSString *)str {
  if (!str || [str isEqualToString:@""]) {
    return @"--";
  }
  return str;
}

- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self getMaxProfitValue];
}

//页面返回时，刷新本页面是否开通追踪接口请求
- (void)refreshTraceAuthorityStatus {
  @synchronized(self) {
    //获取截止日期
    // [self getDeadline];
  }
}

@end
