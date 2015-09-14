//
//  MarketHomeTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplexView.h"
#import "UIViewExt.h"

@protocol MarketHomeTableViewCellDelegate <NSObject>
@optional
- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag
                                  section:(NSInteger)section
                                      row:(NSInteger)row;
@end

/*
 *  行情分页cell
 */
@interface MarketHomeTableViewCell : UITableViewCell
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
/** 新股发行 */
@property(nonatomic, strong) UIView *latestStockView;
/** 存放表格 */
@property(nonatomic, strong) NSMutableArray *complextArray;
/** 存放按钮 */
@property(nonatomic, strong) NSMutableArray *btnArray;
/** 表格 */
@property(nonatomic, strong) ComplexView *complextView;

@property(nonatomic, strong) UIButton *jumpBtn;

/** 间隔线 */
@property(nonatomic, strong) UIView *lineViewA;
@property(nonatomic, strong) UIView *lineViewB;

/** 组 */
@property(nonatomic, assign) NSInteger sectionInt;
/** 行 */
@property(nonatomic, assign) NSInteger rowInt;

@property(nonatomic, weak) id<MarketHomeTableViewCellDelegate> delegate;
@end
