//
//  WBDetailsCell.h
//  SimuStock
//
//  Created by jhss on 14-11-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "TweetListItem.h"
#import "WBImageView.h"
#import "UserGradeView.h"
#import "CellBottomLinesView.h"

typedef void (^deleteButtonClickBlock)(NSNumber *);

@interface WBDetailsCell : UITableViewCell <UIGestureRecognizerDelegate> {
  /** 当前cell tweetListItem指针 */
  TweetListItem *tweetItem;
  /** 初始frame记录 */
  CGRect _commentFrame;
  CGRect _commentImageFrame;
  CGRect _relayContentFrame;
  CGRect _relayImageFrame;
}
/** 垂直连线上 */
@property(weak, nonatomic) IBOutlet UIView *verticalLineUp;
/** 垂直连线下 */
@property(weak, nonatomic) IBOutlet UIView *verticalLineDown;
/** userid */
@property(strong, nonatomic) NSNumber *userId;
/** 头像背景 */
@property(weak, nonatomic) IBOutlet UIView *userHeadPicBGView;
/** 用户头像 */
@property(weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
/** 用户评级控件 */
@property (weak, nonatomic) IBOutlet UserGradeView *userGradeView;
/** 评论楼数 */
@property(weak, nonatomic) IBOutlet UILabel *commentFloorLabel;
/** 评论时间 */
@property(weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
/** 评论内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *commentContentView;
/** 评论中图片 */
@property(weak, nonatomic) IBOutlet WBImageView *commentConImageview;
/** 回复背景view */
@property(weak, nonatomic) IBOutlet UIView *relayBGView;
/** 回复背景图 */
@property(weak, nonatomic) IBOutlet UIImageView *relayBGImageview;
/** 回复框灰色背景 */
@property(weak, nonatomic) IBOutlet UIView *grayReplyView;
/** 回复内容中的图 */
@property(weak, nonatomic) IBOutlet WBImageView *relayConImageView;
/** 回复时间 */
@property(weak, nonatomic) IBOutlet UILabel *relayTimeLabel;
/** 回复楼层数 */
@property(weak, nonatomic) IBOutlet UILabel *relayFloorNumLabel;
/** relay_userid */
@property(strong, nonatomic) NSNumber *relayUserId;
/** 回复昵称 */
@property(weak, nonatomic) IBOutlet UILabel *relayNickNameLabel;
/** 回复内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *relayContentView;
/** 回复按钮 */
@property(weak, nonatomic) IBOutlet UIButton *relayButton;
/** 回复按钮的背景view */
@property(weak, nonatomic) IBOutlet UIView *relayBtnBgView;
/** 回复小图标 */
@property(weak, nonatomic) IBOutlet UIImageView *relayIconImageView;
/** 回复字样 */
@property(weak, nonatomic) IBOutlet UILabel *relayLabel;
/** 删除按钮，刷新表格 */
@property(copy, nonatomic) deleteButtonClickBlock deleteBtnBlock;
/** 长按弹出按钮 */
@property(strong, nonatomic) UILongPressGestureRecognizer *longPress;

/** 调整cell */
- (void)addjustCellContent;
/** 自适应评论高度 */
- (void)refreshCellWithItem:(TweetListItem *)item
              withTableView:(UITableView *)tableView
      cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**绑定聊股正文页cell样式 */
-(void)bindTweetListItem:(TweetListItem *)item withIndexPath:(NSIndexPath *)indexPath withTweetArr:(NSMutableArray *)tweetListsArray withHostId:(NSString *)hostUserId;

@end
