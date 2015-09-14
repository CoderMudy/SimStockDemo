//
//  WBDetailsViewController.h
//  SimuStock
//
//  Created by Jhss on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseRequester.h"
#import "WBButtomTabBar.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "TweetListItem.h"
#import "CommentsTableViewController.h"
#import "PraiseTableViewController.h"
#import "WBDetailsTableHeaderView.h"

/** 评论与赞 */
#define leftCommentBtn 1
#define rightPraiseBtn 2

/** 最新与最早 */
#define newest @"-1"
#define earliest @"1"

typedef void (^commentOnSuccess)(BOOL isReqSuccess);

@interface WBDetailsViewController
    : BaseViewController <UIGestureRecognizerDelegate> {
  TweetListItem *talkStockItem;
  /** 存放tweet信息 */
  NSMutableArray *tweetListsArray;
  /** 存放赞列表 */
  NSMutableArray *prasieListsArray;
  /** 左右切换位置 */
  __block NSInteger tempPosition;
  /** 表格头部 */
  WBDetailsTableHeaderView *tbHeadView;
  /** 底部tabbar */
  WBButtomTabBar *wbButtomTabBar;
  /** 下拉刷新 */
  MJRefreshHeaderView *wbHeadRefreshView;
  /** 上拉刷新 */
  MJRefreshFooterView *wbFootRefreshView;
  /** 记录赞列表加载位置 */
  __block NSString *tempPrasieFromId;
  /** 记录评论列表加载位置 */
  __block NSString *tempCommentFromId;
  /** 最早、最新状态 */
  __block NSString *earliestOrNewest;
  /** 表格底图 */
  UIView *tbFootView;
  /** 新建小牛 */
  //  LittleCattleView *newCattleView;
  /** 评论列表是否加载完毕 */
  BOOL _isLoadMoreComment;
  /** 相当于DataArray中的complete */
  BOOL _isCompleteComment;
  /** 赞列表是否加载完毕 */
  BOOL _isLoadMorePraise;
  /** 相当于DataArray中的complete */
  BOOL _isCompletePraise;
  /** 正在发送收藏请求 */
  BOOL _isCollectRequesting;
  NSString *stringUserId;
  /** 评论列表 */
  CommentsTableViewController *commentTableVC;
  /** 赞列表 */
  PraiseTableViewController *praiseTableVC;

  /** 赞观察者 */
  id praiseObser;
  /** 赞观察者 */
  id commentObser;
  /***** 判断聊股头部详情是否有数据，默认为NO *****/
  BOOL ISHeaderViewExist;

#pragma mark-----------只看楼主----------------
  /**  判断“楼主”按钮的选中状态 */
  BOOL IsHostStatus;
  /** “楼主”按钮 */
  UIButton *buildingLordBtn;
  /** 用来存放表格头部视图的view */
  BaseTableViewController *currentTableVC;
}
/** 来自热门推荐中的聊股，tweetlistData  */
@property(strong, nonatomic) NSNumber *talkId;
/** 表格头数据 */
@property(strong, nonatomic) TweetListItem *headItem;
/** 跳转聊股内容页面 */
+ (void)showTSViewWithTweetItem:(TweetListItem *)tsItem;
/** 只有聊股id调用函数 */
+ (void)showTSViewWithTStockId:(NSNumber *)talkId;

@end
