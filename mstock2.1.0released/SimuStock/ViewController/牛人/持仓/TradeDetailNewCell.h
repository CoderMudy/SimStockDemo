//
//  TradeDetailNewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuClosedDetailPageData.h"
#import "SimuPositionPageData.h"

#import "FullScreenLogonViewController.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "TrendViewController.h"
#import "FTCoreTextView.h"
#import "TweetListItem.h"

/*
 *  交易明细XIB cell
 */
@interface TradeDetailNewCell : UITableViewCell

/**  交易类型图片*/
@property(weak, nonatomic) IBOutlet UIImageView *tradeImageView;
/**  交易时间*/
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
/**  交易类型图片下面的view*/
@property(weak, nonatomic) IBOutlet UIImageView *tradeBackImage;

/**  买入按钮*/
@property(nonatomic, weak) IBOutlet UIButton *buyBtn;

/**  卖出按钮*/
@property(weak, nonatomic) IBOutlet UIButton *selBtn;

/**   竖分割线*/
@property(weak, nonatomic) IBOutlet UIView *firstLineView;

/**   竖分割线*/
@property(weak, nonatomic) IBOutlet UIView *secondLineView;

/**   股票信息*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *coreTextView;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *coreTextHeight;

/**  分割线*/
@property(weak, nonatomic) IBOutlet UIView *cuttingLine;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *grayLineHeightV;
@property(weak, nonatomic) IBOutlet UIImageView *whiteImageView;
/**  竖分割线*/
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bigGrayWidth;
/**  竖分割线*/
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *smallGrayWidth;

@property(strong, nonatomic) ClosedDetailInfo *info;
@property(assign, nonatomic) BOOL showButtons;

- (void)bindClosedDetailInfo:(ClosedDetailInfo *)info;

/**
 *  设置卖出按钮是否可以点击
 *
 */
- (void)enableSellButton:(BOOL)enable;

+ (CGFloat)cellHeightWithTweetListItem:(ClosedDetailInfo *)info withShowButtons:(BOOL)showButtons;

@end
