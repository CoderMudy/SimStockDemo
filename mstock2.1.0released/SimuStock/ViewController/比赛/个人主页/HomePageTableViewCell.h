//
//  HomePageTableViewCell.h
//  SimuStock
//
//  Created by Mac on 14-12-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellBottomLinesView.h"

@class FTCoreTextView;
@class WBImageView;
@class TweetListItem;
@class UserListItem;
@class UserGradeView;
@class RoundHeadImage;

/** 长按删除block回调 */
typedef void (^deleteTStockClickBlock)(NSNumber *);

@protocol HomePageTableViewCellDelegate <NSObject>
//可实现
@optional
- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row;
@end

@interface HomePageTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

///红圆圈
@property(nonatomic, strong) CALayer *round;
///白圈圈
@property(nonatomic, strong) CALayer *whiteRound;
///底部分割线
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitView;
///买入\卖出\分红派送小标图标
@property(weak, nonatomic) IBOutlet UIImageView *businessimgview;
///时间线（上）
@property(weak, nonatomic) IBOutlet UIView *verticalLineUp;
///时间线（下）
@property(weak, nonatomic) IBOutlet UIView *verticalLineDown;

/// 发帖时间
@property(weak, nonatomic) IBOutlet UILabel *ctimeLabel;

///聊股标题
@property(weak, nonatomic) IBOutlet FTCoreTextView *titleView;
///聊股内容
@property(weak, nonatomic) IBOutlet FTCoreTextView *weiBoContentView;
///聊股图片
@property(weak, nonatomic) IBOutlet WBImageView *weiboImgs;

///聊天气泡小箭头
@property(weak, nonatomic) IBOutlet UIImageView *arrowImgView;
///聊天气泡
@property(weak, nonatomic) IBOutlet UIImageView *replayBox;
///回复聊股内容
@property(weak, nonatomic) IBOutlet FTCoreTextView *weiBoReplayView;
///聊股回复图片
@property(weak, nonatomic) IBOutlet WBImageView *replayImgs;

///放置按钮视图
@property(weak, nonatomic) IBOutlet UIView *placeButtonView;
///分享按钮
@property(weak, nonatomic) IBOutlet UIButton *shareBtn;
///买入按钮
@property(weak, nonatomic) IBOutlet UIButton *buyBtn;
///卖出按钮
@property(weak, nonatomic) IBOutlet UIButton *sellBtn;

/** cell复用字符串设定 */
@property(nonatomic, copy) NSString *reuseid;
/** 行数 */
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, weak) id<HomePageTableViewCellDelegate> delegate;

/** 删除按钮，刷新表格 */
@property(copy, nonatomic) deleteTStockClickBlock deleteBtnBlock;
/** 长按弹出按钮 */
@property(strong, nonatomic) UILongPressGestureRecognizer *longPressGR;

/** 当前cell TweetListItem指针 */
@property(strong, nonatomic) TweetListItem *tweetListItem;

/** 当前cell TweetListItem指针 */
@property(strong, nonatomic) UITableView *tableView;

//聊股内容部分(目前仅用于区别收藏与其它)
/** 聊股类型
 1：原创
 2：转发
 3：评论
 4：回复
 6：赞
 7：收藏
 8：分享
 9：关注
 10：交易
 13：系统通知 */
@property(nonatomic) NSInteger type;

/** 收藏的聊股的作者 */
@property(weak, nonatomic) IBOutlet UserGradeView *userNameView;
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;

/**
 * 使用指定的内容块宽度和指定的回复内容块宽度，计算聊股内容显示所需要的高度；如果之前已经计算，直接返回上次计算的结果
 */
+ (NSInteger)weiboHeightWithWeibo:(TweetListItem *)weibo
                 withContontWidth:(int)contentWidth
            withReplyContentWidth:(int)replyContentWidth;

+ (NSInteger)weiboHeightWithWeibo:(TweetListItem *)weibo
                    withWeiboType:(NSInteger)type
                 withContontWidth:(int)contentWidth
            withReplyContentWidth:(int)replyContentWidth;

/** 隐藏所有子Views*/
- (void)hideAllSubViews;

- (void)bindHomeData:(TweetListItem *)shareChatHomeData
            withTableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
