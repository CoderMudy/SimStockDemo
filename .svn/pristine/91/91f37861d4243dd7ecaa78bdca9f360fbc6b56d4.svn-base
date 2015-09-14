//
//  StockAlarmTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15-4-19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockAlarmEntity.h"
#import "CellBottomLinesView.h"
@interface StockAlarmTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *stockCodeLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *alarmContentLabel;
@property(weak, nonatomic) IBOutlet CellBottomLinesView *topSplitView;

- (void)bindStockAlarmMessage:(StockAlarmEntity *)stockAlarmData;

+ (CGFloat)cellHeightWithStockAlarmMessage:(StockAlarmEntity *)stockAlarmData;
@end
