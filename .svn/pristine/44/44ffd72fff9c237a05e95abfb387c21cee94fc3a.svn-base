//
//  StockBarDetailViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockBarDetailViewController.h"
#import "TopWeiboCell.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "UIImageView+WebCache.h"
#import "ShowBarInfoData.h"
#import "GetBarTopListData.h"
#import "TweetListItem.h"
#import "FollowStockBarData.h"
#import "UnFollowStockBarData.h"
#import "WBCoreDataUtil.h"
#import "WBDetailsViewController.h"
#import "DistributeViewController.h"
#import "WeiboToolTip.h"
#import "EliteChatStockTableVC.h"
#import "AllChatStockTableVC.h"
#import "StockBarDetailHeaderView.h"

@implementation StockBarDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  /// 设定标题
  [self resetTitle:_barTitle];
  /// 设定菊花位置
  [self resetIndicatorView];
  /// 创建发表按钮
  [self createPublishButton];
  /// 设定选择工具栏
  [self createTopToolBarView];
  /// 创建scrollView和tableview
  [self createScrollViewAndTableViews];
  /// 刷新全部列表信息
  [_allChatTableVC refreshButtonPressDown];
}

/** 设定菊花位置 */
- (void)resetIndicatorView {
  CGRect frame = _indicatorView.frame;
  frame.origin.x -= 50.0f;
  _indicatorView.frame = frame;
}

//创建发表按钮
- (void)createPublishButton {
  _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _publishButton.frame = CGRectMake(WIDTH_OF_VIEWCONTROLLER - 50.0f, topToolBarHeight - 45.0f, 50.0f, 45.0f);
  _publishButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  [_publishButton setTitle:@"发表" forState:UIControlStateNormal];
  [_publishButton setTitleColor:[Globle colorFromHexRGB:Color_Publish]
                       forState:UIControlStateNormal];
  [_publishButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_butDown]
                            forState:UIControlStateHighlighted];
  [_publishButton addTarget:self
                     action:@selector(publishButtonClick)
           forControlEvents:UIControlEventTouchUpInside];
  _publishButton.backgroundColor = [UIColor clearColor];
  [_topToolBar addSubview:_publishButton];
}

#pragma mark 发表
- (void)publishButtonClick {
  /// 发表聊股
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {

    DistributeViewController *disVC = [[DistributeViewController alloc]
        initWithBarID:[_barId stringValue]
          andCallBack:^(TweetListItem *item) {
            /// 直接本地刷新
            [_allChatTableVC.dataArray.array insertObject:item atIndex:0];
            _allChatTableVC.dataArray.dataBinded = YES;
            _allChatTableVC.littleCattleView.hidden = YES;
            _allChatTableVC.tableView.hidden = NO;
            [_allChatTableVC.tableView setTableFooterView:nil];
            _allChatTableVC.dataArray.dataComplete = NO;
            _allChatTableVC.footerView.hidden = _allChatTableVC.dataArray.dataComplete;
            [_allChatTableVC.tableView reloadData];
            _barInfoHeaderView.postNumLabel.text =
                [NSString stringWithFormat:@"%ld", (long)[_barInfoHeaderView.postNumLabel.text integerValue] + 1];
            /// 更新聊股数
            if (_updateBarTStock) {
              _updateBarTStock(_barId, YES);
            }

          }];
    [AppDelegate pushViewControllerFromRight:disVC];
  }];
}

/** 创建全部和精华切换按钮 */
- (void)createTopToolBarView {
  _topToolBarView = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEWCONTROLLER, TOP_TABBAR_HEIGHT)
                                                DataArray:@[ @"全部", @"精华" ]
                                      withInitButtonIndex:0];
  _topToolBarView.delegate = self;
  [_clientView addSubview:_topToolBarView];
}

#pragma mark - 创建scrollView和tableview
- (void)createScrollViewAndTableViews {

  /// 创建承载滑动视图
  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, WIDTH_OF_VIEWCONTROLLER,
                                                     _clientView.bounds.size.height - TOP_TABBAR_HEIGHT)];
  _scrollView.contentSize =
      CGSizeMake(WIDTH_OF_VIEWCONTROLLER * 2, _clientView.bounds.size.height - TOP_TABBAR_HEIGHT);
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.bounces = NO;

  [_clientView addSubview:_scrollView];

  /// 创建“全部”表格
  _allChatTableVC =
      [[AllChatStockTableVC alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height)];

  /// 创建总表头
  _barInfoHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"StockBarDetailHeaderView"
                                                      owner:self
                                                    options:nil] firstObject];

  __weak StockBarDetailViewController *weakSelf = self;
  _barInfoHeaderView.followButtonClickBlock =
      /// 聊股吧关注按钮回调
      ^() {
        [weakSelf getFollowingStatus];
      };
  _allChatTableVC.barID = self.barId;
  _allChatTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  _allChatTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  _allChatTableVC.topEliteButtonClickBlock = ^(BOOL isElite, NSNumber *tid) {
    [weakSelf allTableViewFreshTStock:tid isElite:isElite];
    if (isElite) {
      /// 如果是加精操作，精华列表必须刷新
      [weakSelf.eliteTableVC refreshButtonPressDown];
    } else {
      /// 如果是取消加精操作，精华列表本地遍历删除
      [weakSelf eliteTableViewDeleteTStock:tid];
    }
  };
  _allChatTableVC.resetBarInfoBlock = ^(NSObject *obj) {
    ShowBarInfoData *info = (ShowBarInfoData *)obj;
    [weakSelf bindShowBarInfoData:info];
  };
  [self addChildViewController:_allChatTableVC];
  [_scrollView addSubview:_allChatTableVC.view];

  /// 创建“精华”表格
  _eliteTableVC = [[EliteChatStockTableVC alloc]
      initWithFrame:CGRectMake(WIDTH_OF_VIEWCONTROLLER, 0, WIDTH_OF_VIEWCONTROLLER, _scrollView.bounds.size.height)];
  _eliteTableVC.barID = self.barId;
  _eliteTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _eliteTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  _eliteTableVC.topEliteButtonClickBlock = ^(BOOL isElite, NSNumber *tid) {
    [weakSelf allTableViewFreshTStock:tid isElite:isElite];
  };
  [self addChildViewController:_eliteTableVC];
  [_scrollView addSubview:_eliteTableVC.view];

  _allChatTableVC.tableView.tableHeaderView = _barInfoHeaderView;
  [self enableScrollsToTopWithPageIndex:0];
}

- (void)enableScrollsToTopWithPageIndex:(NSInteger)index {
  _scrollView.scrollsToTop = NO;
  if (index == 0) {
    _eliteTableVC.tableView.scrollsToTop = NO;
    _allChatTableVC.tableView.scrollsToTop = YES;
  } else {
    _eliteTableVC.tableView.scrollsToTop = YES;
    _allChatTableVC.tableView.scrollsToTop = NO;
  }
}

#pragma mark - -代理方法-
#pragma mark 全部和精华切换按钮回调O
- (void)changeToIndex:(NSInteger)index {
  _currentPage = index;
  [self enableScrollsToTopWithPageIndex:index];
  if (index == 1) {
    [_scrollView setContentOffset:CGPointMake(WIDTH_OF_VIEWCONTROLLER, 0) animated:YES];
    /// 请求全部加精股聊列表
    if (!_eliteTableVC.dataArray.dataComplete && !_eliteTableVC.dataArray.dataBinded) {
      [self refreshButtonPressDown];
    }
  } else {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (!_allChatTableVC.dataArray.dataComplete && !_allChatTableVC.dataArray.dataBinded) {
      [_allChatTableVC refreshButtonPressDown];
    }
  }
}

#pragma mark 刷新按钮代理方法
- (void)refreshButtonPressDown {
  if (_currentPage == 0) {
    /// 全部页刷新
    [_allChatTableVC refreshButtonPressDown];
  } else {
    /// 精华页刷新
    [_eliteTableVC refreshButtonPressDown];
  }
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;
    if (offset.x == 0) {
      [_topToolBarView changTapToIndex:0];
    } else {
      [_topToolBarView changTapToIndex:1];
    }
  }
}

#pragma mark 移动滑块
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.view.frame.size.width) {
      _topToolBarView.maxlineView.frame =
          CGRectMake(scrollView.contentOffset.x / 2, 32.5f, self.view.frame.size.width / 2, 3.0f);
    }
  }
}

#pragma mark 股吧信息（表头）
- (void)bindShowBarInfoData:(ShowBarInfoData *)showBarInfoData {
  /// 绑定股吧logo
  NSString *logoUrlStr = showBarInfoData.logo;
  [_barInfoHeaderView resetHeight];
  [_barInfoHeaderView.logoImageView setImageWithURL:[NSURL URLWithString:logoUrlStr]
                                   placeholderImage:[UIImage imageNamed:@"stockBarIcon"]];
  if (logoUrlStr.length > 0) {
    /// 白色
    [_barInfoHeaderView.logoImageView setBackgroundColor:[Globle colorFromHexRGB:Color_White]];
  } else {
    [_barInfoHeaderView.logoImageView setBackgroundColor:[Globle colorFromHexRGB:Color_NormalBackground]];
  }

  /// 绑定股吧名称
  _barInfoHeaderView.desLabel.text = showBarInfoData.des;

  NSString *moderatorsStr = @"吧主：";

  /// 可能返回空
  if (showBarInfoData.moderators.count > 0) {
    /// 绑定股吧吧主

    for (ModeratorInfoData *moderatorInfoData in showBarInfoData.moderators) {
      /// 封装成可供FTCoreDataText解析的类型
      NSString *packageStr =
          [NSString stringWithFormat:@"<user uid=\"%@\" nick=\"%@\"/>", [moderatorInfoData.uid stringValue], moderatorInfoData.nickname];
      moderatorsStr = [moderatorsStr stringByAppendingString:[NSString stringWithFormat:@"%@、", packageStr]];
    }

    /// 去掉最后一个“、“
    moderatorsStr = [moderatorsStr substringToIndex:(moderatorsStr.length - 1)];
  }
  _barInfoHeaderView.coreTextView.text = moderatorsStr;
  [_barInfoHeaderView.coreTextView fitToSuggestedHeight:_barInfoHeaderView.coreTextViewHeight];
  [_barInfoHeaderView setNewHeight];

  /// 设置coreText

  /// 绑定关注数
  _barInfoHeaderView.followersLabel.text = [showBarInfoData.followers stringValue];

  /// 绑定股聊数
  _barInfoHeaderView.postNumLabel.text = [showBarInfoData.postNum stringValue];

  /// 设置关注按钮状态
  if (_isFollowed) {
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标"]
                                     forState:UIControlStateNormal];
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标down"]
                                     forState:UIControlStateHighlighted];
  } else {
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标"]
                                     forState:UIControlStateNormal];
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标down"]
                                     forState:UIControlStateHighlighted];
  }

  self.allChatTableVC.tableView.tableHeaderView = _barInfoHeaderView;
}

#pragma mark 获取关注状态
- (void)getFollowingStatus {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    _isFollowed = [WBCoreDataUtil fetchBarId:_barId];
    NSLog(@"是否已关注%d", _isFollowed);
    /// 改变按钮状态
    if (_isFollowed) {
      [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标"]
                                       forState:UIControlStateNormal];
      [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标down"]
                                       forState:UIControlStateHighlighted];
      /// 取消关注
      [WeiboToolTip showMakeSureWithTitle:@"确定要退出该聊股吧？"
                                sureblock:^{
                                  [self requestUnFollowBar];
                                }];
    } else {
      [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标"]
                                       forState:UIControlStateNormal];
      [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标down"]
                                       forState:UIControlStateHighlighted];
      /// 关注
      [self requestFollowBar];
    }
  }];
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
  [_indicatorView stopAnimating];
}

#pragma mark 请求关注
- (void)requestFollowBar {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarDetailViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarDetailViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarDetailViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindFollowStockBarData:(FollowStockBarData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [FollowStockBarData requestFollowStockBarDataWithBarId:_barId withCallback:callback];
}

- (void)bindFollowStockBarData:(FollowStockBarData *)obj {
  NSInteger num = [obj.remain integerValue];
  if (num > 0) {
    [NewShowLabel
        setMessageContent:[NSString
                              stringWithFormat:@"加入成功，您还可以加入%@个聊股吧", [obj.remain stringValue]]];
  } else {
    [NewShowLabel
        setMessageContent:[NSString stringWithFormat:@"加" @"入成功，您加入的聊股吧" @"个数已达到上限"]];
  }

  _isFollowed = YES;
  /// 本地保存加入股吧
  [WBCoreDataUtil insertBarId:_barId];
  [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标"]
                                   forState:UIControlStateNormal];
  [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"删除添加小图标down"]
                                   forState:UIControlStateHighlighted];

  _barInfoHeaderView.followersLabel.text =
      [NSString stringWithFormat:@"%ld", (long)([_barInfoHeaderView.followersLabel.text integerValue] + 1)];
  /// 通知主页刷新聊股吧
  [[NSNotificationCenter defaultCenter] postNotificationName:MyStockBarsChangeNotification
                                                      object:nil];
}

#pragma mark 取消关注
- (void)requestUnFollowBar {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockBarDetailViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockBarDetailViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockBarDetailViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUnFollowStockBarData:(UnFollowStockBarData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [UnFollowStockBarData requestUnFollowStockBarDataWithBarId:_barId withCallback:callback];
}

- (void)bindUnFollowStockBarData:(UnFollowStockBarData *)obj {
  if ([obj.message isEqualToString:@"ok."]) {
    [NewShowLabel setMessageContent:@"退出成功"];
    _isFollowed = NO;
    /// 本地删除加入股吧
    [WBCoreDataUtil deleteBarId:_barId];
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标"]
                                     forState:UIControlStateNormal];
    [_barInfoHeaderView.followButton setImage:[UIImage imageNamed:@"添加小图标down"]
                                     forState:UIControlStateHighlighted];
    _barInfoHeaderView.followersLabel.text =
        [NSString stringWithFormat:@"%ld", (long)([_barInfoHeaderView.followersLabel.text integerValue] - 1)];
    /// 通知主页刷新聊股吧
    [[NSNotificationCenter defaultCenter] postNotificationName:MyStockBarsChangeNotification
                                                        object:nil];
  } else {
    [NewShowLabel setMessageContent:obj.message]; //比如吧主就不能退出
  }
}

#pragma mark - cell回调部分
#pragma mark 重置‘全部列表’加精状态
- (void)allTableViewFreshTStock:(NSNumber *)tid isElite:(BOOL)isElite {
  /// 置顶列表也需要设置加精
  NSInteger i = 0;
  for (BarTopTweetData *topData in self.allChatTableVC.barTopList.array) {
    if ([[topData.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      TopWeiboCell *topCell = (TopWeiboCell *)[self.allChatTableVC.tableView
          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
      [topCell resetEliteIcon:isElite];
      topData.elite = (isElite ? 1 : 0);
      break;
    }
    i++;
  }

  NSInteger j = 0;
  for (TweetListItem *item in self.allChatTableVC.dataArray.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      /// 找到相关cell，取消加精图标和重置加精按钮
      ChatStockPageTVCell *cell = (ChatStockPageTVCell *)[self.allChatTableVC.tableView
          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:1]];
      cell.eliteImageView.hidden = !isElite;
      item.elite = (isElite ? 1 : 0);
      break;
    }
    j++;
  }
}

#pragma mark 删除’精华列表‘相应数据
- (void)eliteTableViewDeleteTStock:(NSNumber *)tid {
  NSInteger i = 0;
  for (TweetListItem *item in self.eliteTableVC.dataArray.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      /// 数据源、tableView中删除该对象
      [self.eliteTableVC.dataArray.array removeObjectAtIndex:i];
      [self.eliteTableVC.tableView reloadData];
      break;
    }
    i++;
  }

  /// 判断数据是否为空，如果为空，显示小牛
  if (self.eliteTableVC.dataArray.array.count == 0) {
    self.eliteTableVC.dataArray.dataBinded = NO;
    [self.eliteTableVC.littleCattleView isCry:NO];
    self.eliteTableVC.tableView.hidden = YES;
  }
}
@end
