//
//  WBDetailHeadView.h
//  SimuStock
//
//  Created by jhss on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldingLine.h"
#import "FTCoreTextView.h"
#import "WBImageView.h"
#import "UserGradeView.h"
#import "WBButtomTabBar.h"
#import "TweetListItem.h"
#import "RoundHeadImage.h"

@class UserListItem;

@interface WBDetailHeadView : UIView {
  /** 表头回复框 */
  UIView *replyView;
  TweetListItem *talkStockItem;
}

/** 头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;
/** 标题 */
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 评论按钮 */
@property(weak, nonatomic) IBOutlet UIButton *commentButton;
/** 发表时间 */
@property(weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
/** 评论中加入的图片 */
@property(weak, nonatomic) IBOutlet WBImageView *commentImageView;
/** 评论内容 */
@property(weak, nonatomic) IBOutlet FTCoreTextView *commentCoreTextView;
/** 赞按钮 */
@property(weak, nonatomic) IBOutlet UIButton *prasieButton;
/** 点击赞action */
- (IBAction)clickPrasieButton:(UIButton *)sender;
/** 用户昵称 */
@property(weak, nonatomic) IBOutlet UserGradeView *userGradeView;
/** 用户userid */
@property(strong, nonatomic) NSNumber *userId;
/** 底部折线 */
@property(weak, nonatomic) IBOutlet FoldingLine *downLine;
/** 分割线 */
@property(weak, nonatomic) IBOutlet UIView *verCuttingLine;
/** 最新 */
@property(weak, nonatomic) IBOutlet UIButton *recentButton;
/** 最新，最早上下箭头 */
@property(weak, nonatomic) IBOutlet UIImageView *sortImageview;
/** 精 */
@property(weak, nonatomic) IBOutlet UIImageView *eliteImageView;

/** 评论操作 */
- (IBAction)clickCommentButton:(id)sender;
/** 聊股吧名*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *barNameCoreTextView;

/** 记录用户数据 */
@property(strong, nonatomic) UserListItem *userItem;
/** 绑定聊正文页面顶部视图信息 */
- (NSInteger)bindWBDetailHeadViewInfo:(TweetListItem *)item
                   withWbButtomTabBar:(WBButtomTabBar *)wbButtomTabBar;

@end
