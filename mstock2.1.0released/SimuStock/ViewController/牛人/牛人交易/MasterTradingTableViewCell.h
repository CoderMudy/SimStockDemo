//
//  MasterTradingTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15-4-24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuUtil.h"
#import "RoundHeadImage.h"
#import "MasterTradeListWrapper.h"
#import "FTCoreTextView.h"
#import "UserGradeView.h"
#import "SeperatorLine.h"

/**牛人交易数据展示cell*/
@interface MasterTradingTableViewCell : UITableViewCell
/**时间*/
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

/**盈利性*/
@property(weak, nonatomic) IBOutlet UILabel *profitabilityLabel;
/**稳定性*/
@property(weak, nonatomic) IBOutlet UILabel *stabilityLabel;
/**准确性*/
@property(weak, nonatomic) IBOutlet UILabel *accuracyLabel;
/**五日回报*/
@property(weak, nonatomic) IBOutlet UILabel *fiveDaysPrLabel;
/**跟买按钮*/
@property(weak, nonatomic) IBOutlet BGColorUIButton *followBuyBtn;
/**头像背景*/
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;

@property(weak, nonatomic) IBOutlet UserGradeView *nickMarks;

@property (weak, nonatomic) IBOutlet UIView *contentBGView;
/**交易内容*/
@property(strong, nonatomic) IBOutlet FTCoreTextView *contentCTView;

/**跳转优顾评级Web按钮*/
@property(weak, nonatomic) IBOutlet UIButton *pushWebViewBtn;

- (void)bindConcludesListItem:(ConcludesListItem *)item;

@end
