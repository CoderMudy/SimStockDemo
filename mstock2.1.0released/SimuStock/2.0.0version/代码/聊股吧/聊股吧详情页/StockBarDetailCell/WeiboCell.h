//
//  WeiboCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserConst.h"

@class FTCoreTextView;
@class CellBottomLinesView;
@class TweetListItem;
@class WBReplyView;
@class WBImageView;
@class UserGradeView;

typedef void (^topButtonClickBlock)(TweetListItem *);

typedef void (^eliteButtonClickBlock)(BOOL, NSNumber *);

typedef void (^deleteButtonClickBlock)(NSNumber *);

typedef void (^updateStatusBlock)(TweetListItem *);

typedef void (^refreshPraisedBlock)(void);

/** 聊股吧股聊信息 */
@interface WeiboCell
    : UITableViewCell <UIAlertViewDelegate, UITextFieldDelegate> {
  NSNumber *_uid;
  NSString *_nickName;
  UserVipType _vipType;
  TweetListItem *_item;

  /** 初始frame记录 */
  CGRect _coreTextFrame;
  CGRect _weiboImageViewFrame;
  CGRect _wbReplyViewFrame;
  CGRect _bottomUIViewFrame;
  CGRect _barNameViewFrame;

  BOOL _isCommenting; //正在评论
  BOOL _isPraising;   //正在赞
}
/** --UI-- */
/** 头像白底 */
@property(strong, nonatomic) IBOutlet UIView *whiteUiVIew;
/** 头像 */
@property(strong, nonatomic) IBOutlet UIImageView *headPicImageView;
/** 用户评级控件 */
@property (strong, nonatomic) IBOutlet UserGradeView *userGradeView;
/** 头像按钮 */
@property(strong, nonatomic) IBOutlet UIButton *headPicBotton;
/** 发帖时间 */
@property(strong, nonatomic) IBOutlet UILabel *ctimeLabel;
/** 精 小图标 */
@property(strong, nonatomic) IBOutlet UIImageView *eliteImageView;
/** 标题 */
@property(strong, nonatomic) IBOutlet UILabel *titleLabel;
/** 股聊内容视图 */
@property(strong, nonatomic) IBOutlet FTCoreTextView *coreTextView;
/** 聊股图片 */
@property(strong, nonatomic) IBOutlet WBImageView *weiboImageView;
/** 回复内容框 */
@property(strong, nonatomic) IBOutlet WBReplyView *wbReplyView;

/** 四个按钮的父视图 */
@property(strong, nonatomic) IBOutlet UIView *bottomUIView;
/** 分享按钮 */
@property(strong, nonatomic) IBOutlet UIButton *shareButton;
/** 评论按钮 */
@property(strong, nonatomic) IBOutlet UIButton *commentButton;
/** 赞按钮 */
@property(strong, nonatomic) IBOutlet UIButton *praiseButton;
/**聊股吧名*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *barNameView;
/*********************对外block*********************/
/** （全局）置顶按钮回调block */
@property(nonatomic, copy) topButtonClickBlock topButtonClickBlock;

/** 加精按钮，通知精华列表刷新 */
@property(nonatomic, copy) eliteButtonClickBlock eliteButtonClickBlock;

/** 删除按钮，刷新表格 */
@property(nonatomic, copy) deleteButtonClickBlock deleteButtonClickBlock;

/** 刷新分享、评论、赞状态 */
@property(nonatomic, copy) updateStatusBlock updateStatusBlock;

/** 通知刷新数据源所有赞状态 */
@property(nonatomic, copy) refreshPraisedBlock refreshPraisedBlock;

/** cell复用字符串设定 */
@property(nonatomic, copy) NSString *reuseId;

/** 对外刷新显示数据方法数据方法 */
- (void)refreshCellInfoWithItem:(TweetListItem *)item
                  withTableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** 重设加精按钮为未点击状态，用于‘精华列表’取消加精后‘全部列表’回调使用 */
- (void)resetEliteButton:(BOOL)isElite;

/** 返回cell内容总高度 */
+ (CGFloat)heightWithTweetListItem:(TweetListItem *)item;

@end
