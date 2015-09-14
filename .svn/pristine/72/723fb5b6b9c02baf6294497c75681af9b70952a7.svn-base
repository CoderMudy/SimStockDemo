//
//  SystemMessageTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "SystemMessageList.h"
#import "CellBottomLinesView.h"

@interface SystemMessageTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitView;

@property(strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(strong, nonatomic) IBOutlet UILabel *ctimeLabel;
@property(weak, nonatomic) IBOutlet FTCoreTextView *messageSystemView;
- (void)bindTraceMessage:(SystemMsgData *)systemMsgData;
+ (int)cellHeightWithSystemMsg:(SystemMsgData *)message
                  withMsgWidth:(int)msgWidth
                  withFontSize:(float)fontSize;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeight;
@end
