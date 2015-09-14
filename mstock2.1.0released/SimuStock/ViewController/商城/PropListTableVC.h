//
//  PropListTableVC.h
//  SimuStock
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "StoreUtil.h"

/**
 *  商品类型
 */
typedef NS_ENUM(NSUInteger, CommodityType) {
  /**
   *  资金卡类型
   */
  CommodityTypeFundCard = 1,
  /**
   *  道具类型：追踪卡、Vip、重置卡
   */
  CommodityTypeProp = 2
};

@interface PropListTableAdapter : BaseTableAdapter

@end

@interface PropListTableVC : BaseTableViewController {
  //详情背景图
  UIView *detailBackgroundView;
  UIImageView *whiteView;
}

@property(nonatomic, assign) CommodityType commodityType;

//商城兑换、支付工具类
@property(strong, nonatomic) StoreUtil *storeUtil;

/**
 * 指定Frame，指定商品页类型
 */
- (id)initWithFrame:(CGRect)frame
  withCommodityType:(CommodityType)commodityType;

- (void)detail:(NSString *)commondityDetail;

@end
