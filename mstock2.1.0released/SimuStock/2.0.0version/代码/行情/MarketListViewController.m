//
//  MarketListViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-7-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketListViewController.h"
#import "SimuUtil.h"

#import "MarketListTableViewCell.h"
#import "SchollWebViewController.h"
#import "TrendViewController.h"
#import "SelectStocksViewController.h"
#import "MarketHomeTableData.h"

@interface MarketListViewController () <
    MJRefreshBaseViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UIGestureRecognizerDelegate> {
}
///表头显示的顺序，与之对应的数据列表的顺序
@property(nonatomic, assign) DataListOrder tableHeaderOrder;

/** 智能选股指标类型 */
@property(nonatomic, assign) RecommendStockType recommendStockType;

@end

@implementation MarketListViewController

static const int pageCount = 20;

- (void)dealloc {
  marketListtableView.delegate = nil;
  marketListtableView.dataSource = nil;
  if (footerView) {
    [footerView free];
    footerView.scrollView = nil;
  }
  if (headerView) {
    [headerView free];
    headerView.scrollView = nil;
  }
}

- (id)initStockListType:(StockListType)stockListType {
  if (self = [super init]) {
    [self setValuesWithStockListType:stockListType];
  }
  return self;
}

- (id)initIndustryNotionCode:(NSString *)industryNotionCode
      withIndustryNotionName:(NSString *)industryNotionName {
  if (self = [self initStockListType:StockListTypeIndustryNotion]) {
    self.codeStr = industryNotionCode;
    self.titleStr = industryNotionName;
  }
  return self;
}

- (id)initRecommendCode:(NSString *)recommendTypeCode
      withRecommendName:(NSString *)recommendTypeName {
  if (self = [self initStockListType:StockListTypeStocksOfRecommnendType]) {
    self.codeStr = recommendTypeCode;
    self.titleStr = recommendTypeName;
    if ([@"TL002" isEqualToString:recommendTypeCode]) {
      _recommendStockType = RecommendStockTypeRocket;
    } else if ([@"TL004" isEqualToString:recommendTypeCode]) {
      _recommendStockType = RecommendStockTypeTopest;
    } else if ([@"TL003" isEqualToString:recommendTypeCode]) {
      _recommendStockType = RecommendStockType5Coming;
    } else if ([@"TL005" isEqualToString:recommendTypeCode]) {
      _recommendStockType = RecommendStockTypeMACD;
    } else if ([@"TL001" isEqualToString:recommendTypeCode]) {
      _recommendStockType = RecommendStockTypeHotBuy;
    }
  }
  return self;
}

- (void)setValuesWithStockListType:(StockListType)stockListType {
  if (_stockListType == StockListTypeExchange ||
      _stockListType == StockListTypeAmplitude ||
      _stockListType == StockListTypeIPO ||
      _stockListType == StockListTypeStocksOfRecommnendType) {
    useStockTextColor = NO;
  } else {
    useStockTextColor = YES;
  }

  _stockListType = stockListType;
  switch (stockListType) {
  case StockListTypeIndex:
    self.titleStr = @"大盘指数";
    self.tableHeaderOrder = DataListOrderNormal;
    _headerViewTimeKey = @"key";
    urlPart = @"quote/stocklist2/marketexponent/list";
    break;
  case StockListTypeIndustry:
    self.titleStr = @"热门行业";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"hotIndustry";
    urlPart = @"quote/stocklist2/industry/list?";
    break;
  case StockListTypeNotion:
    self.titleStr = @"热门概念";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"hotNotion";
    urlPart = @"quote/stocklist2/notion/list?";
    break;
  case StockListTypeRecommend:
    self.titleStr = @"智能选股";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"recommend";
    urlPart = @"quote/stocklist2/toplist/boardlist?";
    break;
  case StockListTypeRise:
    self.titleStr = @"涨幅榜";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"stockRise";
    urlPart = @"quote/stocklist2/rank/zd?";
    break;
  case StockListTypeFall:
    self.titleStr = @"跌幅榜";
    self.tableHeaderOrder = DataListOrderAsc;
    _headerViewTimeKey = @"stockFall";
    urlPart = @"quote/stocklist2/rank/zd?";
    break;
  case StockListTypeExchange:
    self.titleStr = @"换手榜";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"stockExchange";
    urlPart = @"quote/stocklist2/rank/hs?";
    break;
  case StockListTypeAmplitude:
    self.titleStr = @"振幅榜";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"stockAmplitude";
    urlPart = @"quote/stocklist2/rank/zf?";
    break;
  case StockListTypeIPO:
    self.titleStr = @"新股发行";
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"stockIPO";
    urlPart = @"quote/stocklist2/newstock/list?";
    break;
  case StockListTypeIndustryNotion:
    self.tableHeaderOrder = DataListOrderDesc;
    _headerViewTimeKey = @"industryOrNotion";
    urlPart = @"quote/stocklist2/board/stock/list?";
    break;
  case StockListTypeStocksOfRecommnendType:
    self.tableHeaderOrder = DataListOrderNormal;
    _headerViewTimeKey = @"stocksOfRecommendType";
    urlPart = @"quote/stocklist2/toplist/queryboard?";
    break;
  default:
    break;
  }

  dataArray = [[DataArray alloc] init];
  dataArray.startIndex = 1;
  dataArray.dataOrder = self.tableHeaderOrder;
}

//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self stopMyTimer];
  [self initTrendTimer];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self stopMyTimer];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_littleCattleView setInformation:@"暂无数据"];
  [_topToolBar resetContentAndFlage:self.titleStr Mode:TTBM_Mode_Leveltwo];

  [self createTableHeader];
  [self createTableView];
  [self resetIndicatorView];
  [self creatSearchButtonView];
  //网络请求
  [self refreshButtonPressDown];

  if (_stockListType == StockListTypeIndex) {
    footerView.hidden = YES;
    headerView.hidden = NO;
  }
}

#pragma mark 按钮触发方法
- (void)createButtonToTriggerMethods {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (![tableHeader.sortingIndicatorView isAnimating]) {
    [tableHeader.sortingIndicatorView startAnimating];
    tableHeader.sortOrderImageView.hidden = YES;
    tableHeader.sortButton.hidden = YES;
  }

  [self requestDataWithStart:1
                  withReqnum:pageCount
                   withOrder:self.tableHeaderOrder * (-1)
             withRefreshType:YES];
}

///表头
- (void)createTableHeader {
  __weak MarketListViewController *weakSelf = self;

  CGRect thFrame = CGRectMake(0.0, _topToolBar.bounds.size.height,
                              self.view.bounds.size.width, 59.0 / 2);
  tableHeader =
      [[MarketListTableHeader alloc] initWithFrame:thFrame
                                 withStockListType:_stockListType
                                 withRecommendType:_recommendStockType
                                  withSortCallBack:^{
                                    [weakSelf createButtonToTriggerMethods];
                                  }];
  [self.view addSubview:tableHeader];
}

#pragma mark UITableView
- (void)createTableView {
  marketListtableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, tableHeader.bounds.size.height,
                               self.view.bounds.size.width,
                               self.clientView.bounds.size.height -
                                   tableHeader.bounds.size.height)
              style:UITableViewStylePlain]; // CGRectMake(0,
  marketListtableView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  marketListtableView.delegate = self;
  marketListtableView.dataSource = self;
  marketListtableView.separatorStyle = UITableViewCellAccessoryNone;
  [self.clientView addSubview:marketListtableView];
  marketListtableView.hidden = YES;
  footerView = [[MJRefreshFooterView alloc]
      initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width,
                               self.view.bounds.size.height)];
  //调整下拉刷新
  [footerView singleRow];
  footerView.delegate = self;
  footerView.scrollView = marketListtableView;
  // 下拉刷新
  headerView = [[MJRefreshHeaderView alloc] initWithPage:_headerViewTimeKey];
  headerView.scrollView = marketListtableView;
  headerView.delegate = self;
  [headerView singleRow];
}
#pragma mark UITableView UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [dataArray.array count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"cell";
  MarketListTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:Cell];
  if (cell == nil) {
    cell = [[MarketListTableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:Cell];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor =
        [Globle colorFromHexRGB:@"#e8e8e8"];
  }
  NSMutableDictionary *dic = dataArray.array[indexPath.row];
  if (_stockListType == StockListTypeRise ||
      _stockListType == StockListTypeFall ||
      _stockListType == StockListTypeExchange ||
      _stockListType == StockListTypeAmplitude ||
      _stockListType == StockListTypeIndustryNotion ||
      _stockListType == StockListTypeIndex) {
    cell.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
    NSString *firstType = [dic[@"firstType"] stringValue];
    NSString *formatTemplate =
        [StockUtil isFund:firstType] ? @"%0.3f" : @"%0.2f";
    NSString *curPrice = [NSString
        stringWithFormat:formatTemplate, [dic[@"curPrice"] floatValue]];
    cell.curPriceLab.text = curPrice;
    if (_stockListType == StockListTypeIndex) {
      //      cell.curPriceLab.frame =
      //          CGRectMake((tableView.bounds.size.width - 100.0) / 2, (90.0 -
      //          42.0) / 4, 95.0, 42.0 / 2);
    }

    float value = [dic[@"dataPer"] floatValue];
    NSString *dataPer = (_stockListType == StockListTypeStocksOfRecommnendType)
                            ? dic[@"val"]
                            : [NSString stringWithFormat:@"%+0.2f%%", value];
    if (_stockListType == StockListTypeExchange ||
        _stockListType == StockListTypeAmplitude ||
        _stockListType == StockListTypeIPO) {
      useStockTextColor = NO;
    } else {
      useStockTextColor = YES;
    }
    if (useStockTextColor) {
      cell.dataPerLab.textColor = [StockUtil getColorByFloat:value];
    } else {
      cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    }

    cell.dataPerLab.text = dataPer;
  } else if (_stockListType == StockListTypeStocksOfRecommnendType) {
    [cell bindRecommendStock:dic withRecommendStockType:_recommendStockType];
  } else if (_stockListType == StockListTypeIndustry ||
             _stockListType == StockListTypeNotion ||
             _stockListType == StockListTypeRecommend) {
    cell.nameLab.text = [SimuUtil changeIDtoStr:dic[@"leaderName"]];
    cell.curPriceLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
    float value = [dic[@"dataPer"] floatValue];
    NSString *dataPer = [NSString stringWithFormat:@"%+0.2f%%", value];

    cell.dataPerLab.textColor = [StockUtil getColorByFloat:value];

    cell.dataPerLab.text = dataPer;
    CGFloat labelWidth = WIDTH_OF_SCREEN / 3.f;

    cell.dataPerLab.font = [UIFont systemFontOfSize:40.0 / 2];
    cell.dataPerLab.textAlignment = NSTextAlignmentRight;
    cell.curPriceLab.font = [UIFont systemFontOfSize:30.0 / 2];
    cell.curPriceLab.textAlignment = NSTextAlignmentLeft;
    cell.nameLab.textAlignment = NSTextAlignmentLeft;
    cell.codeLab.textAlignment = NSTextAlignmentLeft;

    CGFloat fixSpace = 18;
    CGFloat ratioSpace = 28;
    cell.curPriceLab.frame =
        CGRectMake(fixSpace, (90.0 - 42.0) / 4, labelWidth, 42.0 / 2);
    cell.dataPerLab.frame =
        CGRectMake(labelWidth, (90.0 - 42.0) / 4, labelWidth - fixSpace, 42.0 / 2);
    cell.nameLab.frame = CGRectMake(labelWidth * 2 + ratioSpace * RATIO_OF_SCREEN_WIDTH,
                                    16.0 / 2, labelWidth, 32.0 / 2);
    cell.codeLab.frame = CGRectMake(labelWidth * 2 + ratioSpace * RATIO_OF_SCREEN_WIDTH,
                                    54.0 / 2, labelWidth, 26.0 / 2);

  } else if (_stockListType == StockListTypeIPO) {
    cell.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
    int64_t curlong = [dic[@"issueShare"] longLongValue];
    NSInteger curlFloat = curlong / 10000;
    NSString *curPrice = [NSString stringWithFormat:@"%ld", (long)curlFloat];
    cell.curPriceLab.text = curPrice;
    cell.dataPerLab.text = [SimuUtil changeIDtoStr:dic[@"applyDate"]];
    cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  }
  if (_stockListType == StockListTypeIndustry ||
      _stockListType == StockListTypeNotion ||
      _stockListType == StockListTypeRecommend) {
    NSString *stockcode =
        [NSString stringWithFormat:@"%lld", [dic[@"leaderCode"] longLongValue]];
    if (stockcode.length == 8) {
      stockcode = [stockcode substringFromIndex:2];
    }
    cell.codeLab.text = stockcode;
  } else {
    NSString *stockcode =
        [NSString stringWithFormat:@"%lld", [dic[@"code"] longLongValue]];
    if (stockcode.length == 8) {
      stockcode = [stockcode substringFromIndex:2];
    }
    cell.codeLab.text = stockcode;
  }

  return cell;
}

// uitable的选择方法
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if (_stockListType == StockListTypeIPO) {
    NSMutableDictionary *dic = dataArray.array[indexPath.row];
    NSString *stockcode =
        [NSString stringWithFormat:@"%lld", [dic[@"code"] longLongValue]];

    NSString *texturl = [sharesWeb_address
        stringByAppendingFormat:@"resource/newstockhtml/%@/newstock.html",
                                stockcode];

    [SchollWebViewController startWithTitle:@"新股发行" withUrl:texturl];
    return;
  } else if (_stockListType == StockListTypeIndustry ||
             _stockListType == StockListTypeNotion ||
             _stockListType == StockListTypeRecommend) {
    NSMutableDictionary *dic = dataArray.array[indexPath.row];
    NSString *stockcode = [NSString stringWithFormat:@"%@", dic[@"code"]];
    NSString *stockname = [SimuUtil changeIDtoStr:dic[@"name"]];

    MarketListViewController *marketListVC;
    if (_stockListType == StockListTypeRecommend) {
      marketListVC =
          [[MarketListViewController alloc] initRecommendCode:stockcode
                                            withRecommendName:stockname];
    } else {
      marketListVC =
          [[MarketListViewController alloc] initIndustryNotionCode:stockcode
                                            withIndustryNotionName:stockname];
    }
    marketListVC.page = classSkip;
    [AppDelegate pushViewControllerFromRight:marketListVC];

    return;
  }

  [self showStockList:dataArray.array index:indexPath.row];
}

#pragma mark
#pragma mark 代理方法------------------进入刷新状态就会调用---------------
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [self performSelector:@selector(endRefreshLoading)
               withObject:nil
               afterDelay:0.5];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (refreshView == footerView) {
    [self loadNextPage];
  } else if (refreshView == headerView) {
    [self loadPreviousPageOrRefresh];
  }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == dataArray.array.count - 1) {
    NSLog(@"loadNextPage");
    [self loadNextPage];
  } else if (indexPath.row == 0) {
    NSLog(@"loadPreviousPage");
    if (dataArray.startIndex != 1) {
      [self loadPreviousPageOrRefresh];
    }
  }
}

- (void)loadPreviousPageOrRefresh {
  NSInteger start = dataArray.startIndex - pageCount;
  if (start < 1) {
    start = 1;
  }
  [self requestDataWithStart:start
                  withReqnum:pageCount
                   withOrder:dataArray.dataOrder
             withRefreshType:RefreshTypeHeaderRefresh];
}

- (void)loadNextPage {
  //检查：数据是否为空，如果为空，停止加载更多动画；返回（原因：double check）
  //检查：是否数据已经完整，如果是，停止加载更多动画；返回（原因：double
  // check）
  //检查：是否已经在加载更多，如果是，停止加载更多动画；返回（原因：防止发出重复的网络请求）
  if (isLoadMore || dataArray.dataComplete || [dataArray.array count] == 0) {
    [self performSelector:@selector(endRefreshLoading)
               withObject:nil
               afterDelay:0.5];
    return;
  }
  isLoadMore = YES;
  [self requestDataWithStart:dataArray.startIndex + [dataArray.array count]
                  withReqnum:pageCount
                   withOrder:dataArray.dataOrder
             withRefreshType:RefreshTypeLoaderMore];
}

- (void)endRefreshLoading {
  if (footerView) {
    footerView.lastUpdateTimeLabel.text = @"";
    [footerView endRefreshing];
  }
  if (headerView) {
    [headerView endRefreshing];
  }
}
#pragma mark 刷新
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {

  //刷新数量
  [self requestDataWithStart:1
                  withReqnum:pageCount
                   withOrder:self.tableHeaderOrder
             withRefreshType:RefreshTypeRefresh];
}
#pragma mark
#pragma mark 网络请求
- (void)requestDataWithStart:(NSInteger)start
                  withReqnum:(NSInteger)reqnum
                   withOrder:(DataListOrder)order
             withRefreshType:(RefreshType)refreshType {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  if (_stockListType == StockListTypeIndustryNotion ||
      _stockListType == StockListTypeStocksOfRecommnendType) {
    [self marketRequestLinks:urlPart
                        code:self.codeStr
                       start:start
                      reqnum:reqnum
                       order:order
             withRefreshType:refreshType];
  } else if (_stockListType == StockListTypeIndex) {
    [self marketIndexRequestList:urlPart withRefreshType:refreshType];
  } else {
    [self changeDataRequestListUrl:urlPart
                             start:start
                            reqnum:reqnum
                         withOrder:order
                       withRefresh:refreshType];
  }
}

///涨跌幅、振幅、换手、新股
- (void)changeDataRequestListUrl:(NSString *)urlstr
                           start:(NSInteger)start
                          reqnum:(NSInteger)reqnum
                       withOrder:(NSInteger)order
                     withRefresh:(RefreshType)refreshType {

  __weak MarketListViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindStockInfo:(MarketHomeTableData *)object
                      withStart:start
                      withOrder:order
                withRefreshType:refreshType];
    }
  };

  callback.onFailed = ^() {
    [weakSelf setOrderIndicatorFinished:weakSelf.tableHeaderOrder];
    [weakSelf setNoNetwork];
  };

  [MarketHomeTableData getmarketRequestLinks:urlstr
                                       start:start
                                      reqnum:reqnum
                                       order:order
                                withCallback:callback];
}

///涨跌幅、振幅、换手、新股
- (void)bindStockInfo:(MarketHomeTableData *)data
            withStart:(NSInteger)start
            withOrder:(NSInteger)order
      withRefreshType:(RefreshType)refreshType {

  BOOL valid = (start == 1); //合法刷新操作
  NSInteger size = [dataArray.array count];
  if (!valid) {
    //合法的定时刷新操作
    valid = dataArray.dataOrder == order && dataArray.startIndex == start;
  }

  if (!valid) {
    //合法的加载更多操作
    valid =
        dataArray.dataOrder == order && dataArray.startIndex + size == start;
  }

  if (!valid) {
    //合法的加载上一页的操作
    valid = dataArray.dataOrder == order &&
            dataArray.startIndex == start + pageCount;
  }
  if (!valid) {
    return;
  }

  [self setOrderIndicatorFinished:order];
  self.tableHeaderOrder = order;
  dataArray.dataOrder = order;
  //设置数据已经绑定
  dataArray.dataBinded = YES;
  isLoadMore = NO;

  if (refreshType == RefreshTypeRefresh) {
    [marketListtableView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                                    animated:NO];
  }

  if (dataArray.startIndex == start + pageCount &&
      refreshType == RefreshTypeHeaderRefresh) {
    NSIndexPath *path =
        [[marketListtableView indexPathsForVisibleRows] firstObject];
    NSInteger lastRow = path.row + pageCount;
    //合并数据
    NSMutableArray *array = [@[] mutableCopy];
    [array addObjectsFromArray:data.dataList];
    [array addObjectsFromArray:dataArray.array];
    [dataArray.array removeAllObjects];
    [dataArray.array addObjectsFromArray:array];
    //最后最多显示2页数据；
    NSInteger diff = [dataArray.array count] - 2 * pageCount;
    if (diff > 0) {
      [dataArray.array removeObjectsInRange:NSMakeRange(pageCount * 2, diff)];
      dataArray.startIndex = dataArray.startIndex - pageCount;
    }
    [marketListtableView
        scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
              atScrollPosition:UITableViewScrollPositionTop
                      animated:NO];
  } else if (start == 1) {
    //刷新操作需要移除数组中所有数据，且tableview回到头部
    dataArray.startIndex = 1;
    [dataArray.array removeAllObjects];
    [dataArray.array addObjectsFromArray:data.dataList];
  } else if (dataArray.startIndex + size == start) {

    NSIndexPath *path =
        [[marketListtableView indexPathsForVisibleRows] lastObject];
    NSInteger lastRow = path.row;

    //合并，最后最多显示2页数据；
    [dataArray.array addObjectsFromArray:data.dataList];
    if ([dataArray.array count] > 2 * pageCount) {
      [dataArray.array removeObjectsInRange:NSMakeRange(0, pageCount)];
      dataArray.startIndex = dataArray.startIndex + pageCount;
      lastRow = lastRow - pageCount;
    }

    [marketListtableView
        scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
              atScrollPosition:UITableViewScrollPositionBottom
                      animated:NO];
  } else if (dataArray.startIndex == start) {
    [dataArray.array removeAllObjects];
    [dataArray.array addObjectsFromArray:data.dataList];
  }

  //当返回数据为0，可视为数据已经全部加载完
  if ([data.dataList count] == 0) {
    dataArray.dataComplete = YES;
  } else {
    dataArray.dataComplete = NO;
  }

  if (dataArray.dataComplete) {
    //数据全部加载完，显示数据完成控件，且隐藏上拉加载控件
    marketListtableView.tableFooterView.hidden = NO;
    footerView.hidden = YES;
  } else {
    //数据未全部加载完，隐藏数据完成控件，且显示上拉加载控件
    marketListtableView.tableFooterView.hidden = YES;
    footerView.hidden = NO;
  }

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [_littleCattleView isCry:NO];
    marketListtableView.hidden = YES;
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    _littleCattleView.hidden = YES;
    marketListtableView.hidden = NO;
  }

  //重新加载数据
  [marketListtableView reloadData];
}

///大盘数据
- (void)marketIndexRequestList:(NSString *)urlstr
               withRefreshType:(RefreshType)refreshType {

  __weak MarketListViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindIndexListData:(MarketHomeTableData *)object
                    withRefreshType:refreshType];
    }
  };

  callback.onFailed = ^() {
    [weakSelf setNoNetwork];
  };

  [MarketHomeTableData getmarketIndexRequestList:urlstr withCallback:callback];
}

///大盘数据
- (void)bindIndexListData:(MarketHomeTableData *)data
          withRefreshType:(RefreshType)refreshType {

  //设置数据已经绑定
  dataArray.dataBinded = YES;
  dataArray.dataComplete = YES;
  isLoadMore = NO;

  [dataArray.array removeAllObjects];
  [dataArray.array addObjectsFromArray:data.dataList];

  if (dataArray.dataComplete) {
    //数据全部加载完，显示数据完成控件，且隐藏上拉加载控件
    marketListtableView.tableFooterView.hidden = NO;
  } else {
    //数据未全部加载完，隐藏数据完成控件，且显示上拉加载控件
    marketListtableView.tableFooterView.hidden = YES;
  }

  if (refreshType == RefreshTypeRefresh) {
    [marketListtableView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                                    animated:NO];
  }

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [_littleCattleView isCry:NO];
    marketListtableView.hidden = YES;
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    _littleCattleView.hidden = YES;
    marketListtableView.hidden = NO;
  }

  //重新加载数据
  [marketListtableView reloadData];
}

///设定完成时的排序标志
- (void)setOrderIndicatorFinished:(DataListOrder)order {
  if ([tableHeader.sortingIndicatorView isAnimating]) {
    [tableHeader.sortingIndicatorView stopAnimating];
  }
  if (order == DataListOrderAsc) {
    tableHeader.sortOrderImageView.image = [UIImage imageNamed:@"排序_上"];
  } else if (order == DataListOrderDesc) {
    tableHeader.sortOrderImageView.image = [UIImage imageNamed:@"排序_下"];
  }
  tableHeader.sortOrderImageView.hidden = NO;
  tableHeader.sortButton.hidden = NO;
}

///指定行业或者概念下的股票列表
- (void)marketRequestLinks:(NSString *)urlstr
                      code:(NSString *)code
                     start:(NSInteger)start
                    reqnum:(NSInteger)reqnum
                     order:(DataListOrder)order
           withRefreshType:(RefreshType)refreshType {

  __weak MarketListViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    MarketListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindStockListInIndustryNotion:(MarketHomeTableData *)object
                                      withStart:start
                                      withOrder:order
                                withRefreshType:refreshType];
    }
  };

  callback.onFailed = ^() {
    //恢复排序按钮
    [weakSelf setOrderIndicatorFinished:weakSelf.tableHeaderOrder];
    [weakSelf setNoNetwork];
  };

  [MarketHomeTableData getmarketRequestLinks:urlstr
                                        code:code
                                       start:start
                                      reqnum:reqnum
                                       order:order
                                withCallback:callback];
}
///指定行业或者概念下的股票列表
- (void)bindStockListInIndustryNotion:(MarketHomeTableData *)data
                            withStart:(NSInteger)start
                            withOrder:(DataListOrder)order
                      withRefreshType:(RefreshType)refreshType {
  NSInteger size = [dataArray.array count];

  BOOL valid = (start == 1); //合法的刷新操作
  if (!valid) {
    //合法的定时刷新操作
    valid = dataArray.dataOrder == order && dataArray.startIndex == start;
  }

  if (!valid) {
    //合法的加载更多操作
    valid =
        dataArray.dataOrder == order && dataArray.startIndex + size == start;
  }
  if (!valid) {
    return;
  }

  [self setOrderIndicatorFinished:order];
  self.tableHeaderOrder = order;
  //设置数据已经绑定
  dataArray.dataBinded = YES;
  dataArray.dataOrder = order;
  isLoadMore = NO;

  if (refreshType == RefreshTypeRefresh) {
    [marketListtableView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                                    animated:NO];
  }

  if (start == 1) {
    //刷新操作需要移除数组中所有数据，且tableview回到头部
    dataArray.startIndex = 1;
    [dataArray.array removeAllObjects];
    [dataArray.array addObjectsFromArray:data.dataList];
  } else if (dataArray.startIndex + size == start) {
    //加载更多操作
    [dataArray.array addObjectsFromArray:data.dataList];
  } else if (dataArray.startIndex == start) {
    [dataArray.array removeAllObjects];
    [dataArray.array addObjectsFromArray:data.dataList];
  }

  //当返回数据为0，可视为数据已经全部加载完
  if ([data.dataList count] == 0) {
    dataArray.dataComplete = YES;
  } else {
    dataArray.dataComplete = NO;
  }

  if (dataArray.dataComplete) {
    //数据全部加载完，显示数据完成控件，且隐藏上拉加载控件
    marketListtableView.tableFooterView.hidden = NO;
    footerView.hidden = YES;
  } else {
    //数据未全部加载完，隐藏数据完成控件，且显示上拉加载控件
    marketListtableView.tableFooterView.hidden = YES;
    footerView.hidden = NO;
  }

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [_littleCattleView isCry:NO];
    marketListtableView.hidden = YES;
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    _littleCattleView.hidden = YES;
    marketListtableView.hidden = NO;
  }

  //重新加载数据
  [marketListtableView reloadData];
}

//暂无加载更多
- (UIView *)noDataShowFootView {
  if (noDataFootView == nil) {
    noDataFootView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  }
  noDataFootView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //白线
  UIView *whiteLine =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  whiteLine.backgroundColor = [UIColor whiteColor];
  [noDataFootView addSubview:whiteLine];
  UILabel *noDataLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 40)];
  noDataLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [noDataFootView addSubview:noDataLabel];
  //按钮
  UIButton *noDataFootButton = [UIButton buttonWithType:UIButtonTypeCustom];
  noDataFootButton.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 40);
  [noDataFootButton setTitleColor:[Globle colorFromHexRGB:@"939393"]
                         forState:UIControlStateNormal];
  noDataFootButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [noDataFootButton setTitle:@"暂无更多数据" forState:UIControlStateNormal];

  noDataFootButton.backgroundColor = [UIColor clearColor];
  [noDataFootView addSubview:noDataFootButton];
  return noDataFootView;
}
#pragma mark
#pragma mark 无网络

//创建联网指示器
- (void)resetIndicatorView {
  _indicatorView.frame =
      CGRectMake(self.view.bounds.size.width - 85,
                 _topToolBar.bounds.size.height - 45, 40, 45);
}
//创建搜索按钮视图
- (void)creatSearchButtonView {
  UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  searchBtn.frame = CGRectMake(self.view.bounds.size.width - 40,
                               _topToolBar.bounds.size.height - 45, 40, 45);
  [searchBtn setImage:[UIImage imageNamed:@"搜索小图标"]
             forState:UIControlStateNormal];
  [searchBtn setImage:[UIImage imageNamed:@"搜索小图标"]
             forState:UIControlStateHighlighted];
  [searchBtn
      setBackgroundImage:[UIImage imageNamed:@"导航按钮按下态效果.png"]
                forState:UIControlStateHighlighted];
  [searchBtn addTarget:self
                action:@selector(searchButtonPress:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:searchBtn];
}
- (void)searchButtonPress:(UIButton *)btn {
  OnStockSelected callback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        self.page = searchSkip;
        [TrendViewController showDetailWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMatchId:@"1"];

      };
  SelectStocksViewController *selectStocksVC =
      [[SelectStocksViewController alloc] initStartPageType:StockmarketPage
                                               withCallBack:callback];
  [AppDelegate pushViewControllerFromRight:selectStocksVC];
}
#pragma mark
#pragma mark 功能函数
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
  if (dataArray.dataBinded == YES) {
    _littleCattleView.hidden = YES;
  } else {
    [_littleCattleView isCry:YES];
  }
}
- (void)stopLoading {
  [_indicatorView stopAnimating];
  [self endRefreshLoading];
}

#pragma mark
#pragma mark 定时器相关函数
//创建定时器
- (void)initTrendTimer {
  //得到刷新数据
  NSInteger refreshTime = [SimuUtil getCorRefreshTime];
  NSLog(@"self.refreshTime:%ld", (long)refreshTime);
  if (refreshTime == 0)
    return;
  timeinterval = refreshTime;
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
    }
  }
  iKLTimer =
      [NSTimer scheduledTimerWithTimeInterval:timeinterval
                                       target:self
                                     selector:@selector(KLineHandleTimer:)
                                     userInfo:nil
                                      repeats:YES];
}
//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (timeinterval != [SimuUtil getCorRefreshTime]) {
    [self stopMyTimer];
    [self initTrendTimer];
  }
  if (iKLTimer == theTimer) {
    ///新股发行不需要定时刷新
    if (_stockListType == StockListTypeIPO) {
      return;
    }

    //如果无网络，则什么也不做；
    if (![SimuUtil isExistNetwork]) {
      return;
    }
    //如果当前交易所状态为闭市，则什么也不做
    if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
      return;
    }
    if ([_indicatorView isAnimating])
      return;

    //刷新当前数据
    NSInteger count = [dataArray.array count];
    if (count == 0) {
      [self requestDataWithStart:1
                      withReqnum:pageCount
                       withOrder:self.tableHeaderOrder
                 withRefreshType:RefreshTypeTimerRefresh];
    } else {
      [self requestDataWithStart:dataArray.startIndex
                      withReqnum:count
                       withOrder:dataArray.dataOrder
                 withRefreshType:RefreshTypeTimerRefresh];
    }
  }
}
//定时器停止
- (void)stopMyTimer {
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
      iKLTimer = nil;
    }
  }
}

#pragma mark 定时器通知
- (void)marketListMethods:(NSNotification *) not{
  [[NSNotificationCenter defaultCenter] postNotificationName:MARKET_HOME_TIMER
                                                      object:@"LIST"];
  [self stopMyTimer];
  [self initTrendTimer];
}
#pragma mark
#pragma mark 子视图控制器创建和使用
- (void)showStockList:(NSMutableArray *)stockArray index:(NSInteger)index {
  NSMutableDictionary *dic = stockArray[index];
  NSString *stockCode = [NSString stringWithFormat:@"%@", dic[@"code"]];
  NSString *stockName = [SimuUtil changeIDtoStr:dic[@"name"]];
  NSString *firstType = [NSString stringWithFormat:@"%@", dic[@"firstType"]];

  [TrendViewController showDetailWithStockCode:stockCode
                                 withStockName:stockName
                                 withFirstType:firstType
                                   withMatchId:@"1"
                                withStockArray:stockArray
                                     withIndex:index];
}

//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  [self stopMyTimer];
  [super leftButtonPress];
}

@end
