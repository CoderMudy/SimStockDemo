//
//  StockPositionInfoTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuRankPositionPageData.h"
#import "UIButton+Block.h"

typedef void (^PositonCellButtonCallback)(PositionInfo *positionInfo);

static CGFloat FoldHeight = 90.f;
static CGFloat UnFoldHeight = 210.f;

@interface StockPositionInfoTableViewCell : UITableViewCell

///持仓率
@property(weak, nonatomic) IBOutlet UILabel *lblPositionRate;

///股票名称和代码
@property(weak, nonatomic) IBOutlet UILabel *lblStock;

///盈亏金额
@property(weak, nonatomic) IBOutlet UILabel *lblProfit;

///当前价
@property(weak, nonatomic) IBOutlet UILabel *lblCurPrice;

///成本价
@property(weak, nonatomic) IBOutlet UILabel *lblBuyPrice;

///持股数量
@property(weak, nonatomic) IBOutlet UILabel *lblStockAmount;

///持股市值
@property(weak, nonatomic) IBOutlet UILabel *lblPositonStockValue;

///左侧圆角粗线
@property(weak, nonatomic) IBOutlet UIImageView *ivLine;

///右下角三角形
@property(weak, nonatomic) IBOutlet UIImageView *ivTriangle;

///分割线
@property(weak, nonatomic) IBOutlet UIView *splitLine;

@property(weak, nonatomic) IBOutlet BGColorUIButton *btnBuy;
@property(weak, nonatomic) IBOutlet BGColorUIButton *btnSell;

@property(weak, nonatomic) IBOutlet BGColorUIButton *btnMarket;
@property(weak, nonatomic) IBOutlet BGColorUIButton *btnTradeList;
@property(weak, nonatomic) IBOutlet UIView *buttonContainer;

@property(strong, nonatomic) PositionInfo *positionInfo;

@property(copy, nonatomic) PositonCellButtonCallback buyAction;
@property(copy, nonatomic) PositonCellButtonCallback sellAction;
@property(copy, nonatomic) PositonCellButtonCallback marketAction;
@property(copy, nonatomic) PositonCellButtonCallback tradeListAction;

@property(assign, nonatomic) BOOL showSellableAmount;

/** 绑定持仓信息 */
- (void)bindPositionInfo:(PositionInfo *)positionInfo;

///展开或收缩
- (void)fold:(BOOL)fold;

@end
