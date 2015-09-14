//
//  SimuSellStockView.m
//  SimuStock
//
//  Created by Mac on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SelectPositionStockViewController.h"
#import "SiuSellStockViewCell.h"

@implementation SelectPositionStockAdaper

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([SiuSellStockViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return HEIGHT_OF_SELL_CELL;
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return self.dataArray.array.count;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.array == nil ||
      [self.dataArray.array count] <= indexPath.row)
    return;
  PositionInfo *positionStock = nil;
  if (self.dataArray.array && [self.dataArray.array count] > 0) {
    positionStock = self.dataArray.array[indexPath.row];
  }
  if (positionStock == nil)
    return;
  [self invokeSelectedCallbackWithStockCode:positionStock.stockCode
                              withStockName:positionStock.stockName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  PositionInfo *MyAttentionItem = nil;
  if (self.dataArray.array && [self.dataArray.array count] > 0) {
    MyAttentionItem = self.dataArray.array[indexPath.row];
  }
  SiuSellStockViewCell *cell = (SiuSellStockViewCell *)
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  //获取数据
  [cell setCellData:MyAttentionItem];
  return cell;
}
//点击表格进行回调
- (void)invokeSelectedCallbackWithStockCode:(NSString *)stockCode
                              withStockName:(NSString *)stockName {
  [self leftButtonPressWithAnimated:(_startPageType == InSellStockPage)];
  if (self.onStockSelectedCallback) {
    self.onStockSelectedCallback(stockCode, stockName, FIRST_TYPE_UNSPEC);
  }
}
- (void)leftButtonPressWithAnimated:(BOOL)animated {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:SYS_VAR_NAME_HIDESEARCHVIEW_CANCEL_MSG
                    object:nil];
  [AppDelegate popViewController:animated];
}
@end

@implementation SelectPositionStockController {
  NSInteger start;
}

- (id)initWithFrame:(CGRect)frame
             WithMatchId:(NSString *)matchId
       withStartPageType:(SellStartPageType)pageType
    withStockBuySellType:(StockBuySellType)type
            withCallBack:(OnStockSelected)callback {
  self = [super initWithFrame:frame];
  if (self) {
    self.macthId = matchId;
    startPageType = pageType;
    onStockSelectedCallback = callback;
    self.userOrExpert = type;
  }
  return self;
}

/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"0";
  NSString *endId = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    startId = [@(start + 20) stringValue];
    endId = [@(start + 40 - 1) stringValue];
  }
  NSDictionary *dic = @{
    @"userid" : [SimuUtil getUserID],
    @"matchid" : self.macthId,
    @"fromid" : startId,
    @"reqnum" : endId,
  };

  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"startnum"];
    NSString *lastId = [@(start + 20) stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (_userOrExpert == StockBuySellOrdinaryType) {
    //普通用户请求
    [SimuPositionPageData
        requestPositionDataWithDic:
            [self getRequestParamertsWithRefreshType:refreshType]
                      withCallback:callback];
  } else if (_userOrExpert == StockBuySellExpentType) {
    //牛人 请求
    [SimuPositionPageData requestExpertSellStockPosition:self.accountId
                                           withTargetUid:self.targetUid
                                            withCallback:callback];
  }
}
///** 绑定数据(调用默认的绑定方法)，首先判断是否有效 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    [super bindRequestObject:latestData
        withRequestParameters:parameters
              withRefreshType:refreshType];
    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 1;
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
  //设置小牛信息
  [self.littleCattleView setInformation:@"暂无可卖股票"];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[SelectPositionStockAdaper alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    SelectPositionStockAdaper *temp =
        (SelectPositionStockAdaper *)_tableAdapter;
    temp.macthId = self.macthId;
    temp.onStockSelectedCallback = onStockSelectedCallback;
    temp.startPageType = startPageType;
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

@end

@implementation SelectPositionStockViewController

- (id)initWithMatchId:(NSString *)matchId
    withStartPageType:(SellStartPageType)pageType
        withAccountId:(NSString *)accountId
        withTargetUid:(NSString *)targetUid
     withUserOrExpert:(StockBuySellType)type
         withCallBack:(OnStockSelected)callback {
  if (self = [super init]) {
    self.macthId = matchId;
    startPageType = pageType;
    onStockSelectedCallback = callback;
    self.accountId = accountId;
    self.targetUid = targetUid;
    self.userOrExpert = type;
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"卖出" Mode:TTBM_Mode_Leveltwo];
  [_indicatorView setButonIsVisible:NO];
  sellHeadView = [[[NSBundle mainBundle] loadNibNamed:@"SiuSellHeadView"
                                                owner:self
                                              options:nil] firstObject];
  [_clientView addSubview:sellHeadView];
  [self createViews];
  [selectPositionVC refreshButtonPressDown];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  sellHeadView.frame = CGRectMake(0, 0, CGRectGetWidth(_clientView.bounds),
                                  CGRectGetHeight(sellHeadView.bounds));
}

- (void)createViews {

  CGRect frame = CGRectMake(0, CGRectGetMaxY(sellHeadView.frame),
                            CGRectGetWidth(_clientView.bounds),
                            CGRectGetHeight(_clientView.bounds) -
                                CGRectGetHeight(sellHeadView.bounds));
  selectPositionVC = [[SelectPositionStockController alloc]
             initWithFrame:frame
               WithMatchId:self.macthId
         withStartPageType:startPageType
      withStockBuySellType:self.userOrExpert
              withCallBack:onStockSelectedCallback];
  __weak SelectPositionStockViewController *weakSelf = self;
  selectPositionVC.showTableFooter = YES;
  selectPositionVC.beginRefreshCallBack = ^{
    SelectPositionStockViewController *strongSelf = weakSelf;
    [strongSelf.indicatorView startAnimating];
    strongSelf.indicatorView.hidden = NO;
  };
  selectPositionVC.endRefreshCallBack = ^{
    SelectPositionStockViewController *strongSelf = weakSelf;
    [strongSelf.indicatorView stopAnimating];
    strongSelf.indicatorView.hidden = YES;
  };
  [_clientView addSubview:selectPositionVC.view];
  [self addChildViewController:selectPositionVC];
}
@end
