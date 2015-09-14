//
//  MessageListTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCenterListWrapper.h"
#import "WeiBoExtendButtons.h"
#import "RoundHeadImage.h"
#import "UserGradeView.h"
#import "CellBottomLinesView.h"

@interface WeiBoExtendButtons (MessageCellView)

/** 显示“评论了我”的选择菜单：回复评论和查看原聊股 */
+ (void)showButtonsWithCommentMessage:(MessageListItem *)message
                              offsetY:(CGFloat)offsetY
                                 cell:(NSObject *)cell;

@end
/**
 点击按钮的回调函数
 */
typedef void (^UserpicAndnameClick)();
/**显示消息中心的TableViewCell, 包括：@我，评论了我，关注了我，赞了我 */
@interface MessageListTableViewCell : UITableViewCell

/**发送时间*/
@property(weak, nonatomic) IBOutlet UILabel *ctimeLabel;
/**用户头像*/
@property(weak, nonatomic) IBOutlet RoundHeadImage *headerImageView;
/**用户评级控件*/
@property(weak, nonatomic) IBOutlet UserGradeView *nickMarks;
/**小红点*/
@property(weak, nonatomic) IBOutlet UIImageView *redDotImageView;
/**带气泡回复框*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *grayCoreTextView;

/**原始回复框*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *replayCoreTextView;
/**气泡*/
@property(weak, nonatomic) IBOutlet UIView *bubbleView;
/**回复气泡小箭头*/
@property(weak, nonatomic) IBOutlet UIImageView *arrowImageView;
/**cell分割线*/
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitView;
/**新回复的控件高度*/
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *replyHeight;
/**原创聊股内容的高度*/
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *sourceHeight;

- (void)bindMessageListItem:(MessageListItem *)message andBtnClick:(UserpicAndnameClick)block;
+ (CGFloat)cellHeightWithMessage:(MessageListItem *)message
                withFontSize:(float)fontSize;
@end
