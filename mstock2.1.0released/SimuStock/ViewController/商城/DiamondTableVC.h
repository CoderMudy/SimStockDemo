//
//  DiamondTableVC.h
//  SimuStock
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DiamondRechargeCell.h"


@interface DiamondTableAdapter : BaseTableAdapter


@end

@interface DiamondTableVC : BaseTableViewController
/**
 *  商品购买代理
 */
@property(weak, nonatomic) id<DiamondRechargeCellDelegate> propBuyDelegate;

@end