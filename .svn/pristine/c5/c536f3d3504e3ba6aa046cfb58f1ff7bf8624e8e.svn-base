//
//  RechargeView.h
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiamondRechargeCell.h"

/*
 *类说明：钻石充值页面
 */
@interface RechargeView : UIView <UITableViewDataSource, UITableViewDelegate,
                                  DiamondRechargeCellDelegate> {
  /** 展示表格 */
  UITableView *rcv_tableview;
  /** 数据存储 */
  NSMutableArray *rcv_dataArray;
}
@property(weak, nonatomic) id<DiamondRechargeCellDelegate> delegate;
- (void)resetpagedata:(NSMutableArray *)diamondArray;

@end
