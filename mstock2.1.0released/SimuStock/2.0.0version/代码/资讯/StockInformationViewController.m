//
//  StockInformationViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockInformationViewController.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "StockInformationWebViewController.h"
#import "ChannelNewsItemTableViewCell.h"
#import "StockUtil.h"
#import "TrendViewController.h"

@implementation SubPageStatus
@end

@implementation StockInformationViewController

- (void)_initStockCode:(NSString *)code titleName:(NSString *)titleName type:(NSString *)type {
  self.codeStr = code;
  self.titleName = titleName;
  self.firstType = type;

  for (SubPageStatus *status in pageStatus) {
    status.tableViewOffsetY = 0;
    [status.dataArray.array removeAllObjects];
    status.dataArray.dataBinded = NO;
    status.dataArray.dataComplete = NO;
    status.isLoadMore = NO;
  }
}

- (id)initWithCode:(NSString *)code
              name:(NSString *)titleName
        controller:(TrendViewController *)trendVC
         firstType:(NSString *)type {
  if (self = [super init]) {
    pageStatus = [[NSMutableArray alloc] init];
    pageNames = @[ @"newslist", @"bullist", @"indulist" ];
    self.trendVC = trendVC;
    for (int i = 0; i < 3; i++) {
      SubPageStatus *status = [[SubPageStatus alloc] init];
      status.dataArray = [[DataArray alloc] init];
      [pageStatus addObject:status];
    }

    [self _initStockCode:code titleName:titleName type:type];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  newstableView.delegate = nil;
  newstableView.dataSource = nil;

  if (headerView) {
    [headerView free];
    headerView.scrollView = nil;
  }
}
- (void)viewDidLoad {
  [super viewDidLoad];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    isvc_stateBarHeight = 20;
  } else {
    isvc_stateBarHeight = 0;
  }

  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  self.markInt = 0;

  [self createSegmentedButtonView];

  [self createTableView];
  [self callLadIndicator:YES];

  CGRect tempFrame = self.view.bounds;
  tempFrame.origin.y -= 100;
  _littleCattleView =
      [[LittleCattleView alloc] initWithFrame:tempFrame information:@"暂" @"无数据"];
  [self.view addSubview:_littleCattleView];
  [self refresh];
  //  [self initNewsBulIndulistDada:0];
}

///将@“新闻，公告，行业”三个界面的数据都初始化了
- (void)initNewsBulIndulistDada:(int)lastObject {
  for (int i = 2; i >= 0; i--) {
    if (i != lastObject) {
      [self buttonSwitchMethod:i];
    }
  }
  if (lastObject >= 0 && lastObject <= 2) {
    [self buttonSwitchMethod:lastObject];
  }
}

//分段按钮
- (void)createSegmentedButtonView {
  BOOL isDapa = [StockUtil isMarketIndex:self.firstType];
  if (isDapa) {
    borderView.hidden = YES;
    return;
  } else {
    if (borderView) {
      borderView.hidden = NO;
      [borderView removeFromSuperview];
    }

    //边框
    borderView = [[UIView alloc]
        initWithFrame:CGRectMake(15.0, 13.0 / 2, self.view.bounds.size.width - 30.0, 64.0 / 2)];

    borderView.backgroundColor = [Globle colorFromHexRGB:@"#086dae"];
    borderView.clipsToBounds = YES;
    [self.view addSubview:borderView];

    buttonView = [[UIView alloc]
        initWithFrame:CGRectMake(0.5, 0.5, borderView.bounds.size.width - 1.0, 31.0)];

    buttonView.backgroundColor = [UIColor whiteColor];
    [borderView addSubview:buttonView];

    residentView =
        [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, (buttonView.bounds.size.width - 1.0) / 3,
                                                 buttonView.bounds.size.height)];
    if ([StockUtil isFund:self.firstType]) {
      CGRect residentViewFrame = CGRectMake(0.0, 0.0, (buttonView.bounds.size.width - 1.0) / 2,
                                            buttonView.bounds.size.height);
      residentView.frame = residentViewFrame;
    }
    residentView.backgroundColor = [Globle colorFromHexRGB:@"#086dae"];
    [buttonView addSubview:residentView];

    NSArray *nameArr = @[ @"新闻", @"公告", @"行业" ];

    //如果是基金则不显示“行业”
    if ([StockUtil isFund:self.firstType]) {
      nameArr = @[ @"新闻", @"公告" ];
    }

    CGFloat width = (buttonView.bounds.size.width - 1.0f) / [nameArr count];
    for (int i = 0; i < [nameArr count]; i++) {
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      btn.backgroundColor = [UIColor clearColor];
      btn.frame = CGRectMake(i * width + i * 0.5, 0.0, width, buttonView.bounds.size.height);

      [btn setTitle:nameArr[i] forState:UIControlStateNormal];
      [btn setTitle:nameArr[i] forState:UIControlStateHighlighted];
      [btn setTitleColor:[Globle colorFromHexRGB:@"#086dae"] forState:UIControlStateNormal];
      btn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
      btn.tag = 3500 + i;
      [btn setOnButtonPressedHandler:^{
        [self buttonSwitchMethod:i];
      }];
      [buttonView addSubview:btn];
      if (i != 0) {
        UIView *lineView = [[UIView alloc]
            initWithFrame:CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 3 + (i - 1) * 0.5,
                                     0.0, 0.5, buttonView.bounds.size.height)];

        if ([StockUtil isFund:self.firstType]) {
          CGRect lineViewFrame =
              CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 2 + (i - 1) * 0.5, 0.0, 0.5,
                         buttonView.bounds.size.height);
          lineView.frame = lineViewFrame;
        }

        lineView.backgroundColor = [Globle colorFromHexRGB:@"#086dae"];
        [buttonView addSubview:lineView];
      } else {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      }
    }
  }
}

#pragma mark - 切换按钮时触发方法
- (void)buttonSwitchMethod:(int)index {

  //保存当前的页面状态
  SubPageStatus *oldPage = pageStatus[self.markInt];
  oldPage.tableViewOffsetY = newstableView.contentOffset.y;

  [self buttonStatusUpdateTag:index];

  self.markInt = index;
  [self pullDownTimeDisplay:pageNames[self.markInt]];

  SubPageStatus *newPage = pageStatus[self.markInt];
  DataArray *data = newPage.dataArray;
  if (data.dataBinded) {
    if ([data.array count] > 0) {
      newstableView.hidden = NO;
      [newstableView
          scrollRectToVisible:CGRectMake(0, newPage.tableViewOffsetY, self.view.bounds.size.width,
                                         newstableView.bounds.size.height)
                     animated:NO];

      _littleCattleView.hidden = YES;
      if (data.dataComplete) {
        newstableView.tableFooterView.hidden = NO;
      } else {
        newstableView.tableFooterView.hidden = YES;
      }
    } else {
      [_littleCattleView isCry:NO];
      newstableView.tableFooterView.hidden = YES;
    }
  } else {
    newstableView.tableFooterView.hidden = YES;
    [self requestNewsLinksWithType:self.markInt code:self.codeStr fromId:@"0" limit:@"20"];
  }

  [newstableView reloadData];
}

//按钮状态更新
- (void)buttonStatusUpdateTag:(NSInteger)buttonIndex {
  if ([StockUtil isFund:self.firstType]) {
    for (int i = 0; i < 2; i++) {
      UIButton *btn = (UIButton *)[buttonView viewWithTag:i + 3500];
      if (i == buttonIndex) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        residentView.frame = CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 2 + i * 0.5, 0.0,
                                        (buttonView.bounds.size.width - 1.0) / 2 + 0.5,
                                        buttonView.bounds.size.height);
      } else {
        [btn setTitleColor:[Globle colorFromHexRGB:@"#086dae"] forState:UIControlStateNormal];
      }
    }
  } else {
    for (int i = 0; i < 3; i++) {
      UIButton *btn = (UIButton *)[buttonView viewWithTag:i + 3500];
      if (i == buttonIndex) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        residentView.frame =
            CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 3 + i * 0.5, 0.0,
                       (buttonView.bounds.size.width - 1.0) / 3, buttonView.bounds.size.height);
      } else {
        [btn setTitleColor:[Globle colorFromHexRGB:@"#086dae"] forState:UIControlStateNormal];
      }
    }
  }
}
- (void)createTableView {
  if (newstableView) {
    if ([StockUtil isMarketIndex:self.firstType]) {
      newstableView.frame =
          CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
    } else {
      newstableView.frame =
          CGRectMake(0.0, 38.5, self.view.bounds.size.width, self.view.bounds.size.height - 38.5);
    }
    return;
  } else {
    //创建表格视图
    newstableView =
        [[UITableView alloc] initWithFrame:CGRectMake(0.0, 38.5, self.view.bounds.size.width,
                                                      self.view.bounds.size.height - 38.5 - 45 * 2 -
                                                          34.0 - isvc_stateBarHeight)
                                     style:UITableViewStylePlain];
    if ([StockUtil isMarketIndex:self.firstType]) {
      newstableView.frame =
          CGRectMake(0.0, 0.0, self.view.bounds.size.width,
                     self.view.bounds.size.height - 45 * 2 - 34.0 - isvc_stateBarHeight);
    }
    NSLog(@"高度.:%f,%f", newstableView.height, self.view.bounds.size.height);
    newstableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    newstableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    newstableView.showsVerticalScrollIndicator = YES;
    newstableView.delegate = self;
    newstableView.dataSource = self;
    [self.view addSubview:newstableView];

    headerView = [[MJRefreshHeaderView alloc] initWithPage:pageNames[0]];
    headerView.delegate = self;
    headerView.scrollView = newstableView;
    [headerView singleRow];

    [newstableView setTableFooterView:[self noDataShowFootView]];
    newstableView.tableFooterView.hidden = YES;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  SubPageStatus *page = pageStatus[self.markInt];
  return [page.dataArray.array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 51.5f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"ChannelNewsItemTableViewCell";
  ChannelNewsItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#e8e8e8"];
  }
  SubPageStatus *page = pageStatus[self.markInt];
  StockNewsData *newsData = page.dataArray.array[indexPath.row];
  [cell bindStockNewsData:newsData withMark:self.markInt];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  NSString *titleStr = @"";
  if (self.markInt == 0) {
    titleStr = [NSString stringWithFormat:@"%@-新闻", self.titleName];
  } else if (self.markInt == 1) {
    titleStr = [NSString stringWithFormat:@"%@-公告", self.titleName];
  } else {
    titleStr = [NSString stringWithFormat:@"%@-行业", self.titleName];
  }
  SubPageStatus *page = pageStatus[self.markInt];
  StockNewsData *newsData = page.dataArray.array[indexPath.row];
  StockInformationWebViewController *StockInformationWebVC =
      [[StockInformationWebViewController alloc] init];
  StockInformationWebVC.textUrl = newsData.newsUrl;
  StockInformationWebVC.textName = titleStr;
  StockInformationWebVC.infoTitle = newsData.newsTitle;
  [AppDelegate pushViewControllerFromRight:StockInformationWebVC];
}

#pragma mark - scrollView 代理方法
///自动上拉刷新的实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint contentOffsetPoint = scrollView.contentOffset;

  if (contentOffsetPoint.y >= newstableView.contentSize.height - newstableView.frame.size.height -
                                  103.0) //拉倒倒数第二个表格时就加载，不然最后一个太晚了
  {
    SubPageStatus *page = pageStatus[self.markInt];
    if (page.dataArray.dataComplete || page.isLoadMore) {
      return;
    }
    if ([page.dataArray.array count] > 0) {
      page.isLoadMore = YES;
      [self callLadIndicator:YES];
      StockNewsData *newsData = [page.dataArray.array lastObject];
      [self requestNewsLinksWithType:self.markInt
                                code:self.codeStr
                              fromId:newsData.newsID
                               limit:@"20"];
    }
  }
}

- (void)setNoNetworkForTabIndex:(NSInteger)tabIndex {
  if (tabIndex == self.markInt) {
    [NewShowLabel showNoNetworkTip]; //显示无网络提示
    SubPageStatus *page = pageStatus[self.markInt];
    if (page.dataArray.dataBinded) {
      _littleCattleView.hidden = YES; //数据已经绑定（==显示），隐藏小牛
    } else {
      [_littleCattleView isCry:YES]; //数据未绑定（==未显示），显示哭泣的无网络小牛
    }
  }
}

- (void)stopLoading {
  [self callLadIndicator:NO]; //停止菊花
  [self endRefreshLoading];   //停止并隐藏上拉加载更多控件
}

//网络请求
- (void)requestNewsLinksWithType:(NSInteger)type
                            code:(NSString *)code
                          fromId:(NSString *)fromId
                           limit:(NSString *)limit {

  [self callLadIndicator:YES];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetworkForTabIndex:type];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockInformationViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockInformationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.markInt == type) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockInformationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindNewsList:(StockNewsList *)obj withType:type withFromId:fromId];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetworkForTabIndex:type];
  };

  [StockNewsList requestNewsListWithType:type
                           withStockCode:code
                              withFromId:fromId
                               withLimit:limit
                            withCallback:callback];
}

- (void)bindNewsList:(StockNewsList *)obj withType:(NSInteger)type withFromId:(NSString *)fromId {

  //忽略过时的请求数据，例如：
  // 1. 用户点击刷新按钮，之后上拉加载更多，
  // 2.
  // 如果刷新请求先返回，上拉加载更多请求后返回，则上拉加载更多请求的数据应该被忽略掉
  //当前页面的判断方法是：检查请求的起始id是否是数组的最后一个元素的id
  SubPageStatus *page = pageStatus[type];
  DataArray *dataArray = page.dataArray;
  if (![@"0" isEqualToString:fromId]) {

    NSString *lastId = ((StockNewsData *)[dataArray.array lastObject]).newsID;
    if (![fromId isEqualToString:lastId]) {
      return;
    }
  }

  //设置数据已经绑定
  dataArray.dataBinded = YES;
  page.isLoadMore = NO;

  //刷新操作需要移除数组中所有数据，且tableview回到头部
  if ([@"0" isEqualToString:fromId]) {
    [dataArray.array removeAllObjects];
    page.tableViewOffsetY = 0;
    [newstableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  }

  //添加最新数据
  [dataArray.array addObjectsFromArray:obj.dataArray];

  if (type != self.markInt) {
    return;
  }

  //当返回数据为0，可视为数据已经全部加载完
  if ([obj.dataArray count] == 0) {
    dataArray.dataComplete = YES;
  } else {
    dataArray.dataComplete = NO;
  }

  if (dataArray.dataComplete) {
    //数据全部加载完，显示数据完成控件，且隐藏上拉加载控件
    newstableView.tableFooterView.hidden = NO;
    //    footerView.hidden = YES;
  } else {
    //数据未全部加载完，隐藏数据完成控件，且显示上拉加载控件
    newstableView.tableFooterView.hidden = YES;
    //    footerView.hidden = NO;
  }

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [_littleCattleView isCry:NO];
    newstableView.hidden = YES;
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    _littleCattleView.hidden = YES;
    newstableView.hidden = NO;
  }

  //重新加载数据
  [newstableView reloadData];
}

//暂无加载更多
- (UIView *)noDataShowFootView {
  if (noDataFootView == nil) {
    noDataFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  }
  noDataFootView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //白线
  UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  whiteLine.backgroundColor = [UIColor whiteColor];
  [noDataFootView addSubview:whiteLine];
  UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 40)];
  noDataLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [noDataFootView addSubview:noDataLabel];
  //按钮
  UIButton *noDataFootButton = [UIButton buttonWithType:UIButtonTypeCustom];
  noDataFootButton.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 40);
  [noDataFootButton setTitleColor:[Globle colorFromHexRGB:@"939393"] forState:UIControlStateNormal];
  noDataFootButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [noDataFootButton setTitle:@"暂无更多数据" forState:UIControlStateNormal];

  noDataFootButton.backgroundColor = [UIColor clearColor];
  [noDataFootView addSubview:noDataFootButton];
  return noDataFootView;
}

#pragma mark
#pragma mark 代理方法------------------进入刷新状态就会调用---------------
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [self endRefreshLoading];
    [self performSelector:@selector(endRefreshLoading) withObject:nil afterDelay:0.5];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (refreshView == headerView) {
    [self refresh];
  }
}

- (void)endRefreshLoading {
  if (headerView) {
    [headerView endRefreshing];
  }
}
//下拉时间显示
- (void)pullDownTimeDisplay:(NSString *)key {
  headerView.pageName = key;
  headerView.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  // 设置时间
  [headerView updateTimeLabel];
}
#pragma mark 刷新
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refresh {
  [self requestNewsLinksWithType:self.markInt code:self.codeStr fromId:@"0" limit:@"20"];
}

//调用加载圈
- (void)callLadIndicator:(BOOL)isRefresh {
  [self.trendVC refreshData:isRefresh];
}

//调用加载圈
- (void)interfaceSwitchingTriggerLoadIndicator {
  [self callLadIndicator:YES];
}

//清楚tableview数据
- (void)clearTableViewData {
  borderView.hidden = YES;

  for (SubPageStatus *status in pageStatus) {
    status.tableViewOffsetY = 0;
    [status.dataArray.array removeAllObjects];
    status.dataArray.dataBinded = NO;
    status.dataArray.dataComplete = NO;
    status.isLoadMore = NO;
  }
  [newstableView reloadData];
}

//页面切换刷新数据
- (void)stockInformationCode:(NSString *)code
                        name:(NSString *)titleName
                   firstType:(NSString *)type {
  if (self.codeStr && [self.codeStr isEqualToString:code]) {
    return;
  }

  [self _initStockCode:code titleName:titleName type:type];

  [self buttonStatusUpdateTag:self.markInt];

  //  ///是否保留，新闻，公告，行业三个，
  [self createSegmentedButtonView];

  [self createTableView];

  [newstableView reloadData];

  _littleCattleView.hidden = YES;
  noDataFootView.hidden = YES;
  [self pullDownTimeDisplay:pageNames[0]];
  //  //网络请求
  [self refresh];
  //  ///将@“新闻，公告，行业”三个界面的数据都初始化了
  //  [self initNewsBulIndulistDada:(int)self.markInt];
}

@end
