//
//  WBDetailsTableHeaderView.h
//  SimuStock
//
//  Created by Jhss on 15/8/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundHeadImage.h"
#import "FTCoreTextView.h"
#import "TweetListItem.h"
#import "WBImageView.h"
#import "UserGradeView.h"
#import "CellBottomLinesView.h"
#import "FoldingLine.h"

#define Time_Bottom (16.f)
#define Space_Time_Bottom_HasUserNameView (44.f)
#define Space_Between_Time_Tittle (12.f)
#define Space_Between_Tittle_Content (6.f)
#define Space_Between_Content_ContentImage (6.f)
#define Space_Between_RPContent_RPContentImage (8.f)
#define Space_Between_RPTop_ContentImage (15.f)
#define Space_Between_Bottom_Top (15.f)
#define Space_Between_RPTopView_Top (3.f)
#define RPTopBKView_Height (7.f)
#define RPBKView_Bottom_Extra_Height (7.f)
#define Botton_Down_View_Height (27.f)

#define Content_Left_Space (17.f)
#define Content_Right_Space (10.f)
#define Space_Between_ReplayBKViewRight_RPContentViewRight (5.f)
#define Space_Between_ReplayBKViewLeft_RPContentViewLeft (5.f)

@interface WBDetailsTableHeaderView : UIView 
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
/** 最新按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *newestBtn;
/** 评论按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *commentBtn;
/** 赞按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *applaudBtn;
/** 分割线 */
@property(weak, nonatomic) IBOutlet UIView *verCuttingLine;
/** 最新，最早上下箭头 */
@property(weak, nonatomic) IBOutlet UIImageView *sortImageview;
/** 底部折线 */
@property(weak, nonatomic) IBOutlet FoldingLine *downLine;
/** 聊股吧名*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *barNameCoreTextView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *barNameHeight;

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

@property (strong, nonatomic)NSString * uid;

/** 绑定聊股标题、聊股内容、聊股图片数据 */
- (CGFloat)bindWBDetailHeadViewInfo:(TweetListItem *)item
                   andTopViewBottom:(CGFloat)bottom
                 andHasUserNameView:(BOOL)hasNameView;

- (CGFloat)bindContentAndHeadViewInfo:(TweetListItem *)item
                     andTopViewBottom:(CGFloat)bottom
                   andHasUserNameView:(BOOL)hasNameView;

@end
