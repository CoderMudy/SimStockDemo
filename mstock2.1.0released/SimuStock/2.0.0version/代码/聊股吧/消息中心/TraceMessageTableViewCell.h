//
//  TraceMessageTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "TraceMessageList.h"
#import "CellBottomLinesView.h"
@interface TraceMessageTableViewCell : UITableViewCell
/**追踪消息标题*/
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
/**追踪消息按钮*/
@property(weak, nonatomic) IBOutlet UIButton *handleBtn;
/**追踪消息时间*/
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
/**cell分割线*/
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomSpliteView;
/**追踪消息内容*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *traceMessageContentCTView;
/**追踪消息来源*/
@property(weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property(weak, nonatomic) IBOutlet UIView *verticalLineView;
- (void)bindTraceMessage:(TraceMsgData *)traceMsgData;
+ (int)cellHeightWithMessage:(TraceMsgData *)message
                withMsgWidth:(int)msgWidth
                withFontSize:(float)fontSize;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *msgViewHeight;
@end
