//
//  StockInformationTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockInformationTableViewCell : UITableViewCell
//蓝圆圈
@property(nonatomic, strong) CALayer *round;
@property(nonatomic, strong) UILabel *contentTitle;
@property(nonatomic, strong) UILabel *timeLab;
@end
