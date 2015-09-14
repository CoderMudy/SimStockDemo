//
//  WBReplyBox.h
//  SimuStock
//
//  Created by jhss on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetListItem.h"

@interface WBReplyBox : UIView

/** 聊股吧可变高度 */
+ (float)heightOfReplyBoxWithContent:(TweetListItem *)item;

/** l聊股吧 回复框 */
+ (UIView *)createReplyBoxOfTalkBarWithItem:(TweetListItem *)item;

/** 聊股内容 楼层回复框 */
+ (UIView *)createReplyBoxOfFloorWithNickName:(NSString *)nickName
                             withReplyContent:(NSString *)content
                                withReplyTime:(NSString *)replyTime
                              withFloorNumber:(NSString *)floorNum
                               withReplyImage:(NSString *)replyImage
                                     withRect:(CGRect)frame;
/** 聊股内容_标题回复框 */
+ (UIView *)createReplyBoxOfTitleWithTitle:(NSString *)replyContent
                            withReplyImage:(NSString *)replyImageStr
                                   withTSid:(NSString *)tstockId
                                  withRect:(CGRect)frame
                                  withItem:(TweetListItem *)item;

@end
