//
//  ChatStockPageTVCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@class FTCoreTextView;
@class WBImageView;
@class TweetListItem;
@class RoundHeadImage;
@class UserGradeView;
@class CellBottomLinesView;
@class BGColorUIButton;

@protocol ChatStockPageTVCellDelegate <NSObject>

@optional
/** 绑定下部聊股工具栏中的分享、评论、赞按钮 */
- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row;

@end

@interface ChatStockPageTVCell : UITableViewCell

/** 长按弹出按钮 */
@property(strong, nonatomic) UILongPressGestureRecognizer *longPressGR;

/** 当前cell TweetListItem指针 */
@property(strong, nonatomic) TweetListItem *tweetListItem;

/** 时间线中间的头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *userImage;

/** 发表作者View */
@property(weak, nonatomic) IBOutlet UserGradeView *userNameView;
/** 发表时间Label */
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

/** 加精图标 */
@property(weak, nonatomic) IBOutlet UIImageView *eliteImageView;

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
/** （全局）置顶按钮回调block */
@property(nonatomic, copy) TopButtonClickBlock topButtonClickBlock;
/** 加精按钮，通知精华列表刷新 */
@property(nonatomic, copy) EliteButtonClickBlock eliteButtonClickBlock;
/** 刷新分享、评论、赞状态 */
@property(nonatomic, copy) UpdateStatusBlock updateStatusBlock;
/** 通知刷新数据源所有赞状态 */
@property(nonatomic, copy) RefreshPraisedBlock refreshPraisedBlock;

/** 行数 */
@property(nonatomic, assign) NSInteger row;

@property(nonatomic, weak) id<ChatStockPageTVCellDelegate> delegate;

/** 初始化工具栏：分享、评论、赞*/
- (void)initToolBar;

@end
