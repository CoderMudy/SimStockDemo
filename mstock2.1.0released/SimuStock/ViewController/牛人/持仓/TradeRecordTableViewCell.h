//
//  TradeRecordTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "SimuClosedDetailPageData.h"

typedef void (^TradeInfoCellButtonCallback)(ClosedDetailInfo *tradeInfo);

@interface TradeRecordTableViewCell : UITableViewCell
///时间线上部分
@property(weak, nonatomic) IBOutlet UIView *timeLineUp;
///时间线下部分
@property(weak, nonatomic) IBOutlet UIView *timeLineDown;

///买、卖、分红图标的白底
@property(weak, nonatomic) IBOutlet UIView *bgWhite;
///买、卖、分红图标的蓝底
@property(weak, nonatomic) IBOutlet UIView *bgLogo;
///买、卖、分红图标
@property(weak, nonatomic) IBOutlet UIImageView *ivLogo;

///交易时间
@property(weak, nonatomic) IBOutlet UILabel *lblTime;

///交易内容
@property(weak, nonatomic) IBOutlet FTCoreTextView *tradeInfoView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tradeInfoHeight;

///买按钮
@property(weak, nonatomic) IBOutlet UIButton *btnBuy;
///卖按钮
@property(weak, nonatomic) IBOutlet UIButton *btnSell;
///分割线
@property(weak, nonatomic) IBOutlet UIView *splitLine;

@property(strong, nonatomic) ClosedDetailInfo *tradeRecordInfo;

@property(copy, nonatomic) TradeInfoCellButtonCallback buyAction;
@property(copy, nonatomic) TradeInfoCellButtonCallback sellAction;

+ (CGFloat)adjustHeightForTradeRecord:(ClosedDetailInfo *)tradeRecord;

- (void)bindClosedDetailInfo:(ClosedDetailInfo *)info;

@end
