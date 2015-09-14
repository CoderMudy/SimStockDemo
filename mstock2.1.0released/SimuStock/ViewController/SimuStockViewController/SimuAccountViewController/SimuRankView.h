//
//  SimuRankView.h
//  SimuStock
//
//  Created by Yuemeng on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimuRankPageData;
/*
 *  比赛账户持仓 周、月、总盈利view
 */
@interface SimuRankView : UIView
//周、月、总盈利
@property(weak, nonatomic) IBOutlet UILabel *wProfitLabel;
@property(weak, nonatomic) IBOutlet UILabel *mProfitLabel;
@property(weak, nonatomic) IBOutlet UILabel *tProfitLabel;
//周、月、总排名
@property(weak, nonatomic) IBOutlet UILabel *wRankLabel;
@property(weak, nonatomic) IBOutlet UILabel *mRankLabel;
@property(weak, nonatomic) IBOutlet UILabel *tRankLabel;
//周、月、总箭头
@property(weak, nonatomic) IBOutlet UIImageView *wArrow;
@property(weak, nonatomic) IBOutlet UIImageView *mArrow;
@property(weak, nonatomic) IBOutlet UIImageView *tArrow;
//周、月、总上升、下降名次
@property(weak, nonatomic) IBOutlet UILabel *wRise;
@property(weak, nonatomic) IBOutlet UILabel *mRise;
@property(weak, nonatomic) IBOutlet UILabel *tRise;

//左边距
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *spaceViewWidth;

- (void)setPagedata:(SimuRankPageData *)pagedata;

@end
