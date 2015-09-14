//
//  HomePageProfitSuperView.h
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSimuProfitLineView.h"
#import "HomePageTableHeaderData.h"

@interface HomePageProfitSuperView : UIView

/** 总盈利 */
@property(weak, nonatomic) IBOutlet UILabel *totalProfitRate;
/** 盈利曲线 */
//@property (strong, nonatomic) HomeSimuProfitLineView *profitCurveView;
@property(strong, nonatomic) IBOutlet HomeSimuProfitLineView *profitCurveView;

@property(strong, nonatomic) IBOutlet UIView *profitLineView;
/** 周盈利率 */
@property(weak, nonatomic) IBOutlet UILabel *weekProfitLabel;
/**  周 上升箭头 */
@property(weak, nonatomic) IBOutlet UIImageView *weekImageView;
/**  周排名 */
@property(weak, nonatomic) IBOutlet UILabel *weekRankNumLabel;
/** 周上升名次 */
@property(weak, nonatomic) IBOutlet UILabel *weekRankRiseLabel;
/** 月盈利率 */
@property(weak, nonatomic) IBOutlet UILabel *monthProfitLabel;
/** 月排名 */
@property(weak, nonatomic) IBOutlet UILabel *monthRankNumLabel;
/** 月上升名次 */
@property(weak, nonatomic) IBOutlet UILabel *monthRankRiseLabel;
/** 月 上升箭头 */
@property(weak, nonatomic) IBOutlet UIImageView *monthImageView;
/** 表头数据 */
@property(strong, nonatomic) HomePageTableHeaderData *personalData;
/** 判断是谁的收益 */
@property (weak, nonatomic) IBOutlet UILabel *isWhoEarningsLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineDown;

- (void)bindPersonalRankInfoData:(HomePageTableHeaderData *)informationDic;

@end
