//
//  ExpertScreeningTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertFilterTableViewCell.h"
#import "ExpertFilterListWrapper.h"
#import "RoundHeadImage.h"
#import "UserGradeView.h"
#import "StockUtil.h"

@implementation ExpertFilterTableViewCell

- (void)bindExpertFilterItem:(ExpertFilterListItem *)item
                 withSortNum:(NSNumber *)sortNum
                withSelected:(BOOL)selected {

  if (selected) {
    _expandTriangleImgView.hidden = YES;
    _filterInfoBottomView.hidden = NO;
  } else {
    _expandTriangleImgView.hidden = NO;
    _filterInfoBottomView.hidden = YES;
  }

  ([sortNum intValue] <= 3) ? (_sortNumberLab.textColor = [Globle colorFromHexRGB:@"#f51f1f"])
                            : (_sortNumberLab.textColor = [Globle colorFromHexRGB:@"#454545"]);

  _sortNumberLab.text = [sortNum stringValue];
  [_headImageView bindlittleCattleUserListItem:item.writer];
  [_userGradeView bindUserListItem:item.writer isOriginalPoster:NO];

  self.grossProfitRateLab.textColor = [StockUtil getColorByProfit:[@(item.totalProfitRate) stringValue]];
  self.grossProfitRateLab.text = [NSString stringWithFormat:@"%0.2f%%", item.totalProfitRate * 100];

  self.grossProfitRateLab.textColor = [StockUtil getColorByProfit:[@(item.monthAvgProfitRate) stringValue]];
  self.monthAverageIncomeLab.text = [NSString stringWithFormat:@"%0.2f%%", item.monthAvgProfitRate * 100];

  self.successRateLab.text = [NSString stringWithFormat:@"%0.2f%%", item.sucRate * 100];
  self.averageNumberOfSharesLab.text = [NSString stringWithFormat:@"%0.1f", item.avgDays];
  self.beyondShangHaiIndexLab.text = [NSString stringWithFormat:@"%0.2f%%", item.winRate * 100];

  self.annualYieldLab.textColor = [StockUtil getColorByProfit:[@(item.annualProfit) stringValue]];
  self.annualYieldLab.text = [NSString stringWithFormat:@"%0.2f%%", item.annualProfit * 100];

  self.maximumRetracementLab.text = [NSString stringWithFormat:@"%0.2f%%", item.maxBackRate * 100];
  self.retracementAccountLab.text = [NSString stringWithFormat:@"%0.2f%%", item.backRate * 100];
  self.tradeNumLab.text = [@(item.closeNum) stringValue];
  self.accountProfitLab.text = [NSString stringWithFormat:@"%0.2f%%", item.profitDaysRate * 100];
}

//展开或收缩
- (void)cellFold:(BOOL)fold {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(stop)];
  CGFloat height = fold ? EFTableViewCellFoldHeight : EFTableViewCellUnFoldHeight;
  _expandTriangleImgView.hidden = !fold;
  _filterInfoBottomView.hidden = fold;
  self.frame = CGRectMake(0, 0, self.frame.size.width, height);

  [UIView commitAnimations];
}
@end
