//
//  HomePageTableController.m
//  SimuStock
//
//  Created by Mac on 15/2/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomePageTableController.h"
#import "StockTradeList.h"
#import "WBImageView.h"
#import "SimuPositionPageData.h"
#import "WBDetailsViewController.h"
#import "HomepageViewController.h"
#import "TrendViewController.h"
#import "simuBuyViewController.h"
#import "CompetitionDetailsViewController.h"
#import "ShareController.h"
#import "ReplyViewController.h"
#import "PraiseTStockData.h"
#import "MyCollectTweetViewController.h"

@implementation HomePageTableController {
  __weak id observerShare;
  __weak id observerPraise;
  __weak id observerComment;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:observerShare];
  [[NSNotificationCenter defaultCenter] removeObserver:observerPraise];
  [[NSNotificationCenter defaultCenter] removeObserver:observerComment];
}

- (id)initWithTable:(UITableView *)tableView
      withDataArray:(DataArray *)dataArray
 withViewController:(UIViewController *)viewController
     withClientView:(UIView *)clientView {
  if (self = [super init]) {
    self.tableView = tableView;
    self.dataArray = dataArray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.viewController = viewController;
    self.clientView = clientView;
    [self addObservers];
    if ([self.viewController
            isKindOfClass:[MyCollectTweetViewController class]]) {
      self.type = 7;
    } else {
      self.type = -1;
    }
  }
  return self;
}

- (void)addObservers {

  observerShare = [[NSNotificationCenter defaultCenter]
      addObserverForName:ShareWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataArray.array.count; i++) {
                    TweetListItem *weiboItem = _dataArray.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.share = weiboItem.share + 1;
                      [_tableView reloadData];
                      break;
                    }
                  }
                }
              }];

  observerPraise = [[NSNotificationCenter defaultCenter]
      addObserverForName:PraiseWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataArray.array.count; i++) {
                    TweetListItem *weiboItem = _dataArray.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.praise += 1;
                      weiboItem.isPraised = YES;
                      [NewShowLabel setMessageContent:@"赞成功"];

                      [_tableView reloadData];
                      break;
                    }
                  }
                }
              }];
  observerComment = [[NSNotificationCenter defaultCenter]
      addObserverForName:CommentWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataArray.array.count; i++) {
                    TweetListItem *weiboItem = _dataArray.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.comment =
                          weiboItem.comment + [userInfo[@"operation"] intValue];
                      [_tableView reloadData];
                      break;
                    }
                  }
                }
              }];
}
#pragma mark
#pragma scrollowView拉伸距离
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (_scollViewdelegate &&
      [_scollViewdelegate
          respondsToSelector:@selector(homescrollViewDidScroll:)]) {
    [_scollViewdelegate homescrollViewDidScroll:scrollView];
  }
}

#pragma mark
#pragma mark UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [_dataArray.array count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *homeData = _dataArray.array[indexPath.row];
  /// 判断是否是我的聊股中的我的收藏部分，此部分不能用返回值中的type字段区别
  NSInteger cellType = (self.type == 7 ? 7 : homeData.type);
  CGFloat height = [HomePageTableViewCell weiboHeightWithWeibo:homeData
                                                 withWeiboType:cellType
                                              withContontWidth:268
                                         withReplyContentWidth:260];
  return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //谭绪明
  static NSString *MyIdentifier;
  /// 判断是否是我的聊股中的我的收藏部分，此部分不能用返回值中的type字段区别
  if (self.type == 7) {
    MyIdentifier = @"HomePageTableViewCollectCell";
  } else {
    MyIdentifier = @"HomePageTableViewCell";
  }
  HomePageTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:MyIdentifier
                                          owner:self
                                        options:nil] firstObject];
    cell.reuseid = MyIdentifier;
    cell.tableView = tableView;
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor =
        [Globle colorFromHexRGB:@"#D9D9D9"];
  }

  cell.row = indexPath.row;

  //添加手势
  TweetListItem *homeData = _dataArray.array[indexPath.row];
  if (1 == homeData.type || 2 == homeData.type || 3 == homeData.type) {
    cell.longPressGR.enabled = YES;
    //长按手势_删除_设置block回调
    __weak HomePageTableController *weakSelf = self;
    cell.deleteBtnBlock = ^(NSNumber *tid) {
      [weakSelf deleteHomepageTableViewCell:tid row:indexPath.row];
    };
  } else {
    cell.longPressGR.enabled = NO;
  }

  /// 判断是否是我的聊股中的我的收藏部分，此部分不能用返回值中的type字段区别
  cell.type = (self.type == 7 ? 7 : homeData.type);

  [cell bindHomeData:homeData
              withTableView:tableView
      cellForRowAtIndexPath:indexPath];
  cell.delegate = self;

  CGFloat height = [HomePageTableViewCell weiboHeightWithWeibo:homeData
                                                 withWeiboType:cell.type
                                              withContontWidth:268
                                         withReplyContentWidth:260];
  CGRect lineFrame = cell.verticalLineDown.frame;
  CGRect imageFrame =
      (cell.type == 7 ? cell.headImageView.frame : cell.businessimgview.frame);

  lineFrame.origin.y = imageFrame.origin.y + imageFrame.size.height;
  lineFrame.size.height = height - lineFrame.origin.y;
  cell.verticalLineDown.frame = lineFrame;

  lineFrame = cell.verticalLineUp.frame;
  lineFrame.origin.y = 0;
  lineFrame.size.height = imageFrame.origin.y;
  cell.verticalLineUp.frame = lineFrame;

  //首线条控制长度
  if (indexPath.row == 0 && [_dataArray.array count] < 2) {
    cell.verticalLineDown.hidden = YES;
    cell.verticalLineUp.hidden = YES;
  } else if (indexPath.row == 0) { //多行，第一行
    cell.verticalLineDown.hidden = NO;
    cell.verticalLineUp.hidden = YES;
  } else if (_dataArray.dataComplete &&
             indexPath.row == [_dataArray.array count] - 1) {
    //添加“暂无更多数据浮窗”
    //    [NewShowLabel setMessageContent:@"暂无更多数据"];
    //最后一行隐藏连接线
    cell.verticalLineDown.hidden = YES;
    cell.verticalLineUp.hidden = NO;
  } else {
    cell.verticalLineUp.hidden = NO;
    cell.verticalLineDown.hidden = NO;
  }

  return cell;
}

// uitable的选择方法
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

  TweetListItem *homeData = _dataArray.array[indexPath.row];
  switch (homeData.type) {

  case WeiboTypeOrigianl: { //原创，没回复
    [WBDetailsViewController
        showTSViewWithTStockId:@([homeData.tstockid longLongValue])];
  } break;

  case WeiboTypeForward: { //转发（有回复）

    [WBDetailsViewController
        showTSViewWithTStockId:@([homeData.tstockid longLongValue])];
  } break;

  case WeiboTypeComment: { //评论
    [WBDetailsViewController
        showTSViewWithTStockId:@([homeData.tweetId longLongValue])];
  } break;

  case WeiboTypeAttention: { //关注
    NSString *nick = homeData.contentArr[0][1][1][@"nick"];
    if ([nick hasPrefix:@"@"]) {
      nick = [nick substringFromIndex:1];
    }
    NSString *uid = homeData.contentArr[0][1][1][@"uid"];
    HomepageViewController *viewController =
        [[HomepageViewController alloc] initUserId:uid
                                         titleName:nick
                                           matchID:@"1"];
    [AppDelegate pushViewControllerFromRight:viewController];
    return;
  };

  case WeiboTypeTrade: { //交易
    HomePageTableViewCell *cell =
        (HomePageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.sellBtn setHighlighted:NO];
    [cell.buyBtn setHighlighted:NO];
    [cell.shareBtn setHighlighted:NO];

    NSDictionary *dic = homeData.contentArr[0][1][1];
    NSString *stockcode = dic[@"code"];
    NSString *stockname = dic[@"name"];
    [TrendViewController showDetailWithStockCode:stockcode
                                   withStockName:stockname
                                   withFirstType:FIRST_TYPE_UNSPEC
                                     withMatchId:@"1"];
  } break;
  case WeiboTypeSystem: { //系统通知

  } break;

  default:
    break;
  }
  return;
}
#pragma mark 赞接口

/** 删除某一条聊股 */
- (void)deleteHomepageTableViewCell:(NSNumber *)tid row:(NSInteger)row {
  NSInteger i = 0;
  for (TweetListItem *homeData in _dataArray.array) {
    if (homeData.tstockid.longLongValue == tid.longLongValue) {
      //数据源、tableView中删除该对象
      [_dataArray.array removeObjectAtIndex:i];
      break;
    }
    i++;
  }
  [_tableView reloadData];
  if (_deleteOneCellCallBack) {
    _deleteOneCellCallBack();
  }
}

#pragma mark HomeTableViewCellDelegate
- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row {
  TweetListItem *homeData = _dataArray.array[row];
  switch (homeData.type) {

  case WeiboTypeOrigianl:
  case WeiboTypeForward: {
    switch (tag) {
    case 7303: { //分享
      [self shareWeiBo:row];

    } break;

    case 7300: { //评论

      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            [self commentWeiBo:row];
          }];
    } break;

    case 7301: { //点赞

      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            TweetListItem *weibo = _dataArray.array[row];
            [PraiseTStockData requestPraiseTStockData:weibo];
          }];
    } break;

    default:
      break;
    }
  } break;

  case WeiboTypeAttention: { //关注

    NSString *nick = homeData.contentArr[0][1][1][@"nick"];
    if ([nick hasPrefix:@"@"]) {
      nick = [nick substringFromIndex:1];
    }
    NSString *uid = homeData.contentArr[0][1][1][@"uid"];
    [HomepageViewController showWithUserId:uid titleName:nick matchId:@"1"];
    return;
  };

  case WeiboTypeTrade: { //交易

    switch (tag) {

    case 7300: {
      NSDictionary *dic = homeData.contentArr[0][1][1];
      NSString *stockCode = dic[@"code"];
      stockCode = [stockCode substringFromIndex:2];
      NSString *stockName = dic[@"name"];
      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            //已登录买入
            [simuBuyViewController buyStockWithStockCode:stockCode
                                           withStockName:stockName
                                             withMatchId:@"1"];
          }];

    } break;

    case 7301: {
      NSDictionary *dic = homeData.contentArr[0][1][1];
      NSString *stockCode = dic[@"code"];
      stockCode = [stockCode substringFromIndex:2];
      NSString *stockName = dic[@"name"];
      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {

            //已登录卖出
            if ([SimuPositionPageData isStockSellable:stockCode]) {
              [simuSellViewController sellStockWithStockCode:stockCode
                                               withStockName:stockName
                                                 withMatchId:@"1"];
            }
          }];

    } break;

    case 7302: {
      NSDictionary *dic = homeData.contentArr[0][1][1];
      NSString *stockCode = dic[@"code"];
      NSString *stockName = dic[@"name"];
      [TrendViewController showDetailWithStockCode:stockCode
                                     withStockName:stockName
                                     withFirstType:FIRST_TYPE_UNSPEC
                                       withMatchId:@"1"];
    } break;

    case 7303: { //分享
      if (homeData.stype == WeiboSubTypeBuy ||
          homeData.stype == WeiboSubTypeSell) {
        ShareController *controller = [[ShareController alloc] init];
        [controller shareTradeWithWeibo:homeData];
      } else if (homeData.stype == WeiboSubTypeDividend) {
        ShareController *controller = [[ShareController alloc] init];
        [controller shareTradeDividendWithWeibo:homeData];
      }
    } break;
    default:
      break;
    }

  } break;
  case WeiboTypeSystem: { //系统通知

    CompetitionDetailsViewController *competitionDetailsVC =
        [[CompetitionDetailsViewController alloc] init];
    NSMutableArray *arr = homeData.contentArr[0][1];
    NSMutableDictionary *dictionary = arr[1];
    NSString *str = dictionary[@"text"];
    NSString *matchID = dictionary[@"id"];
    competitionDetailsVC.matchID = matchID;
    competitionDetailsVC.titleName = str;
    [AppDelegate pushViewControllerFromRight:competitionDetailsVC];
  } break;

  default:
    break;
  }
}

///分享微博
- (void)shareWeiBo:(NSInteger)row {
  TweetListItem *homeData = _dataArray.array[row];
  //分享
  HomePageTableViewCell *cell = (HomePageTableViewCell *)[_tableView
      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];

  CGRect homeRect = [_tableView
      convertRect:[_tableView rectForRowAtIndexPath:
                                  [NSIndexPath indexPathForRow:row inSection:0]]
           toView:_clientView];
  UIImage *shareImage = [makingScreenShot
      makingScreenShotWithFrame:homeRect
                       withView:cell.contentView
                       withType:MakingScreenShotType_TradePage];
  [[[ShareController alloc] init] shareWeibo:homeData
                              withShareImage:shareImage];
}

///评论微博
- (void)commentWeiBo:(NSInteger)row {
  HomePageTableViewCell *cell = (HomePageTableViewCell *)[_tableView
      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  TweetListItem *homeData = _dataArray.array[row];
  ReplyViewController *replyVC = [[ReplyViewController alloc]
      initWithTstockID:[homeData.tstockid stringValue]
           andCallBack:^(TweetListItem *item) {
             //评论数+1
             [cell.buyBtn
                 setTitle:[NSString stringWithFormat:@"%ld",
                                                     (long)(++homeData.comment)]
                 forState:UIControlStateNormal];
           }];
  [AppDelegate pushViewControllerFromRight:replyVC];
}

@end
