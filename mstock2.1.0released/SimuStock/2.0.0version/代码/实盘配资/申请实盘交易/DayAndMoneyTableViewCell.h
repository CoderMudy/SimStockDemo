//
//  DayAndMoneyTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayAndMoneyView.h"

@class WFProductListInfo;

@interface DayAndMoneyTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleLabelsmall;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(copy, nonatomic) NSMutableArray *mainArray;
@property(weak, nonatomic) IBOutlet DayAndMoneyView *selectedButtons;

- (void)bindDays:(NSArray *)days;
- (void)bindMoney:(WFProductListInfo *)productInfo;
@end
