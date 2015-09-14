//
//  FSPositionsViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FSPositionsViewController.h"
#import "FirmSaleTableViewCell.h"

#import "RealTradeRequester.h"
#import "StockUtil.h"
//扩展框类
#import "FSExtendButtons.h"
//优顾实盘请求持仓 请求类
#import "WFDataSharingCenter.h"
#import "CacheUtil.h"

@implementation FSPositionTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return HEIGHT_OF_SELL_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"Identifier";
  FirmSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
  if (!cell) {
    cell = [[FirmSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:Cell];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#e8e8e8"];
  }
  [cell reSetUpFirmSaleCellFrameWithWidth:WIDTH_OF_SCREEN];
  if (self.firmOrCapital == YES) {
    PositionResult *posRes = self.dataArray.array[indexPath.row];
    [self cellViewAssignment:cell dic:posRes];
  } else {
    WFfirmStockListData *stockListData = self.dataArray.array[indexPath.row];
    [self bingCellData:cell withStockList:stockListData];
  }
  return cell;
}

//配资Cell 赋值
- (void)bingCellData:(FirmSaleTableViewCell *)cell withStockList:(WFfirmStockListData *)stockList {
  NSArray *arr = @[
    stockList.stockName,
    stockList.profit,
    stockList.currentAmount,
    stockList.costBalance,
    stockList.marketValue,
    stockList.profitRate,
    stockList.enableAmount,
    stockList.price,
  ];
  UIColor *color = [StockUtil getColorByText:stockList.profit];
  for (int i = 0; i < 8; i++) {
    UILabel *lab = [cell.arrLab objectAtIndex:i];
    lab.text = [NSString stringWithFormat:@"%@", [arr objectAtIndex:i]];
    lab.textColor = color;
  }
}

// cell赋值
- (void)cellViewAssignment:(FirmSaleTableViewCell *)cell dic:(PositionResult *)posRes {
  NSArray *arr = @[
    posRes.stockName,
    posRes.floatProfitLoss,
    posRes.stockNum,
    posRes.break_evenPrice,
    posRes.latestValue,
    posRes.profitLossRate,
    posRes.availableStock,
    posRes.latestPrice
  ];
  UIColor *color = [StockUtil getColorByText:posRes.floatProfitLoss];
  for (int i = 0; i < 8; i++) {
    UILabel *lab = cell.arrLab[i];
    lab.text = [NSString stringWithFormat:@"%@", arr[i]];
    lab.textColor = color;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

  FSPositionsViewController *vc = (FSPositionsViewController *)self.baseTableViewController;
  [vc onSelectStockWithTableView:tableView didDeselectRowAtIndexPath:indexPath];
}

@end

@implementation FSPositionsViewController

- (id)initSale:(NSString *)sale rect:(CGRect)rect withFirmOfferOrCapital:(BOOL)firmOrCapital {
  self = [super initWithFrame:rect];
  if (self) {
    if (sale)
      self.sale = sale;
    _firmOrCapital = firmOrCapital;
  }
  return self;
}
- (id)initAccount:(NSString *)account rect:(CGRect)rect withFirmOfferOrCapital:(BOOL)firmOrCapital {
  self = [super initWithFrame:rect];
  if (self) {
    if (account)
      self.account = account;
    _firmOrCapital = firmOrCapital;
  }
  return self;
}

CGFloat HeaderHeight = 30.f;

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建一个 通知 监听撤单界面
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadNewData)
                                               name:@"cencleEntrustSuccess"
                                             object:nil];
  [self creatHeaderView];
  [self refreshButtonPressDown];
  // if cache exist, load cache
  [self reloadDataWithTableView];
  [self.littleCattleView resetFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, self.view.height - HeaderHeight)];
}
//实现通知的方法
- (void)reloadNewData {
  //刷新数据
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//每次显示 都刷新 下最新的数据
- (void)reloadDataWithTableView {
  NSString *cacheKey = [WFDataSharingCenter shareDataCenter].operatorNo;
  GetStockFirmPositionDataAnalysis *cache = [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:cacheKey]
                                                          withClassType:[GetStockFirmPositionDataAnalysis class]
                                                            withTimeout:60 * 60.f];
  if (cache) {
    [self bindRequestObject:cache withRequestParameters:nil withRefreshType:RefreshTypeRefresh];
  }
}

#pragma mark-------视图部分-------
#pragma mark
//创建表头
- (void)creatHeaderView {

  _header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, HeaderHeight)];
  _header.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  [self.view addSubview:_header];
  NSArray *nameArr = @[
    @"市值",
    @"盈亏",
    @"持仓/可用", //
    @"成本/现价"
  ];
  for (int i = 0; i < 4; i++) {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((i % 4) * _header.bounds.size.width / 4,
                                                             0.0, _header.bounds.size.width / 4, 30.0)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = nameArr[i];
    lab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:Font_Height_14_0];
    [_header addSubview:lab];

    //加入纵向分割线
    UIView *lineleftView =
        [[UIView alloc] initWithFrame:CGRectMake((i % 4 + 1) * _header.bounds.size.width / 4 - 1, 1,
                                                 1, _header.frame.size.height - 2)];
    lineleftView.backgroundColor = [Globle colorFromHexRGB:@"#f2f3f6"];
    UIView *linerighttView =
        [[UIView alloc] initWithFrame:CGRectMake((i % 4) * _header.bounds.size.width / 4, 1, 1, _header.frame.size.height - 2)];
    linerighttView.backgroundColor = [Globle colorFromHexRGB:@"#ced0d6"];
    [_header addSubview:lineleftView];
    [_header addSubview:linerighttView];
  }
  self.tableView.top += HeaderHeight;
  self.tableView.height -= HeaderHeight;
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  return @{ @"dataSource" : @"fromServer" };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  return YES;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (_firmOrCapital) {
    RealTradeRequester *requester = [[RealTradeRequester alloc] init];
    id real = [RealTradeUrls getRealTradeUrlFactory];
    [requester asynExecuteWithRequestUrl:[real getQueryuserstockPath]
                       WithRequestMethod:[real getBrokerRequstMethod]
                   withRequestParameters:nil
                  withRequestObjectClass:[PositionData class]
                 withHttpRequestCallBack:callback];
  } else {

    //配资 持仓数据请求 账户页面 和 买入 卖出 页面 sale == nil ?
    NSString *hsUserId = [WFDataSharingCenter shareDataCenter].hsUserId;
    NSString *homsFundAccount = [WFDataSharingCenter shareDataCenter].homsFundAccount;
    NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
    NSString *operatorNo = [WFDataSharingCenter shareDataCenter].operatorNo;
    if ([self.sale isEqualToString:@"sale"]) {
      [GetStockFirmPositionData requestQueryPositionWithHsUserID:hsUserId
                                             withHomsFundAccount:homsFundAccount
                                               withHomsCombineld:homsCombineId
                                                    withCallback:callback];
    } else {

      [GetStockFirmPositionData requestToSendGetDataWithHsUserId:hsUserId
                                             withHomsFundAccount:homsFundAccount
                                               withHomsCombineld:homsCombineId
                                                  withOperatorNo:operatorNo
                                                    withCallback:callback];
    }
  }
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[FSPositionTableAdapter alloc] initWithTableViewController:self
                                                                  withDataArray:self.dataArray];
    //如果有成员变量 必须初始化
    ((FSPositionTableAdapter *)_tableAdapter).firmOrCapital = _firmOrCapital;
  }
  return _tableAdapter;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  if (_firmOrCapital) {
    self.positionData = (PositionData *)latestData;
    [self.posDelegate sendToFinfomationMoreVC:self.positionData];
    if ([self.account isEqualToString:@"account"]) {
      self.accountZqdm(self.positionData);
    }
  } else {
    GetStockFirmPositionDataAnalysis *stockFirPosition = (GetStockFirmPositionDataAnalysis *)latestData;
    if ([self.account isEqualToString:@"WFHeadView"]) {
      self.headViewData(stockFirPosition.firmHeadInfoData);
    }
    if (parameters && [@"fromServer" isEqualToString:parameters[@"dataSource"]]) {
      // save cache
      NSString *cacheKey = [WFDataSharingCenter shareDataCenter].operatorNo;
      [CacheUtil saveCacheData:stockFirPosition withKey:[CacheUtil getUserKey:cacheKey]];
    }
  }
  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
  self.dataArray.dataComplete = YES;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

#pragma mark-- 卖出股票后 将卖出的股票从数组里删
//- (void)afterSellTheStockFromTheStockArray:(NSString *)stockCode
//                            andStockAmount:(NSString *)amount {
//  for (int i = 0; i < self.dataArray.array.count; i++) {
//    WFfirmStockListData *stockInfo = self.dataArray.array[i];
//    if ([stockInfo.stockCode isEqualToString:stockCode]) {
//      //如果卖出后 当前可用股票数为0 从数组里删除
//      if ([amount intValue] - [stockInfo.enableAmount intValue] == 0) {
//        [self.dataArray.array removeObjectAtIndex:i];
//        [self.tableView reloadData];
//        return;
//      }
//    }
//  }
//}

- (void)onSelectStockWithTableView:(UITableView *)tableView
         didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //获取当前 Cell的位置
  CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
  CGRect rectInSuperView = [tableView convertRect:rectInTableView toView:[tableView superview]];
  //根据Cell位置来 创建 扩展框
  FSExtendButtons *fsExtendButton = [FSExtendButtons sharedExtendButtons];
  [self.view addSubview:fsExtendButton];

  if ([self.sale isEqualToString:@"sale"]) {
    fsExtendButton.hidden = YES;
    //实盘
    if (_firmOrCapital) {
      PositionResult *posRes = self.dataArray.array[indexPath.row];
      self.plancountZqdm(posRes, NO);
    } else {
      //配资
      WFfirmStockListData *stockListData = self.dataArray.array[indexPath.row];
      self.plancountZqdm(stockListData, NO);
    }
  } else {
    fsExtendButton.hidden = NO;
    //将self.sale作为参数传过去
    if (_firmOrCapital == YES) {
      [FSExtendButtons showWithTweetListItem:self.dataArray
                                     offsetY:rectInSuperView
                                      andNum:indexPath.row
                                     andSale:self.sale
                                     andBool:_firmOrCapital];
    } else {
      [FSExtendButtons showWithTweetListItem:self.dataArray
                                     offsetY:rectInSuperView
                                      andNum:indexPath.row
                                     andSale:self.sale
                                     andBool:_firmOrCapital];
    }
  }
  [SimuUtil performBlockOnMainThread:^{
    [self.tableView reloadData];
  } withDelaySeconds:0.1];
}

@end
