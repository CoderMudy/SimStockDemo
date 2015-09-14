//
//  MyChatStockTVCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

static const CGFloat MCSTVCell_Time_Bottom = 16.f;
static const CGFloat MCSTVCell_Time_Bottom_HasUserNameView = 44.f;
static const CGFloat MCSTVCell_Space_Between_Time_Tittle = 12.f;
static const CGFloat MCSTVCell_Space_Between_Tittle_Content = 6.f;
static const CGFloat MCSTVCell_Space_Between_Content_ContentImage = 6.f;
static const CGFloat MCSTVCell_Space_Between_RPContent_RPContentImage = 8.f;
static const CGFloat MCSTVCell_Space_Between_RPTop_ContentImage = 15.f;
static const CGFloat MCSTVCell_Space_Between_Bottom_Top = 15.f;
static const CGFloat MCSTVCell_Space_Between_RPTopView_Top = 3.f;
static const CGFloat MCSTVCell_Height_RPTopBKView = 7.f;
static const CGFloat MCSTVCell_Bottom_Extra_Height = 43.f;
static const CGFloat MCSTVCell_RPBKView_Bottom_Extra_Height = 7.f;

static const CGFloat MCSTVCell_Content_Left_Space = 42.f;
static const CGFloat MCSTVCell_Content_Left_Space_HasUserNameView = 46.f;
static const CGFloat MCSTVCell_Content_Right_Space = 10.f;
static const CGFloat MCSTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight = 5.f;
static const CGFloat MCSTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft = 5.f;

@class FTCoreTextView;
@class WBImageView;
@class TweetListItem;
@class RoundHeadImage;
@class UserGradeView;
@class CellBottomLinesView;
@class BGColorUIButton;

/** 聊股工具栏中的分享、评论、赞按钮相关的协议 */
@protocol MyChatStockTVCellDelegate <NSObject>

@optional
/** 绑定下部聊股工具栏中的分享、评论、赞按钮 */
- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row;

@end

@interface MyChatStockTVCell : UITableViewCell <UIGestureRecognizerDelegate>

/** 当前cell TweetListItem指针 */
@property(strong, nonatomic) TweetListItem *tweetListItem;

/** 长按弹出按钮 */
@property(strong, nonatomic) UILongPressGestureRecognizer *longPressGR;

/** 左侧上部时间线 */
@property(weak, nonatomic) IBOutlet UIView *timeLineUp;
/** 左侧下部时间线 */
@property(weak, nonatomic) IBOutlet UIView *timeLineDown;

/** 时间线中间的样式图片 */
@property(weak, nonatomic) IBOutlet UIImageView *typeImage;
/** 时间线中间的头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *userImage;

/** 发表作者View */
@property(weak, nonatomic) IBOutlet UserGradeView *userNameView;
/** 发表时间Label */
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

/** 聊股标题 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *tittleLabel;
/** 聊股内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *contentLabel;
/** 聊股图片 */
@property(weak, nonatomic) IBOutlet WBImageView *contentImage;

/** 回复上方的小三角 */
@property(weak, nonatomic) IBOutlet UIImageView *replayTopBKView;
/** 回复的背景 */
@property(weak, nonatomic) IBOutlet UIImageView *replayBKView;
/** 回复的内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *replayContentView;
/** 回复的图片 */
@property(weak, nonatomic) IBOutlet WBImageView *replayImageView;

/** 底部工具按钮承载视图 */
@property(weak, nonatomic) IBOutlet UIView *bottomToolView;
/** 分享按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *shareBtn;
/** 评论按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *commentBtn;
/** 赞按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *applaudBtn;

/** 底部的分割线 */
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomLineView;

/** 聊股标题与时间Label的竖直间距 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tittleToTimeVS;
/** 聊股标题的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tittleLabelHeight;
/** 聊股内容的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;
/** 聊股内容与时间Label的竖直间距 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentToTimeVS;
/** 聊股图片与时间Label的竖直间距 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageToTimeVS;
/** 聊股图片的宽 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageWidth;
/** 聊股图片的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeight;

/** 回复上方的小三角与时间Lable的竖直间距 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpTopBKToTimeVS;
/** 回复的背景的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpBKViewHeight;
/** 回复的内容的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpContentViewHeight;
/** 回复的图片与回复背景View的竖直间距 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpImageViewToRpBKViewVS;
/** 回复的图片的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpImageViewHeight;
/** 回复的图片的宽 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *rpImageViewWidth;

/** 删除按钮，刷新表格 */
@property(copy, nonatomic) DeleteTStockClickBlock deleteBtnBlock;
/** 取消收藏按钮，刷新表格 */
@property(copy, nonatomic) CancleCollectTStockClickBlock cancleCollectBtnBlock;

/** 行数 */
@property(nonatomic, assign) NSInteger row;

@property(nonatomic, weak) id<MyChatStockTVCellDelegate> delegate;

/** 初始化工具栏：分享、评论、赞*/
- (void)initToolBar;

@end
