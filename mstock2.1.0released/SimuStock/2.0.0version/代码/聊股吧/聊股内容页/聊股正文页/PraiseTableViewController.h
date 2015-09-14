//
//  PraiseTableViewController.h
//  SimuStock
//
//  Created by Jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 聊股正文页  赞列表 */
#import "BaseTableViewController.h"

@interface PraiseTableAdapter : BaseTableAdapter

@end

@interface PraiseTableViewController : BaseTableViewController

/** 来自热门推荐中的聊股，tweetlistData  */
@property(strong, nonatomic) NSNumber *talkId;

- (id)initWithFrame:(CGRect)frame withtTalkId:(NSNumber *)talkId;

@end
