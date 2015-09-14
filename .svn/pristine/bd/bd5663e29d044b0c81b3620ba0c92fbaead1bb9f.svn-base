//
//  MarketListTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketConst.h"


/**
 *  行情二级列表Cell
 */
@interface MarketListTableViewCell : UITableViewCell
/** 股票名称 */
@property(nonatomic, strong) UILabel *nameLab;
/** 最新价格 */
@property(nonatomic, strong) UILabel *curPriceLab;
/** 涨跌幅度 */
@property(nonatomic, strong) UILabel *dataPerLab;
/** 股票代码 */
@property(nonatomic, strong) UILabel *codeLab;
/** 上割线 */
@property(nonatomic, strong) UIView *upLineView;
/** 下割线 */
@property(nonatomic, strong) UIView *downLineView;


/** 绑定智能选股 */
-(void) bindRecommendStock:(NSDictionary*) dic
    withRecommendStockType:(RecommendStockType) recommendStockType;
@end
