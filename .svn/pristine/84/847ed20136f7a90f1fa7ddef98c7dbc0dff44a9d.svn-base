//
//  StockBarsViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockBarsViewController.h"
#import "WBDetailsViewController.h"
#import "HomepageViewController.h"
#import "StockBarDetailViewController.h"
#import "StockUtil.h"
#import "MyStockBarsCell.h"
#import "HotRecommendListData.h"
#import "MyStockBarListData.h"
#import "HotStockBarListData.h"
#import "HotStockTopicCell.h"
#import "HotStockTopicListData.h"
#import "HotStockBarViewController.h"
#import "HotStockTopicViewController.h"
#import "TrendViewController.h"
#import "WBCoreDataUtil.h"
#import "FirstDistributeViewController.h"
#import "GameWebViewController.h"
#import "YouguuSchema.h"

#import "FriendChatStockTableVC.h"
#import "HotestChatStockTableVC.h"

#define TextIntervalLength 160
@implementation StockBarsViewController {

  ///股吧聊股总数变化通知
  __weak id observerBarWeiboSum;
  ///加入、退出股吧通知
  __weak id observerMyBarsChanged;
}

- (void)dealloc {
  ///停止定时器
  [self stopMyTimer];

  [[NSNotificationCenter defaultCenter] removeObserver:observerBarWeiboSum];
  [[NSNotificationCenter defaultCenter] removeObserver:observerMyBarsChanged];
}

- (id)initGetMainObject:(SimuMainViewController *)controller {
  if (self = [super init]) {
    _simuMainVC = controller;
    __weak StockBarsViewController *weakSelf = self;
    _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
    _loginLogoutNotification.onLoginLogout = ^{
      [weakSelf onLogonLogout];
    };
  }
  return self;
}

- (void)onLogonLogout {
  if ([SimuUtil isLogined]) {
    NSLog(@"登录成功，刷新聊股吧");
    //刷新聊股吧数据
    _currentPage = 1;
    [self refreshButtonPressDown];
    //登录后重刷热门列表赞状态
    [_hotestWeiboListViewController refreshButtonPressDown];
  } else {
    NSLog(@"登出，清空好友圈");
    [_friendWeiboListViewController.dataArray reset];
    [_friendWeiboListViewController.tableView reloadData];
    [_hotestWeiboListViewController.dataArray reset];
    [_hotestWeiboListViewController.tableView reloadData];
    [_topToolBarView changTapToIndex:1];
    [self changeToIndex:1]; //切换到聊股吧
  }
}

- (void)enableScrollsToTop:(BOOL)scrollsToTop {
  if (scrollsToTop) {
    [self enableScrollsToTopWithPageIndex:_currentPage];
  } else {
    _scrollView.scrollsToTop = NO;
    _hotestWeiboListViewController.tableView.scrollsToTop = NO;
    _friendWeiboListViewController.tableView.scrollsToTop = NO;
    _stockBarsTableView.scrollsToTop = NO;
  }
}

- (void)viewDidLoad {

  [super viewDidLoad];

  //初始化成员变量
  [self initMemberVariables];
  //设定选择工具栏
  [self createTopToolBarView];
  //创建表格
  [self createScrollAndTableViews];
  [self addObservers];
  [self refreshCurrentPage];

  if ([SimuUtil isLogined]) {
    _currentPage = 0;
    [_topToolBarView changTapToIndex:0]; //切换到最热
  } else {
    _currentPage = 1;                    //指定刷聊股吧
    [_topToolBarView changTapToIndex:1]; //切换到聊股吧
  }

  [self refreshButtonPressDown];
}

//创建比赛成功delegate，刷新列表
- (void)refreshCurrentPage {
  //顶部广告栏
  [self topBillboard];
}

#pragma mark - 顶部广告栏
- (void)topBillboard {
  advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeStockBar];
  advViewVC.delegate = self;
  advViewVC.view.userInteractionEnabled = YES;
  [_hotestWeiboListViewController addChildViewController:advViewVC];
  advViewVC.view.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  [advViewVC requestImageAdvertiseList];
}

#pragma mark
#pragma mark------GameAdvertisingDelegate-------

//判断有没有广告页
- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg {
  if (AdBool) {
    CGFloat factor = WIDTH_OF_SCREEN / 320;
    advViewVC.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, stockBarAdvHeight * factor);
    advViewVC.view.userInteractionEnabled = YES;
    _hotestWeiboListViewController.tableView.tableHeaderView = advViewVC.view;
    advViewVC.view.userInteractionEnabled = YES;
    _hotestWeiboListViewController.tableView.tableHeaderView.backgroundColor =
        [Globle colorFromHexRGB:@"#efefef"];
  } else {
    [advViewVC.view removeFromSuperview];
    _stockBarsTableView.tableHeaderView = nil;
  }
}

- (void)addObservers {

  __weak UITableView *weakTableView = _stockBarsTableView;
  __weak NSMutableArray *dataArray = _hotStockTopicList;
  observerBarWeiboSum =
      [[NSNotificationCenter defaultCenter] addObserverForName:StockBarWeiboSumChangeNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *notif) {
                                                      NSDictionary *userInfo = [notif userInfo];
                                                      NSString *stockCode = userInfo[@"stockCode"];
                                                      if (stockCode) {
                                                        for (HotStockTopicData *stockTopicData in dataArray) {
                                                          if ([stockTopicData.stockCode isEqualToString:stockCode]) {
                                                            NSInteger post =
                                                                stockTopicData.postNum.integerValue +
                                                                [userInfo[@"operation"] intValue];
                                                            stockTopicData.postNum = @(post);
                                                            [weakTableView reloadData];
                                                            break;
                                                          }
                                                        }
                                                      }
                                                    }];

  observerMyBarsChanged =
      [[NSNotificationCenter defaultCenter] addObserverForName:MyStockBarsChangeNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *note) {
                                                      _requestFinishedCount = 3;
                                                      //请求我的股吧列表数据
                                                      [self requestMyStockBarListData];
                                                      //请求热门股聊吧，由于需要剔除我的股吧里重复的数据，所以请求在我的股吧绑定完数据之后
                                                    }];
}

#pragma mark - 初始化调用
- (void)initMemberVariables {
  _myBarsList = [[DataArray alloc] init];
  _themeBarsList = [[NSMutableArray alloc] initWithCapacity:0];
  _masterBarsList = [[NSMutableArray alloc] initWithCapacity:0];
  _hotStockTopicList = [[NSMutableArray alloc] initWithCapacity:0];

  _tweetList = [[DataArray alloc] init];
  _paomaButtons = [[NSMutableArray alloc] initWithCapacity:0];
}

#pragma mark - 发表按钮
- (void)publishButtonClick {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    FirstDistributeViewController *distriViewController =
        [[FirstDistributeViewController alloc] initWithCallBack:^(TweetListItem *item) {
          //更新好友圈假数据
          [_friendWeiboListViewController reloadInputViews];
          [_friendWeiboListViewController.dataArray.array insertObject:item atIndex:0];
          _friendWeiboListViewController.dataArray.dataBinded = YES;
          _friendWeiboListViewController.littleCattleView.hidden = YES;
          _friendWeiboListViewController.tableView.hidden = NO;
          [_friendWeiboListViewController.tableView setTableFooterView:nil];
          _friendWeiboListViewController.dataArray.dataComplete = NO;
          _friendWeiboListViewController.footerView.hidden = _friendWeiboListViewController.dataArray.dataComplete;
          [_friendWeiboListViewController.tableView reloadData];
        }];
    [AppDelegate pushViewControllerFromRight:distriViewController];
  }];
}

#pragma mark - 创建顶部切换按钮
- (void)createTopToolBarView {
  _topToolBarView = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEWCONTROLLER, TOP_TABBAR_HEIGHT)
                                                DataArray:@[ @"最热", @"聊股吧", @"好友圈" ]
                                      withInitButtonIndex:1];
  _topToolBarView.delegate = self;
  [self.view addSubview:_topToolBarView];
}

- (void)enableScrollsToTopWithPageIndex:(NSInteger)index {
  _scrollView.scrollsToTop = NO;
  if (index == 0) {
    _hotestWeiboListViewController.tableView.scrollsToTop = YES;
    _stockBarsTableView.scrollsToTop = NO;
    _friendWeiboListViewController.tableView.scrollsToTop = NO;

  } else if (index == 1) {
    _hotestWeiboListViewController.tableView.scrollsToTop = NO;
    _stockBarsTableView.scrollsToTop = YES;
    _friendWeiboListViewController.tableView.scrollsToTop = NO;

  } else {
    _hotestWeiboListViewController.tableView.scrollsToTop = NO;
    _stockBarsTableView.scrollsToTop = NO;
    _friendWeiboListViewController.tableView.scrollsToTop = YES;
  }
}

#pragma mark - -代理方法-
- (void)changeToIndex:(NSInteger)index {
  _currentPage = index;
  [self enableScrollsToTopWithPageIndex:_currentPage];
  //好友圈
  if (index == 0) {
    //最热
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (!_hotestWeiboListViewController.dataArray.dataBinded) {
      [_hotestWeiboListViewController refreshButtonPressDown];
    }
  } else if (index == 1) {
    [_scrollView setContentOffset:CGPointMake(WIDTH_OF_VIEWCONTROLLER, 0) animated:YES];
    if (!_isStockBarBinded) {
      [self refreshButtonPressDown];
    }
    //好友圈
  } else {
    [_scrollView setContentOffset:CGPointMake(WIDTH_OF_VIEWCONTROLLER * 2, 0) animated:YES];
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      ///好友圈跑马灯数据请求
      if (!_tweetList.dataBinded) {
        [self requestHotRecommendData];
      }
      if (!_friendWeiboListViewController.dataArray.dataBinded) {
        [_friendWeiboListViewController refreshButtonPressDown];
      }
    } notLogin:^{
      [_topToolBarView changTapToIndex:1];
    }];
  }
}

#pragma mark - 创建scrollView和tableView
- (void)createScrollAndTableViews {

  //创建承载滑动视图
  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, WIDTH_OF_VIEWCONTROLLER,
                                                     HEIGHT_OF_VIEWCONTROLLER - HEIGHT_OF_STATUS_AND_NAVIGATION -
                                                         HEIGHT_OF_TABBAR - TOP_TABBAR_HEIGHT)];
  _scrollView.contentSize = CGSizeMake(WIDTH_OF_VIEWCONTROLLER * 3, _scrollView.bounds.size.height);
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.contentOffset = CGPointMake(WIDTH_OF_VIEWCONTROLLER, 0); //默认显示聊股吧
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.bounces = NO;
  //  [_scrollView.panGestureRecognizer addTarget:self
  //                                       action:@selector(scrollViewPan:)];
  [_scrollView.panGestureRecognizer setMaximumNumberOfTouches:1];
  [self.view addSubview:_scrollView];
  //好友圈头标题
  [self createFriendTableviewHeadView:_scrollView];

  __weak StockBarsViewController *weakSelf = self;

  CGRect frame2 = CGRectMake(0, 0.0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height);
  _hotestWeiboListViewController = [[HotestChatStockTableVC alloc] initWithFrame:frame2];
  //  _hotestWeiboListViewController.fromId = @(-1);
  _hotestWeiboListViewController.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };
  _hotestWeiboListViewController.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };
  [_scrollView addSubview:_hotestWeiboListViewController.view];
  [self addChildViewController:_hotestWeiboListViewController];

  //聊股吧表格
  _stockBarsTableView =
      [[UITableView alloc] initWithFrame:CGRectMake(WIDTH_OF_VIEWCONTROLLER, 0.0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height)
                                   style:UITableViewStylePlain];
  _stockBarsTableView.delegate = self;
  _stockBarsTableView.dataSource = self;
  _stockBarsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _stockBarsTableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_scrollView addSubview:_stockBarsTableView];

  _stockBarsHeaderView = [[MJRefreshHeaderView alloc] initWithScrollView:_stockBarsTableView];
  _stockBarsHeaderView.delegate = self;

  CGRect frame = CGRectMake(WIDTH_OF_VIEWCONTROLLER * 2, friendHeadView.frame.size.height, WIDTH_OF_VIEWCONTROLLER,
                            _scrollView.bounds.size.height - friendHeadView.frame.size.height);
  _friendWeiboListViewController = [[FriendChatStockTableVC alloc] initWithFrame:frame];
  _friendWeiboListViewController.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };
  _friendWeiboListViewController.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  [_scrollView addSubview:_friendWeiboListViewController.view];
  [self addChildViewController:_friendWeiboListViewController];

  _stockBarLittleCattleView = [[LittleCattleView alloc]
      initWithFrame:CGRectMake(WIDTH_OF_VIEWCONTROLLER, 0.0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height)
        information:@"暂无数据"];
  [_scrollView addSubview:_stockBarLittleCattleView];
}

#pragma mark - 向下传递滑动手势
- (void)scrollViewPan:(UIPanGestureRecognizer *)panner {

  CGPoint point = [panner velocityInView:_scrollView];
  if (_scrollView.contentOffset.x == 0 && point.x > 0) {
    [_simuMainVC pan:panner];
    _scrollView.userInteractionEnabled = NO;
    _simuMainVC.currentScrollView = _scrollView;
    //    _scrollView.scrollEnabled = NO;
  }
}

/** 添加表格头视图 */
- (void)createFriendTableviewHeadView:(UIScrollView *)scroll {
  friendHeadView =
      [[UIView alloc] initWithFrame:CGRectMake(WIDTH_OF_VIEWCONTROLLER * 2, 0, WIDTH_OF_VIEWCONTROLLER, 25.0f)];
  friendHeadView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  [scroll addSubview:friendHeadView];
  //左侧图片
  UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 3, 15, 17)];
  leftImageView.image = [UIImage imageNamed:@"小喇叭"];
  [friendHeadView addSubview:leftImageView];

  ///创建跑马灯
  [self CreatFriendScrollView];
}

- (void)CreatFriendScrollView {
  if ([_tweetList.array count] > 0) {
    /**创建跑马灯*/
    [self stopMyTimer];
    if (friendScrollView) {
      [friendScrollView removeAllSubviews];
    } else {
      friendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 3, WIDTH_OF_SCREEN - 40, 19)];
      friendScrollView.scrollEnabled = NO;
      friendScrollView.userInteractionEnabled = YES;
      [friendHeadView addSubview:friendScrollView];
    }
    int index = 0;
    while (_tweetList.array.count > index) {
      UILabel *btnLabel =
          [self addImageWithIndex:index
                         andFrame:CGRectMake(0, index * friendScrollView.height, friendScrollView.width, friendScrollView.height)];
      [friendScrollView addSubview:btnLabel];
      index++;
    }

    UILabel *btnLabel =
        [self addImageWithIndex:0
                       andFrame:CGRectMake(0, index * friendScrollView.height, friendScrollView.width, friendScrollView.height)];
    [friendScrollView addSubview:btnLabel];

    friendScrollView.contentSize = CGSizeMake(friendScrollView.width, friendScrollView.height * (index + 1));
    [friendScrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    if (index > 1) {
      if (!iKLTimer) {
        times = 5.0f;
        iKLTimer = [NSTimer scheduledTimerWithTimeInterval:times
                                                    target:self
                                                  selector:@selector(adScrollByTime)
                                                  userInfo:nil
                                                   repeats:YES];
      }
      [self adScrollByTime];
    }
  }
}

- (void)adScrollByTime {
  CGPoint point = friendScrollView.contentOffset;
  CGFloat x = point.y + friendScrollView.height;
  [UIView animateWithDuration:times - 4.0f
      delay:1.0f
      options:0
      animations:^{
        friendScrollView.contentOffset = CGPointMake(0, x);
      }
      completion:^(BOOL finished) {
        if (x >= friendScrollView.contentSize.height - friendScrollView.height) {
          [friendScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
      }];
}
//定时器停止
- (void)stopMyTimer {
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
      iKLTimer = nil;
      // NSLog(@"[iFreshTimer invalidate];");
    }
  }
}

- (UILabel *)addImageWithIndex:(int)index andFrame:(CGRect)frame {
  TweetListData *adData = _tweetList.array[index];
  UILabel *labelbtn = [[UILabel alloc] initWithFrame:frame];
  labelbtn.textAlignment = NSTextAlignmentLeft;
  labelbtn.text = adData.TitleName;
  labelbtn.backgroundColor = [UIColor clearColor];
  labelbtn.textColor = [Globle colorFromHexRGB:@""];
  labelbtn.font = [UIFont systemFontOfSize:14];
  labelbtn.userInteractionEnabled = YES;
  //  [imagev addSubview:labelbtn];

  UIButton *imagev = [[UIButton alloc] initWithFrame:labelbtn.bounds];
  imagev.backgroundColor = [UIColor clearColor]; // check
  imagev.tag = 500 + index;
  [imagev addTarget:self
                action:@selector(paomaButtonClick:)
      forControlEvents:UIControlEventTouchUpInside];
  [labelbtn addSubview:imagev];
  return labelbtn;
}

//**跑马灯按钮点击*/
- (void)paomaButtonClick:(UIButton *)button {
  NSInteger index = button.tag - 500;
  if ([_tweetList.array count] > index) {
    TweetListData *tweetlistData = _tweetList.array[index];
    if ([tweetlistData.PathUrl rangeOfString:@"http://"].length > 0) {
      GameWebViewController *GameWebWebVC =
          [[GameWebViewController alloc] initWithNameTitle:tweetlistData.TitleName
                                                   andPath:tweetlistData.PathUrl];
      GameWebWebVC.urlType = ShareModuleTypeStaticWap;
      //切换
      [AppDelegate pushViewControllerFromRight:GameWebWebVC];
      return;
    } else if ([tweetlistData.PathUrl rangeOfString:@"youguu://"].length > 0) {
      [YouguuSchema handleYouguuUrl:[NSURL URLWithString:[tweetlistData.PathUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
      return;
    }
  }
}

#pragma mark

- (void)showTalkStockContent {
  if (headTstockId) {
    [WBDetailsViewController showTSViewWithTStockId:headTstockId];
  }
}
#pragma mark - 菊花代理
- (void)refreshButtonPressDown {

  if (_currentPage == 0) {
    ///刷新跑马灯
    ///好友圈跑马灯数据请求
    [self requestHotRecommendData];
    [_friendWeiboListViewController refreshButtonPressDown];

  } else if (_currentPage == 1) {
    _requestFinishedCount = [SimuUtil isLogined] ? 4 : 3;
    NSLog(@"聊股吧请求数量：%ld", (long)_requestFinishedCount);

    //请求我的股吧列表数据
    [self requestMyStockBarListData];
    //请求热门股聊吧，由于需要剔除我的股吧里重复的数据，所以请求在我的股吧绑定完数据之后

    //请求热门个股吧
    [self requestHotStockTopicListData];
  } else {
    [_hotestWeiboListViewController refreshButtonPressDown];
  }
}

#pragma mark - MJ 代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [SimuUtil performBlockOnMainThread:^{
      [self setNoNetwork];
      [self stopLoading];
    } withDelaySeconds:0.5];
    return;
  }

  if (refreshView == _stockBarsHeaderView) {
    if (self.beginRefreshCallBack) {
      self.beginRefreshCallBack();
    }
    _requestFinishedCount = [SimuUtil isLogined] ? 4 : 3;
    //请求我的股吧列表数据
    [self requestMyStockBarListData];
    //请求热门股聊吧，由于需要剔除我的股吧里重复的数据，所以请求在我的股吧绑定完数据之后

    //请求热门个股吧
    [self requestHotStockTopicListData];
  }
}

#pragma mark - UITableView 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  switch (section) {
  //我的聊股吧
  case 0: {
    return ![SimuUtil isLogined] ? 0 : _myBarsList.array.count;
  }
  //主题吧
  case 1: {
    NSInteger num = _themeBarsList.count;
    return num > 5 ? 5 : num;
  }
  //牛人吧
  case 2: {
    NSInteger num = _masterBarsList.count;
    return num > 5 ? 5 : num;
  }
  //热门个股吧
  case 3: {
    NSInteger num = _hotStockTopicList.count;
    return num > 10 ? 10 : num;
  }
  }
  //热门
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  //我的聊股吧
  if (indexPath.section == 0) {
    static NSString *myStockBarsCellID = @"myStockBarsCell";
    MyStockBarsCell *myStockBarsCell = [tableView dequeueReusableCellWithIdentifier:myStockBarsCellID];
    if (!myStockBarsCell) {
      myStockBarsCell = [[[NSBundle mainBundle] loadNibNamed:@"MyStockBarsCell"
                                                       owner:self
                                                     options:nil] firstObject];

      myStockBarsCell.reuseId = myStockBarsCellID;
    }

    HotStockBarData *hotStockBarData = _myBarsList.array[indexPath.row];

    //设置数据
    [myStockBarsCell refreshCellInfoWithData:hotStockBarData];

    //如果是最后一个数据，隐藏底线
    [myStockBarsCell hideCellBottomLinesView:(hotStockBarData == _myBarsList.array.lastObject)];

    return myStockBarsCell;

    //主题吧
  } else if (indexPath.section == 1) {
    static NSString *hotStockBarCellID = @"themeBarCell";
    MyStockBarsCell *hotStockBarCell = [tableView dequeueReusableCellWithIdentifier:hotStockBarCellID];
    if (!hotStockBarCell) {
      hotStockBarCell = [[[NSBundle mainBundle] loadNibNamed:@"MyStockBarsCell"
                                                       owner:self
                                                     options:nil] firstObject];

      hotStockBarCell.reuseId = hotStockBarCellID;
    }

    HotStockBarData *themeBarData = _themeBarsList[indexPath.row];

    //设置数据
    [hotStockBarCell refreshCellInfoWithData:themeBarData];

    //如果是最后一个数据，隐藏底线
    //分开为主题，牛人两个聊股吧之后，必须判断当前数量，大于5为第五个，小于则为最后一个
    if (_themeBarsList.count <= 5) {
      [hotStockBarCell hideCellBottomLinesView:(themeBarData == _themeBarsList.lastObject)];
    } else {
      [hotStockBarCell hideCellBottomLinesView:indexPath.row == 4];
    }

    return hotStockBarCell;

    //牛人吧
  } else if (indexPath.section == 2) {
    static NSString *hotStockBarCellID = @"masterBarCell";
    MyStockBarsCell *hotStockBarCell = [tableView dequeueReusableCellWithIdentifier:hotStockBarCellID];
    if (!hotStockBarCell) {
      hotStockBarCell = [[[NSBundle mainBundle] loadNibNamed:@"MyStockBarsCell"
                                                       owner:self
                                                     options:nil] firstObject];

      hotStockBarCell.reuseId = hotStockBarCellID;
    }

    HotStockBarData *masterBarData = _masterBarsList[indexPath.row];
    //设置数据
    [hotStockBarCell refreshCellInfoWithData:masterBarData];

    //如果是最后一个数据，隐藏底线
    //分开为主题，牛人两个聊股吧之后，必须判断当前数量，大于5为第五个，小于则为最后一个
    if (_masterBarsList.count <= 5) {
      [hotStockBarCell hideCellBottomLinesView:(masterBarData == _masterBarsList.lastObject)];
    } else {
      [hotStockBarCell hideCellBottomLinesView:indexPath.row == 4];
    }

    return hotStockBarCell;

    //热门个股吧
  } else {
    static NSString *hotStockTopicCellID = @"hotStockTopicCell";
    HotStockTopicCell *hotStockTopicCell = [tableView dequeueReusableCellWithIdentifier:hotStockTopicCellID];
    if (!hotStockTopicCell) {
      hotStockTopicCell = [[[NSBundle mainBundle] loadNibNamed:@"HotStockTopicCell"
                                                         owner:self
                                                       options:nil] firstObject];
    }

    HotStockTopicData *hotStockTopicData = _hotStockTopicList[indexPath.row];

    [hotStockTopicCell refreshCellInfoWithData:hotStockTopicData];

    return hotStockTopicCell;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

  if (![SimuUtil isLogined] && section == 0) {
    return nil;
  }

  UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH_OF_VIEWCONTROLLER, 25.0f)];
  header.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  //    header.hidden = YES;

  //标题
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 0.0f, 60.0f, 25.0f)];
  titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  titleLabel.backgroundColor = [UIColor clearColor];

  [header addSubview:titleLabel];

  switch (section) {
  case 0:
    titleLabel.text = @"我的聊股吧";
    break;
  case 1:
    titleLabel.text = @"主题吧";
    break;
  case 2:
    titleLabel.text = @"牛人吧";
    break;
  case 3:
    titleLabel.text = @"热门个股吧";
    break;
  }

  //我的聊股吧不显示更多按钮
  if (section != 0) {
    //更多··· button宽25+10+7+10+7+10+25 = 94
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(WIDTH_OF_VIEWCONTROLLER - 47.0f, 0.0f, 47.0f, 25.0f);
    moreButton.backgroundColor = [UIColor clearColor];
    [moreButton addTarget:self
                   action:@selector(moreButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
    //    [moreButton setBackgroundImage:[SimuUtil imageFromColor:Color_Gray]
    //                          forState:UIControlStateHighlighted];//与Android统一，不带按下态
    moreButton.tag = section;

    //三个方块，左右边距25 距离上20 间距7  宽高都10，
    for (NSInteger i = 0; i < 3; i++) {
      UIView *grayCube = [[UIView alloc] initWithFrame:CGRectMake(12.5f + i * 8.5f, 10.0f, 5.0f, 5.0f)];
      grayCube.backgroundColor = [Globle colorFromHexRGB:Color_Cube];
      [moreButton addSubview:grayCube];
    }

    [header addSubview:moreButton];
  }

  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

  //未登录或为空时隐藏
  if (![SimuUtil isLogined] && section == 0) {
    return 0;
  } else if (_myBarsList.array.count == 0 && section == 0) {
    return 0;
  } else if (_themeBarsList.count == 0 && section == 1) {
    return 0;
  } else if (_masterBarsList.count == 0 && section == 2) {
    return 0;
  } else {
    return 25.0f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 59.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
  //我聊股吧
  case 0: {
    StockBarDetailViewController *stockBarDetailVC = [[StockBarDetailViewController alloc] init];
    HotStockBarData *hotStockBarData = _myBarsList.array[indexPath.row];
    stockBarDetailVC.barTitle = hotStockBarData.name;
    stockBarDetailVC.barId = hotStockBarData.barId;
    stockBarDetailVC.isFollowed = YES;
    [AppDelegate pushViewControllerFromRight:stockBarDetailVC];
  } break;
  //主题吧
  case 1: {
    StockBarDetailViewController *stockBarDetailVC = [[StockBarDetailViewController alloc] init];
    HotStockBarData *hotStockBarData = _themeBarsList[indexPath.row];
    stockBarDetailVC.barTitle = hotStockBarData.name;
    stockBarDetailVC.barId = hotStockBarData.barId;
    stockBarDetailVC.isFollowed = NO;
    [AppDelegate pushViewControllerFromRight:stockBarDetailVC];
  } break;
  //牛人吧
  case 2: {
    StockBarDetailViewController *stockBarDetailVC = [[StockBarDetailViewController alloc] init];
    HotStockBarData *hotStockBarData = _masterBarsList[indexPath.row];
    stockBarDetailVC.barTitle = hotStockBarData.name;
    stockBarDetailVC.barId = hotStockBarData.barId;
    stockBarDetailVC.isFollowed = NO;
    [AppDelegate pushViewControllerFromRight:stockBarDetailVC];
  } break;
  //热门个股吧
  case 3: {
    //聊股分页
    HotStockTopicData *hotStockTopicData = _hotStockTopicList[indexPath.row];
    [TrendViewController showDetailWithStockCode:hotStockTopicData.stockCode
                                   withStockName:hotStockTopicData.stockName
                                   withFirstType:FIRST_TYPE_UNSPEC
                                     withMatchId:@"1"
                                   withStartPage:TPT_WB_Mode];

  } break;
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;

    if (offset.x == 0) {
      [_topToolBarView changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [_topToolBarView changTapToIndex:1];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER * 2) {
      [_topToolBarView changTapToIndex:2];
    }
  }
}

#pragma mark 移动滑块
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.view.frame.size.width * 2) {
      _topToolBarView.maxlineView.frame =
          CGRectMake(scrollView.contentOffset.x / 3, 32.5f, self.view.frame.size.width / 3, 3.0f);
    }
  }
}

#pragma mark - 更多按钮回调
- (void)moreButtonClick:(UIButton *)moreButton {
  switch (moreButton.tag) {
  //主题吧
  case 1: {
    HotStockBarViewController *hotStockBarViewController =
        [[HotStockBarViewController alloc] initWithType:0];
    [AppDelegate pushViewControllerFromRight:hotStockBarViewController];
  } break;
  //牛人吧
  case 2: {
    HotStockBarViewController *hotStockBarViewController =
        [[HotStockBarViewController alloc] initWithType:1];
    [AppDelegate pushViewControllerFromRight:hotStockBarViewController];
  } break;
  //热门个股吧
  case 3: {
    HotStockTopicViewController *hotTopicViewController = [[HotStockTopicViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:hotTopicViewController];
  } break;
  }
}

#pragma mark - -网络请求-
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  if (self.endRefreshCallBack) {
    self.endRefreshCallBack();
  } //停止菊花

  if (_isStockBarBinded) {
    _stockBarLittleCattleView.hidden = YES;
    _stockBarsTableView.hidden = NO;
  } else {
    [_stockBarLittleCattleView isCry:YES];
    _stockBarsTableView.hidden = YES;
  }
}

- (void)stopLoading {
  [_stockBarsHeaderView endRefreshing];
}

- (void)reduceRequestCount {
  if (--_requestFinishedCount <= 0) {
    NSLog(@"🌛聊股吧请求数量剩余：%ld", (long)_requestFinishedCount);
    if (self.endRefreshCallBack) {
      self.endRefreshCallBack();
    }; //停止菊花
  }
}

#pragma mark 绑定数据显示tableView及小牛
- (void)bindedAndShowTableView {
  _isStockBarBinded = YES;
  _stockBarLittleCattleView.hidden = YES;
}

#pragma mark 刷新表格
- (void)reloadStockBarsTableView {
  //全部下载完成一次刷新
  if (_requestFinishedCount == 0) {
    [_stockBarsTableView reloadData];
    _stockBarsTableView.hidden = NO;
  }
}

#pragma mark 热门推荐（跑马灯专用）
- (void)requestHotRecommendData {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //        [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindHotRecommendListData:(HotRecommendListData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [HotRecommendListData requestHotRecommendListDataWithCallback:callback];
}

- (void)bindHotRecommendListData:(HotRecommendListData *)hotRecommendList {
  _tweetList.dataBinded = YES;
  [_tweetList.array removeAllObjects];
  [_tweetList.array addObjectsFromArray:hotRecommendList.tweetList];
  if (_tweetList.array.count > 0) {
    _friendWeiboListViewController.view.frame =
        CGRectMake(WIDTH_OF_VIEWCONTROLLER * 2, friendHeadView.frame.size.height, WIDTH_OF_VIEWCONTROLLER,
                   _scrollView.bounds.size.height - friendHeadView.frame.size.height);
    //设置跑马灯按钮
    [self CreatFriendScrollView];
  } else {
    _friendWeiboListViewController.view.frame =
        CGRectMake(WIDTH_OF_VIEWCONTROLLER * 2, 0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height);
  }
}

#pragma mark 我的聊股吧
- (void)requestMyStockBarListData {
  //未登陆不请求我关注，直接请求热门聊股
  if (![SimuUtil isLogined]) {
    [_myBarsList.array removeAllObjects]; //从登录改为未登录，必须清空，不然热门聊股会清掉重复数据导致不足5条
    [self requestThemeBarsListData];
    [self requestMasterBarsListData];
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    [self reduceRequestCount];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      [strongSelf reduceRequestCount];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindMyStockBarListData:(MyStockBarListData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [MyStockBarListData requestMyStockBarListDataWithCallback:callback];
}

- (void)bindMyStockBarListData:(MyStockBarListData *)MyStockBarList {
  [self bindedAndShowTableView];
  [_myBarsList.array removeAllObjects];

  //清空本地数据库，与服务器保持同步
  [WBCoreDataUtil clearBarIds];
  //遍历本地存储加入股吧
  for (HotStockBarData *barData in MyStockBarList.myBars) {
    //清空表操作
    [WBCoreDataUtil insertBarId:barData.barId];
  }
  _myBarsList.dataBinded = YES;
  [_myBarsList.array addObjectsFromArray:MyStockBarList.myBars];

  [self reloadStockBarsTableView];

  //请求热门股聊吧
  [self requestThemeBarsListData];
  [self requestMasterBarsListData];
}

#pragma mark 主题吧
- (void)requestThemeBarsListData {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    [self reduceRequestCount];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      [strongSelf reduceRequestCount];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindThemeBarsListData:(HotStockBarListData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [HotStockBarListData requestHotStockBarListDataWithFromId:@(-1)
                                                 withReqNum:([SimuUtil isLogined] ? _myBarsList.array.count : 0) + 5
                                                   withType:0
                                               withCallback:callback];
}

- (void)bindThemeBarsListData:(HotStockBarListData *)hotStockBarList {
  [self bindedAndShowTableView];

  [_themeBarsList removeAllObjects];
  [_themeBarsList addObjectsFromArray:hotStockBarList.dataArray];
  //清除mybars里有的重复数据
  for (HotStockBarData *myBarData in _myBarsList.array) {
    for (HotStockBarData *hotBarData in _themeBarsList) {
      if ([hotBarData.barId.stringValue isEqualToString:myBarData.barId.stringValue]) {
        [_themeBarsList removeObject:hotBarData];
        break;
      }
    }
  }
  [self reloadStockBarsTableView];
}

#pragma mark 牛人吧
- (void)requestMasterBarsListData {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    [self reduceRequestCount];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      [strongSelf reduceRequestCount];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindMasterBarsListData:(HotStockBarListData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [HotStockBarListData requestHotStockBarListDataWithFromId:@(-1)
                                                 withReqNum:([SimuUtil isLogined] ? _myBarsList.array.count : 0) + 5
                                                   withType:1
                                               withCallback:callback];
}

- (void)bindMasterBarsListData:(HotStockBarListData *)hotStockBarList {
  [self bindedAndShowTableView];

  [_masterBarsList removeAllObjects];
  [_masterBarsList addObjectsFromArray:hotStockBarList.dataArray];
  //清除mybars里有的重复数据
  for (HotStockBarData *myBarData in _myBarsList.array) {
    for (HotStockBarData *hotBarData in _masterBarsList) {
      if ([hotBarData.barId.stringValue isEqualToString:myBarData.barId.stringValue]) {
        [_masterBarsList removeObject:hotBarData];
        break;
      }
    }
  }
  [self reloadStockBarsTableView];
}

#pragma mark 热门个股吧
- (void)requestHotStockTopicListData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    [self reduceRequestCount];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      [strongSelf reduceRequestCount];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindHotStockTopicListData:(HotStockTopicListData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [HotStockTopicListData requestHotStockTopicListDataWithFromId:@0
                                                     withReqNum:10
                                                   withCallback:callback];
}

- (void)bindHotStockTopicListData:(HotStockTopicListData *)hotStockTopicListData {
  [self bindedAndShowTableView];

  [_hotStockTopicList removeAllObjects];
  [_hotStockTopicList addObjectsFromArray:hotStockTopicListData.dataArray];
  //  [_stockBarsTableView reloadSections:[NSIndexSet indexSetWithIndex:3]
  //                     withRowAnimation:UITableViewRowAnimationNone];
  [self reloadStockBarsTableView];
}

@end
