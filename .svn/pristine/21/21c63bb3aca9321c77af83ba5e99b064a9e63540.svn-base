//
//  WBDetailsViewController.m
//  SimuStock
//
//  Created by Jhss on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WBDetailsViewController.h"
#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "WBCoreDataUtil.h"
#import "CollectTStockData.h"
#import "PraiseTStockData.h"
#import "ReplyViewController.h"
#import "ShareController.h"

@implementation WBDetailsViewController
/**  跳转聊股内容页面
 *  tstockid：聊股Id
 */
+ (void)showTSViewWithTweetItem:(TweetListItem *)item {
  if (item) {
    WBDetailsViewController *wbDetailsVC =
        [[WBDetailsViewController alloc] init];
    wbDetailsVC.talkId = item.tstockid;
    [AppDelegate pushViewControllerFromRight:wbDetailsVC];
  }
}
/** 只有聊股id调用函数 */
+ (void)showTSViewWithTStockId:(NSNumber *)talkId {
  if (talkId) {
    WBDetailsViewController *wbDetailsVC =
        [[WBDetailsViewController alloc] init];
    wbDetailsVC.talkId = talkId;
    [AppDelegate pushViewControllerFromRight:wbDetailsVC];
  }
}
- (id)init {
  self = [super init];
  if (self) {
    /***** 判断聊股头部详情是否有数据，默认为NO *****/
    ISHeaderViewExist = NO;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];

  [_topToolBar resetContentAndFlage:@"聊股内容" Mode:TTBM_Mode_Leveltwo];
  //默认评论数据
  IsHostStatus = NO;
  tempPosition = leftCommentBtn;
  //添加楼主按钮
  [self settingUpJustLookAtTheBuildingLordButton];
  [_indicatorView setButonIsVisible:YES];
  [self createMainView];
  [self createDataAndSendRequest];
  __weak WBDetailsViewController *weakSelf = self;

  praiseObser = [[NSNotificationCenter defaultCenter]
      addObserverForName:PraiseWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                WBDetailsViewController *strongSelf = weakSelf;
                if (strongSelf) {
                  [strongSelf receivePraiseInfo:userInfo];
                }
              }];
  commentObser = [[NSNotificationCenter defaultCenter]
      addObserverForName:CommentWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                WBDetailsViewController *strongSelf = weakSelf;
                if (strongSelf) {
                  [strongSelf receiveCommontInfo:userInfo];
                }
              }];
}
#pragma mark------------返回评论列表，赞列表的tableHeaderView--------------
/** 返回一个tableView视图 */
- (UIView *)tbHeadView {
  if (tbHeadView == nil) {
    tbHeadView =
        [[[NSBundle mainBundle] loadNibNamed:@"WBDetailsTableHeaderView"
                                       owner:self
                                     options:nil] firstObject];
  }
  UIView *headerView = [[UIView alloc] initWithFrame:tbHeadView.frame];
  [tbHeadView removeFromSuperview];
  [headerView addSubview:tbHeadView];
  return headerView;
}
/** 界面创建 */
- (void)createMainView {
  //底部tabbar
  wbButtomTabBar = [[[NSBundle mainBundle] loadNibNamed:@"WBButtomTabBar"
                                                  owner:self
                                                options:nil] firstObject];
  wbButtomTabBar.frame = CGRectMake(0, self.view.frame.size.height - 45,
                                    self.view.frame.size.width, 45.0f);

  __weak WBDetailsViewController *weakSelf = self;
  //底部分享按钮
  [wbButtomTabBar.shareButton setOnButtonPressedHandler:^{
    [weakSelf shareContentOfTalkStock];
  }];
  //点赞
  [wbButtomTabBar.praiseButton setOnButtonPressedHandler:^{
    [weakSelf praiseOfTalkStock];
  }];
  //收藏
  [wbButtomTabBar.collectButton setOnButtonPressedHandler:^{
    [weakSelf collectOfTalkStock];
  }];
  //评论
  [wbButtomTabBar.commentButton setOnButtonPressedHandler:^{
    [weakSelf commentOfTalkStock];
  }];

  [self.view addSubview:wbButtomTabBar];
  //创建一个tableView视图
  currentTableVC.tableView.tableHeaderView = self.tbHeadView;
  self.clientView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
/** 添加楼主的按钮 */
- (void)settingUpJustLookAtTheBuildingLordButton {
  buildingLordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  buildingLordBtn.frame =
      CGRectMake(CGRectGetMinX(_indicatorView.frame) - 60,
                 CGRectGetMinY(_indicatorView.frame), 60, 45);
  [buildingLordBtn setTitle:@"只看楼主" forState:UIControlStateNormal];
  [buildingLordBtn setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                        forState:UIControlStateNormal];
  [buildingLordBtn setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                        forState:UIControlStateHighlighted];
  buildingLordBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  buildingLordBtn.titleLabel.numberOfLines = 0;
  [buildingLordBtn
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [buildingLordBtn addTarget:self
                      action:@selector(iSSelectedLookbuildingLordBtnPress)
            forControlEvents:UIControlEventTouchUpInside];
  [self.topToolBar addSubview:buildingLordBtn];
}
/** 设置“楼主”按钮的状态 */
- (void)iSSelectedLookbuildingLordBtnPress {
  if ([self noNetwork]) {
    return;
  }
  if (IsHostStatus == YES) {
    [buildingLordBtn setTitle:@"只看楼主" forState:UIControlStateNormal];
    IsHostStatus = NO;
  } else {
    [buildingLordBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    IsHostStatus = YES;
  }
  commentTableVC.isHost = IsHostStatus;
  //如果在赞列表需要切换位评论列表
  if (tempPosition == rightPraiseBtn) {
    [self selectCommentBtn];
  }
  [commentTableVC refreshButtonPressDown];
}
///判断tableHeaderView是否有数据，如果有数据加载列表信息
- (void)createDataAndSendRequest {
  tweetListsArray = [[NSMutableArray alloc] init];
  prasieListsArray = [[NSMutableArray alloc] init];
  //首次刷新表头数据
  IsHostStatus = NO;
  earliestOrNewest = newest;
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    [self requestHostData];
  }
}
- (void)getCommentSuccess:(BOOL)isReqSuccess {
  if (isReqSuccess) {
    /***** 判断聊股头部详情是否有数据，默认为NO *****/
    ISHeaderViewExist = YES;
    //不是楼主，最新
    [self createCommentsTableViewWithIsHost:IsHostStatus
                       withEarliestOrNewest:earliestOrNewest];
    [commentTableVC refreshButtonPressDown];
  } else {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  }
}
#pragma mark------------创建评论列表，赞列表--------------

- (void)resetCommentTableLittleCattleView {
  CGFloat minHeight = 260;
  CGFloat height = commentTableVC.view.height -
                   commentTableVC.tableView.tableHeaderView.height;
  if (commentTableVC.dataArray.array.count == 0) {
    height = height > minHeight ? height : minHeight;
    [commentTableVC.littleCattleView
        resetFrame:CGRectMake(0, 0, self.view.size.width, height)];
    commentTableVC.tableView.tableFooterView = commentTableVC.littleCattleView;
  }
}
///创建评论列表
- (void)createCommentsTableViewWithIsHost:(BOOL)isHost
                     withEarliestOrNewest:(NSString *)earliestNewest {
  if (commentTableVC == nil) {
    CGRect commentFrame = CGRectMake(0, 0, self.clientView.frame.size.width,
                                     self.clientView.frame.size.height -
                                         wbButtomTabBar.height + 1);
    commentTableVC =
        [[CommentsTableViewController alloc] initWithFrame:commentFrame
                                                withIsHost:isHost
                                      withEarliestOrNewest:earliestNewest
                                               withtTalkId:self.talkId];
    commentTableVC.hostUid = stringUserId;
    commentTableVC.talkStockItem = talkStockItem;
    __weak WBDetailsViewController *weakSelf = self;
    commentTableVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    commentTableVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    commentTableVC.headerRefreshCallBack = ^{
      [weakSelf requestHostData];
    };
    commentTableVC.onDataReadyCallBack = ^{
      [weakSelf resetCommentTableLittleCattleView];
    };
  }
  [self.clientView addSubview:commentTableVC.view];
  [self addChildViewController:commentTableVC];

  commentTableVC.tableView.tableHeaderView = self.tbHeadView;
  //如果没有绑定数据，则重新请求数据，否则返回原来位置
  if (!commentTableVC.dataBinded) {
    [commentTableVC refreshButtonPressDown];
  }
}

- (void)resetPraiseTableLittleCattleView {
  CGFloat minHeight = 260;
  CGFloat height = praiseTableVC.view.height -
                   praiseTableVC.tableView.tableHeaderView.height;
  if (praiseTableVC.dataArray.array.count == 0) {
    height = height > minHeight ? height : minHeight;
    [praiseTableVC.littleCattleView
        resetFrame:CGRectMake(0, 0, self.view.size.width, height)];
    praiseTableVC.tableView.tableFooterView = praiseTableVC.littleCattleView;
  }
}
///创建赞列表
- (void)createPraiseTableView {
  if (praiseTableVC == nil) {
    CGRect praiseFrame = CGRectMake(0, 0, self.clientView.frame.size.width,
                                    self.clientView.frame.size.height -
                                        wbButtomTabBar.height + 1);
    praiseTableVC =
        [[PraiseTableViewController alloc] initWithFrame:praiseFrame
                                             withtTalkId:self.talkId];
    __weak WBDetailsViewController *weakSelf = self;
    praiseTableVC.beginRefreshCallBack = ^{

      [weakSelf.indicatorView startAnimating];
    };
    praiseTableVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    praiseTableVC.onDataReadyCallBack = ^{
      [weakSelf resetPraiseTableLittleCattleView];
    };
  }
  [self.clientView addSubview:praiseTableVC.view];
  [self addChildViewController:praiseTableVC];

  praiseTableVC.tableView.tableHeaderView = self.tbHeadView;
  //如果没有绑定数据，则重新请求数据，否则返回原来位置
  if (!praiseTableVC.dataBinded) {
    [praiseTableVC refreshButtonPressDown];
  }
}
#pragma mark--------------接收评论和点赞的信息-------
- (void)receiveCommontInfo:(NSDictionary *)dict {
  TweetListItem *homeData = dict[@"data"];
  if (homeData) {
    if (talkStockItem.tstockid.longLongValue ==
        homeData.tstockid.longLongValue) {
      talkStockItem.comment += [dict[@"operation"] intValue];
      [self updateCommentNum];
    }
  }
}
- (void)updateCommentNum {
  //评论数 + 1
  NSString *commentStr =
      [NSString stringWithFormat:@"评论  %ld", (long)(talkStockItem.comment)];
  [tbHeadView.commentBtn setTitle:commentStr forState:UIControlStateNormal];
}
/** 接收赞信息 */
- (void)receivePraiseInfo:(NSDictionary *)dict {
  TweetListItem *homeData = dict[@"data"];
  if (homeData) {
    if (talkStockItem.tstockid.longLongValue ==
        homeData.tstockid.longLongValue) {
      //更新数据
      talkStockItem.praise += 1;
      talkStockItem.isPraised = YES;

      //底部赞按钮
      wbButtomTabBar.praiseImageView.image =
          [UIImage imageNamed:@"菜单栏赞小图标_down"];
      wbButtomTabBar.praiseButton.userInteractionEnabled = NO;
      [WBCoreDataUtil insertPraiseTid:talkStockItem.tstockid];
      [NewShowLabel setMessageContent:@"赞成功"];
      //赞按钮 + 1
      NSString *praiseStr =
          [NSString stringWithFormat:@"赞   %ld", (long)talkStockItem.praise];
      [tbHeadView.applaudBtn setTitle:praiseStr forState:UIControlStateNormal];
    }
  }
}
/** 判断最新最早的状态 */
- (void)selectedEarliestOrNewest {
  if ([earliestOrNewest integerValue] == 1) {
    [tbHeadView.newestBtn setTitle:@"最新" forState:UIControlStateNormal];
    [tbHeadView.sortImageview
        setImage:[UIImage imageNamed:@"最新排序小箭头_下"]];
    earliestOrNewest = @"-1";
  } else {
    [tbHeadView.newestBtn setTitle:@"最早" forState:UIControlStateNormal];
    [tbHeadView.sortImageview
        setImage:[UIImage imageNamed:@"最新排序小箭头_上"]];
    earliestOrNewest = @"1";
  }
  commentTableVC.earliestOrNewest = earliestOrNewest;
  [commentTableVC refreshButtonPressDown];
}
#pragma mark---------请求headerView的楼主数据，并创建表头------
/** 获取楼主内容 */
- (void)getcommentContentWithTalkWeetId:(NSString *)talkId
                              withBlock:(commentOnSuccess)block {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  [_indicatorView startAnimating];
  __weak WBDetailsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WBDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    WBDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf commentRequestSuccess:(WeiboContentWrapper *)obj];
      if (block) {
        block(YES);
      }
    }
  };
  callback.onFailed = ^{
    [BaseRequester defaultFailedHandler]();
    if (block) {
      block(NO);
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (block) {
      block(NO);
    }
    [BaseRequester defaultErrorHandler](error, ex);
    if ([error.status isEqualToString:@"0601"]) {
      //此聊股已删除
      commentTableVC.tableView.hidden = YES;
      wbButtomTabBar.hidden = YES;
    }
  };
  [WeiboContentWrapper getTalkStockInitialContentWithTalkWeetId:talkId
                                                   withCallback:callback];
}
/** 评论内容请求成功 */
- (void)commentRequestSuccess:(WeiboContentWrapper *)item {
  talkStockItem = item.weibo;
  //刷新表头数据
  [self refreshTableViewHeadViewWithUid:talkStockItem];
}
///发送时间控件与来自xxx聊股吧俯视图之间的距离。
/** 刷新表格头部信息 */
- (void)refreshTableViewHeadViewWithUid:(TweetListItem *)item {
  stringUserId = [item.userListItem.userId stringValue];
  CGFloat height = 1.f;
  height += [tbHeadView bindWBDetailHeadViewInfo:item
                                andTopViewBottom:1.f
                              andHasUserNameView:NO];

  height += [tbHeadView bindContentAndHeadViewInfo:item
                                  andTopViewBottom:height
                                andHasUserNameView:NO];

  if (item.isPraised) {
    wbButtomTabBar.praiseImageView.image =
        [UIImage imageNamed:@"菜单栏赞小图标_down"];
    wbButtomTabBar.praiseButton.userInteractionEnabled = NO;
  } else {
    //底部赞按钮
    wbButtomTabBar.praiseImageView.image =
        [UIImage imageNamed:@"菜单栏赞小图标"];
  }
  //显示底部收藏按钮状态
  [self showCollectButton];
  __weak WBDetailsViewController *weakSelf = self;
  [tbHeadView.commentBtn setOnButtonPressedHandler:^{
    [weakSelf selectCommentBtn];
  }];
  [tbHeadView.applaudBtn setOnButtonPressedHandler:^{
    [weakSelf selectPraiseBtn];
  }];
  [tbHeadView.newestBtn setOnButtonPressedHandler:^{
    [weakSelf selectedEarliestOrNewest];
  }];
  tbHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
  currentTableVC.tableView.tableHeaderView = self.tbHeadView;
}
///点击创建评论列表
- (void)selectCommentBtn { //重复点击同一个按钮
  if ([self noNetwork]) {
    return;
  }
  tempPosition = leftCommentBtn;
  tbHeadView.newestBtn.hidden = NO;
  tbHeadView.sortImageview.hidden = NO;
  tbHeadView.verCuttingLine.hidden = NO;
  [tbHeadView.commentBtn
      setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
           forState:UIControlStateNormal];
  [tbHeadView.applaudBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                              forState:UIControlStateNormal];
  tbHeadView.downLine.directionStatus = @"1";
  [tbHeadView.downLine setNeedsDisplay];
  [self createCommentsTableViewWithIsHost:IsHostStatus
                     withEarliestOrNewest:earliestOrNewest];
}
///点击查创建赞列表
- (void)selectPraiseBtn { //重复点击同一个按钮
  if ([self noNetwork]) {
    return;
  }
  tempPosition = rightPraiseBtn;
  tbHeadView.newestBtn.hidden = YES;
  tbHeadView.sortImageview.hidden = YES;
  tbHeadView.verCuttingLine.hidden = YES;
  if (praiseTableVC) {
    praiseTableVC.tableView.tableHeaderView = nil;
    [praiseTableVC.view removeFromSuperview];
    [praiseTableVC removeFromParentViewController];
  }
  [tbHeadView.applaudBtn
      setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
           forState:UIControlStateNormal];
  [tbHeadView.commentBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                              forState:UIControlStateNormal];
  tbHeadView.downLine.directionStatus = @"2";
  [tbHeadView.downLine setNeedsDisplay];
  [self createPraiseTableView];
}
#pragma mark----------收藏操作-----------------
#pragma mark -收藏
- (void)collectOfTalkStock {
  if ([self noNetwork] || talkStockItem.tstockid == nil) {
    return;
  }
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) { //登录成功后调用
        talkStockItem.isCollected =
            [WBCoreDataUtil fetchCollectTid:talkStockItem.tstockid];
        if (talkStockItem.isCollected) {
          //取消收藏
          [self collectOfTalkStockWithNumber:talkStockItem.tstockid
                           withCollectStatus:-1];
        } else {
          //收藏
          [self collectOfTalkStockWithNumber:talkStockItem.tstockid
                           withCollectStatus:1];
        }
      }];
}
#pragma mark -收藏request
- (void)collectOfTalkStockWithNumber:(NSNumber *)tsId
                   withCollectStatus:(NSInteger)collectStatus {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  if (_isCollectRequesting) {
    [NewShowLabel setMessageContent:@"正在收藏"];
    return;
  }
  _isCollectRequesting = YES;
  [self performSelector:@selector(cancelCollectStatus)
             withObject:nil
             afterDelay:10.0f];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  [_indicatorView startAnimating];
  __weak WBDetailsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WBDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      _isCollectRequesting = NO;
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    WBDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf collectRequestSuccess:collectStatus];
    }
  };
  [CollectTStockData requestCollectTStockDataWithTStockId:tsId
                                                  withAct:collectStatus
                                             withCallback:callback];
}
- (void)cancelCollectStatus {
  _isCollectRequesting = NO;
}
/** 收藏请求成功 */
- (void)collectRequestSuccess:(NSInteger)colStatus {

  NSDictionary *userInfo = @{
    @"data" : talkStockItem,
    @"operation" : @(colStatus)
  };
  //广播分享成功，分享数加1
  [[NSNotificationCenter defaultCenter]
      postNotificationName:CollectWeiboSuccessNotification
                    object:self
                  userInfo:userInfo];

  [_indicatorView stopAnimating];
  if (colStatus == -1) {
    [NewShowLabel setMessageContent:@"取消收藏成功"];
    [WBCoreDataUtil deleteCollectTid:talkStockItem.tstockid];
  } else if (colStatus == 1) {
    [NewShowLabel setMessageContent:@"添加收藏成功"];
    [WBCoreDataUtil insertCollectTid:talkStockItem.tstockid];
  }
  [self showCollectButton];
}
- (void)showCollectButton {
  talkStockItem.isCollected =
      [WBCoreDataUtil fetchCollectTid:talkStockItem.tstockid];
  //收藏状态
  if (talkStockItem.isCollected) {
    wbButtomTabBar.collectImageview.image =
        [UIImage imageNamed:@"菜单栏收藏小图标_down"];
  } else {
    wbButtomTabBar.collectImageview.image =
        [UIImage imageNamed:@"菜单栏收藏小图标"];
  }
}

#pragma mark------------- wbButtomTabBar按钮触发事件 ----------------
#pragma mark -分享模块
- (void)shareContentOfTalkStock {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (!ISHeaderViewExist) {
    [NewShowLabel setMessageContent:@"页面加载失败 请刷新"];
    return;
  }
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *shareImage;
  if (tempPosition == leftCommentBtn) {
    shareImage = [makingScreenShot
        makingScreenShotWithFrame:commentTableVC.tableView.tableHeaderView.frame
                         withView:commentTableVC.tableView.tableHeaderView
                         withType:MakingScreenShotType_TrendPage_Half];
  } else {
    shareImage = [makingScreenShot
        makingScreenShotWithFrame:praiseTableVC.tableView.tableHeaderView.frame
                         withView:praiseTableVC.tableView.tableHeaderView
                         withType:MakingScreenShotType_TrendPage_Half];
  }
  [[[ShareController alloc] init] shareWeibo:talkStockItem
                              withShareImage:shareImage];
}
#pragma mark -底部赞状态
#pragma mark -登录成功后执行赞操作
- (void)praiseOfTalkStock {
  if ([self noNetwork] || talkStockItem == nil) {
    return;
  }
  __weak WBDetailsViewController *weakSelf = self;
  //赞的状态
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        WBDetailsViewController *strongSelf = weakSelf;
        if (strongSelf) {
          [strongSelf innerPraise];
        }
      }];
}
- (void)innerPraise {
  wbButtomTabBar.praiseButton.userInteractionEnabled = NO;
  [PraiseTStockData requestPraiseTStockData:talkStockItem];
}

#pragma mark -cell中回复
#pragma mark - wbButtomTabBar评论按钮
- (void)commentOfTalkStock {
  if ([self noNetwork]) {
    return;
  }
  if (ISHeaderViewExist == NO) {
    [NewShowLabel setMessageContent:@"页面加载失败，请刷新"];
    return;
  }
  __weak WBDetailsViewController *weakSelf = self;
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        //登录成功后调用
        ReplyViewController *replyVC = [[ReplyViewController alloc]
            initWithTstockID:[_talkId stringValue]
                 andCallBack:^(TweetListItem *item) {
                   WBDetailsViewController *strongSelf = weakSelf;
                   if (strongSelf) {
                     [strongSelf commentSuccess:item];
                   }
                 }];
        [AppDelegate pushViewControllerFromRight:replyVC];
      }];
}
/** 评论成功 */
- (void)commentSuccess:(TweetListItem *)item {
  //非最新状态，变为最新
  if ([earliestOrNewest integerValue] == 1) {
    earliestOrNewest = @"1";
    [self selectedEarliestOrNewest];
  }
  //如果在赞列表需要切换位评论列表
  if (tempPosition == rightPraiseBtn) {
    [self selectCommentBtn];
  }
  [commentTableVC.dataArray.array insertObject:item atIndex:0];
  item.floor = 0;
  NSDictionary *userInfo = @{ @"data" : talkStockItem, @"operation" : @"1" };
  [[NSNotificationCenter defaultCenter]
      postNotificationName:CommentWeiboSuccessNotification
                    object:nil
                  userInfo:userInfo];

  if (commentTableVC.dataArray.array > 0) {
    commentTableVC.littleCattleView.hidden = YES;
  }
  [commentTableVC.tableView reloadData];
}
/** 重载刷新函数 */
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  if (tempPosition == leftCommentBtn) {
    [self requestHostData];
  } else {
    [praiseTableVC refreshButtonPressDown];
  }
}
///请求headerView的网络数据
- (void)requestHostData {
  __weak WBDetailsViewController *weakSelf = self;
  if (_talkId) {
    //判断是否有headerView的楼主信息
    [self getcommentContentWithTalkWeetId:[_talkId stringValue]
                                withBlock:^(BOOL isReqSuccess) {
                                  WBDetailsViewController *strongSelf =
                                      weakSelf;
                                  if (strongSelf) {
                                    [strongSelf getCommentSuccess:isReqSuccess];
                                  }
                                }];
  }
}
- (BOOL)noNetwork {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return YES;
  } else {
    return NO;
  }
}
#pragma - 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [_indicatorView stopAnimating];  //停止菊花
}
- (void)leftButtonPress {
  [[NSNotificationCenter defaultCenter] removeObserver:praiseObser];
  [[NSNotificationCenter defaultCenter] removeObserver:commentObser];
  praiseObser = nil;
  commentObser = nil;
  [super leftButtonPress];
}
@end
