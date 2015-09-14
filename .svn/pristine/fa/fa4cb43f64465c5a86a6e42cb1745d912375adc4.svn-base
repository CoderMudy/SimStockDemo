//
//  CommentsTableCell.h
//  SimuStock
//
//  Created by Jhss on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "WBImageView.h"
#import "FTCoreTextView.h"
#import "RoundHeadImage.h"
#import "CellBottomLinesView.h"
#import "UserGradeView.h"
#import "TweetListItem.h"

typedef void (^deleteButtonClickBlock)(NSNumber *);

#define Time_Bottom (16.f)
#define Time_Bottom_HasUserNameView (45.f)
#define Space_Between_Time_Tittle (8.f)
#define Space_Between_Tittle_Content (6.f)
#define Space_Between_Content_ContentImage (6.f)
#define Space_Between_RPContent_RPContentImage (8.f)
#define Space_Between_RPTop_ContentImage (15.f)
#define Space_Between_Bottom_Top (15.f)
#define Space_Between_RPTopView_Top (3.f)
#define Height_RPTopBKView (7.f)
#define Bottom_Extra_Height (35.f)
#define RPBKView_Bottom_Extra_Height (7.f)

#define Content_Left_Space_HasUserNameView (46.f)
#define Content_Right_Space (10.f)
#define Space_Between_ReplayBKViewRight_RPContentViewRight (5.f)
#define Space_Between_ReplayBKViewLeft_RPContentViewLeft (5.f)

@interface CommentsTableCell : UITableViewCell

/** 当前cell TweetListItem指针 */
@property(strong, nonatomic) TweetListItem *tweetListItem;
/** 左侧上部时间线 */
@property(weak, nonatomic) IBOutlet UIView *timeLineUp;
/** 左侧下部时间线 */
@property(weak, nonatomic) IBOutlet UIView *timeLineDown;
/** 时间线中间的头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *userImage;
/** 发表作者View */
@property(weak, nonatomic) IBOutlet UserGradeView *userNameView;
/** 发表时间Label */
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 聊股内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *contentLabel;
/** 聊股图片 */
@property(weak, nonatomic) IBOutlet WBImageView *contentImage;
/** 评论的楼层数 */
@property(weak, nonatomic) IBOutlet UILabel *commentFloorLabel;
/** 回复的楼层数 */
@property(weak, nonatomic) IBOutlet UILabel *relayFloorLabel;

/** 回复上方的小三角 */
@property(weak, nonatomic) IBOutlet UIImageView *replayTopBKView;
/** 回复的背景 */
@property(weak, nonatomic) IBOutlet UIImageView *replayBKView;
/** 回复的内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *replayContentView;
/** 回复的图片 */
@property(weak, nonatomic) IBOutlet WBImageView *replayImageView;
/** 回复的用户名 */
@property(weak, nonatomic) IBOutlet UILabel *relayUserNameView;

/** 底部工具按钮承载视图 */
@property(weak, nonatomic) IBOutlet UIView *bottomToolView;
/** 回复按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *relayButton;

/** 底部的分割线 */
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomLineView;

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
//回复的内容距离回复框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rpContentVerticalHeight;

/** 删除按钮，刷新表格 */
@property(copy, nonatomic) deleteButtonClickBlock deleteBtnBlock;
/** 长按弹出按钮 */
@property(strong, nonatomic) UILongPressGestureRecognizer *longPress;
/** 行数 */
@property(nonatomic, assign) NSInteger row;

/** 返回聊股标题、聊股内容、聊股图片的高度 */
+ (CGFloat)getTitleAndContentAndImageHeightWithWeibo:(TweetListItem *)item
                                     andContontWidth:(CGFloat)contentWidth;
/** 设置左侧时间线 */
+ (void)setTimeLineInCell:(CommentsTableCell *)cell
                   andRow:(NSInteger)row
                  andData:(DataArray *)dataArray;
/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(CommentsTableCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView;

+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(CommentsTableCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasNameView;
@end
