//
//  SelfStockTableViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelfStockTableViewController.h"
#import "StockUtil.h"
#import "TrendViewController.h"
#import "EditStockViewController.h"
#import "AllGroupsView.h"
#import "PortfolioStockModel.h"
#import "MarketTrendListTableViewCell.h"

@implementation SelfStockTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90.0 / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"MarketTrendListTableViewCell";
  MarketTrendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];

  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:Cell owner:self options:nil] firstObject];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    backView.backgroundColor = [Globle colorFromHexRGB:@"#e8e8e8"];
    backView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = backView;
  }
  SelfStockItem *item = self.dataArray.array[indexPath.row];

  cell.nameLabel.text = [SimuUtil changeIDtoStr:item.stockName];
  NSString *format = [StockUtil getPriceFormatWithFirstType:item.firstType];
  NSString *curPrice = [NSString stringWithFormat:format, item.curPrice];
  cell.curPriceLab.text = curPrice;
  NSString *dataPer = [NSString stringWithFormat:@"%+0.2f%%", item.dataPer];

  cell.dataPerLab.textColor = [StockUtil getColorByFloat:item.dataPer];
  cell.dataPerLab.text = dataPer;
  cell.codeLab.text = item.stockCode;
  [cell.topSplitView resetViewWidth:tableView.width];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  //注销cell单击事件
  cell.selected = NO;
  //取消选中项
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
  if ([self.dataArray.array count] <= indexPath.row)
    return;
  SelfStockItem *dic = self.dataArray.array[indexPath.row];

  [TrendViewController showDetailWithStockCode:dic.code
                                 withStockName:dic.stockName
                                 withFirstType:dic.firstType
                                   withMatchId:@"1"
                                withStockArray:self.dataArray.array
                                     withIndex:indexPath.row];
}

@end

/*
 *  VC
 */
@implementation SelfStockTableViewController

static CGFloat TableHeaderHeight = 30.f;
static CGFloat TableFooterHeight = 50.f;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initVariables];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSInteger refreshTime = [SimuUtil getCorRefreshTime];
  timerUtil.timeinterval = refreshTime;
  self.local = [PortfolioStockManager currentPortfolioStockModel].local;
  [self resetHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _allGroupView.hidden = YES;
  [timerUtil stopTimer];
}

///重新设置导航分组名称
- (void)resetHeaderView {
  NSString *currentGroupID = [SimuUtil currentSelectedSelfGroupID];

  //重新检测分组信息
  __block BOOL isGroupExisted;
  [_local.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *element, NSUInteger idx, BOOL *stop) {
    //如果当前的groupId不存在了，则切换为全部列表
    if ([currentGroupID isEqualToString:element.groupId]) {
      isGroupExisted = YES;
      *stop = YES;
    } else {
      isGroupExisted = NO;
    }
  }];

  //如果分组已不存在了，则切换为全部分组；如果存在，则必须切换为其他页面选择的分组
  if (!isGroupExisted) {
    [self setHeaderViewWithGroupId:GROUP_ALL_ID groupName:@"全部"];
  } else {
    [self setHeaderViewWithGroupId:currentGroupID
                         groupName:[[_local findGroupById:currentGroupID] groupName]];
  }
}

///设置导航分组名称
- (void)setHeaderViewWithGroupId:(NSString *)groupId groupName:(NSString *)groupName {
  BOOL needUpdateStocks = ![groupId isEqualToString:_groupId];

  _groupId = groupId;
  _groupName = groupName;

  [_tableHeader bindGroup:groupName];

  [SimuUtil saveCurrentSelectedSelfGroupID:groupId];
  if (needUpdateStocks) {
    __weak SelfStockTableViewController *weakSelf = self;
    [SimuUtil performBlockOnMainThread:^{
      [weakSelf requestResponseWithRefreshType:RefreshTypeTimerRefresh];
    } withDelaySeconds:0.1];
  }
}

- (UIView *)noSelfStockView {
  if (noSelfStockView == nil) {
    noSelfStockView =
        [[[NSBundle mainBundle] loadNibNamed:@"NoSelfStockView" owner:nil options:nil] firstObject];
    noSelfStockView.frame = self.tableView.frame;
    noSelfStockView.height = noSelfStockView.height - TableHeaderHeight;
  }
  return noSelfStockView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.littleCattleView = nil;
  _groupId = GROUP_ALL_ID;
  self.headerView.hidden = NO;
  self.footerView.hidden = YES;

  [self createGroupFloatViewAndTableHeader];
  [self addObservers];

  __weak SelfStockTableViewController *weakSelf = self;
  [_tableHeader.btnSort setOnButtonPressedHandler:^{
    [weakSelf sortButtonPressed];
  }];

  //  用户进入自选股列表页，如果检测本地有修改时，同步
  [self synchronizePortfolioStock];
}

- (void)synchronizePortfolioStock {
  if ([SimuUtil isLogined]) {
    QuerySelfStockData *local = [PortfolioStockManager currentPortfolioStockModel].local;
    QuerySelfStockData *base = [PortfolioStockManager currentPortfolioStockModel].base;
    if (base == nil || local == nil) {
      return;
    }
    if (![[local getUploadPortfolioString] isEqualToString:[base getUploadPortfolioString]]) {
      [PortfolioStockManager synchronizePortfolioStock];
    }
  }
}

- (void)createGroupFloatViewAndTableHeader {

  //加载本地自选股分组数据
  _local = [PortfolioStockManager currentPortfolioStockModel].local;

  __weak SelfStockTableViewController *weakSelf = self;

  //分组浮窗
  _allGroupView =
      [[[NSBundle mainBundle] loadNibNamed:@"AllGroupsView" owner:self options:nil] firstObject];

  _allGroupView.choiceGroupBlock = ^(NSString *groupName, NSString *groupId) {
    [weakSelf setHeaderViewWithGroupId:groupId groupName:groupName];
    [weakSelf refreshSelfStocks];
  };

  [_allGroupView reloadTableViewWithQuerySelfStockData:_local];
  _allGroupView.hidden = YES;
  [WINDOW addSubview:_allGroupView];

  //表头
  NSArray *views =
      [[NSBundle mainBundle] loadNibNamed:@"SelfStockTableHeaderView" owner:nil options:nil];
  _tableHeader = [views firstObject];
  if (_tableHeader) {
    _tableHeader.frame = self.view.bounds;
    _tableHeader.sortIndicator.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    [self.view addSubview:_tableHeader];
    [self.view bringSubviewToFront:self.tableView];
    [self showBottomLoginView:![SimuUtil isLogined]];

    //点击回调
    [_tableHeader.groupButton setOnButtonPressedHandler:^{
      //未登录禁止弹窗
      if (![SimuUtil isLogined]) {
        return;
      }
      //本地数据为空（登陆后突然无网导致）
      if (weakSelf.local.dataArray.count == 0) {
        return;
      }

      //将本地的分组信息中“全部”分组调至第一位
      QuerySelfStockElement *allGroup = [weakSelf.local findGroupById:GROUP_ALL_ID];
      if (allGroup) {
        [weakSelf.local.dataArray removeObject:allGroup];
        [weakSelf.local.dataArray insertObject:allGroup atIndex:0];
      }
      //重设位置
      weakSelf.allGroupView.upArrowTopCons.constant =
          [weakSelf.tableHeader convertPoint:weakSelf.tableHeader.origin toView:WINDOW].y + 34;

      //刷新表格
      [weakSelf.allGroupView reloadTableViewWithQuerySelfStockData:[PortfolioStockManager currentPortfolioStockModel].local];
      weakSelf.allGroupView.hidden = NO;
      [weakSelf.view bringSubviewToFront:weakSelf.allGroupView];
    }];

    //恢复成用户上次选择的分组
    [self resetHeaderView];
  }
}

- (void)addObservers {
  __weak SelfStockTableViewController *weakSelf = self;
  portfolioStockChangeObserver = [[SelfStockChangeNotification alloc] init];
  portfolioStockChangeObserver.onSelfStockChange = ^{
    [weakSelf refreshSelfStocks];
  };
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];
  NSString *stringStock = [group stockListStringWithSplit:@","];
  if (stringStock == nil || [stringStock length] == 0) {
    [self endRefreshLoading];
    StockTableData *data = [[StockTableData alloc] init];
    data.stocks = [@[] mutableCopy];
    [self bindRequestObject:data withRequestParameters:nil withRefreshType:refreshType];
    return;
  }
  [StockTableData getSelfStockInfo:stringStock withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[SelfStockTableAdapter alloc] initWithTableViewController:self
                                                                 withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;

  BOOL isDataEmpty = ([latestData getArray].count == 0);

  if (refreshType == RefreshTypeRefresh && !isDataEmpty) {
    [NewShowLabel setMessageContent:@"自选股行情更新成功"];
  }
  if (isDataEmpty) {
    self.tableView.scrollEnabled = NO;
    _tableHeader.btnSort.enabled = NO;
    self.tableView.tableFooterView = self.noSelfStockView;
    [self.tableView reloadData];
  } else {
    self.tableView.tableFooterView = nil;
    self.tableView.scrollEnabled = YES;
    _tableHeader.btnSort.enabled = YES;
    [self resortList];
  }
}

- (void)setNoNetWork {
  [super setNoNetWork];
  if (!self.dataArray.dataBinded) {
    _tableHeader.btnSort.enabled = NO;
  }
}

- (void)endRefreshLoading {
  [super endRefreshLoading];
  //菊花关闭
  if ([_tableHeader.sortIndicator isAnimating]) {
    [_tableHeader.sortIndicator stopAnimating];
    _tableHeader.iconSort.hidden = NO;
  }
}

- (void)resetSortIcon {
  ssvc_order = ListOrderNatural; //初始化为自然序
  _tableHeader.iconSort.image = [UIImage imageNamed:@"排序_暗"];
}

- (void)initVariables {
  ssvc_order = ListOrderNatural; //初始化为自然序
  __weak SelfStockTableViewController *weakSelf = self;
  loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  loginLogoutNotification.onLoginLogout = ^{
    //用户切换时，更新local和groupInfo
    weakSelf.local = [PortfolioStockManager currentPortfolioStockModel].local;
    [weakSelf resetHeaderView];
    [weakSelf resetSortIcon];
    //刷新数据
    [weakSelf refreshSelfStocks];
  };

  NSInteger refreshTime = [SimuUtil getCorRefreshTime];
  timerUtil = [[TimerUtil alloc] initWithTimeInterval:refreshTime
                                     withTimeCallBack:^{
                                       //如果无网络，则什么也不做；
                                       if (![SimuUtil isExistNetwork]) {
                                         return;
                                       }
                                       //如果当前交易所状态为闭市，则什么也不做
                                       if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
                                         return;
                                       }

                                       //自选股为空时，不自动刷新
                                       QuerySelfStockElement *group =
                                           [[PortfolioStockManager currentPortfolioStockModel]
                                                   .local findGroupById:weakSelf.groupId];
                                       if (group.stockCodeArray.count == 0) {
                                         return;
                                       }

                                       [weakSelf requestResponseWithRefreshType:RefreshTypeTimerRefresh];
                                     }];
}

- (void)refreshSelfStocks {
  [self showBottomLoginView:![SimuUtil isLogined]];
  self.dataArray.dataBinded = NO;
  [self requestResponseWithRefreshType:RefreshTypeTimerRefresh];
}

- (void)sortButtonPressed {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetWork];
    return;
  }
  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];
  NSString *stringStock = [group stockListStringWithSplit:@","];
  if (stringStock == nil || [stringStock length] == 0) {
    return;
  }
  if (![_tableHeader.sortIndicator isAnimating]) {
    [_tableHeader.sortIndicator startAnimating];
    _tableHeader.iconSort.hidden = YES;
  }

  if (ssvc_order == ListOrderNatural) {
    //原来顺序
    ssvc_order = ListOrderDescending;
    _tableHeader.iconSort.image = [UIImage imageNamed:@"排序_下"];
  } else if (ssvc_order == ListOrderDescending) {
    ssvc_order = ListOrderAscending;
    _tableHeader.iconSort.image = [UIImage imageNamed:@"排序_上"];
  } else if (ssvc_order == ListOrderAscending) {
    ssvc_order = ListOrderNatural;
    _tableHeader.iconSort.image = [UIImage imageNamed:@"排序_暗"];
  }

  if (self.dataArray.array.count > 0) {
    [self resortList];
  }

  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

//重新排序
- (void)resortList {
  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];
  NSString *stringStock = [group stockListStringWithSplit:@","];

  NSArray *sortedArray =
      [self.dataArray.array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SelfStockItem *stock1 = (SelfStockItem *)obj1;
        SelfStockItem *stock2 = (SelfStockItem *)obj2;

        if (ssvc_order == ListOrderNatural) { //自然序
          NSUInteger positionOfObj1 = [self getPositionOfStock:stock1.code inStocks:stringStock];
          NSUInteger positionOfObj2 = [self getPositionOfStock:stock1.code inStocks:stringStock];
          return positionOfObj1 < positionOfObj2
                     ? NSOrderedAscending
                     : positionOfObj1 == positionOfObj2 ? NSOrderedSame : NSOrderedDescending;
        } else {
          NSNumber *x_i1 = [[NSNumber alloc] initWithFloat:stock1.dataPer];
          NSNumber *x_i2 = [[NSNumber alloc] initWithFloat:stock2.dataPer];

          if (ssvc_order == ListOrderAscending) { //升序
            return [x_i1 compare:x_i2];
          } else { // if (ssvc_order == ListOrderDescending) { //降序
            return [x_i2 compare:x_i1];
          }
        }
      }];
  self.dataArray.array = [[NSMutableArray alloc] initWithArray:sortedArray];
  [self.tableView reloadData];
}

- (NSUInteger)getPositionOfStock:(NSString *)stockCode inStocks:(NSString *)selfStocks {
  return [selfStocks rangeOfString:stockCode].location;
}

- (void)showBottomLoginView:(BOOL)show {
  self.tableView.top = TableHeaderHeight;
  self.tableView.height = self.view.size.height - TableHeaderHeight;
  if (show) {
    _tableHeader.loginView.hidden = NO;
    self.tableView.height -= TableFooterHeight;
  } else {
    _tableHeader.loginView.hidden = YES;
  }
}

- (BOOL)shouldShowManageButton {
  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];
  return group.stockCodeArray.count > 0;
}

- (void)manageSelfStocks {
  [AppDelegate pushViewControllerFromRight:[[EditStockViewController alloc] initWithWithGroupId:_groupId
                                                                                      groupName:_groupName]];
}

@end
