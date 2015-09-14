//
//  SameStockHeroTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SameStockHeroTableViewCell.h"
#import "GameWebViewController.h"

@implementation SameStockHeroTableViewCell {
  SameStockHero *_hero;
}

- (void)awakeFromNib {
  [super awakeFromNib];

  if (_btnUserRank.gestureRecognizers.count == 0) {
    [_btnUserRank
        addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                         action:@selector(onTapUserGrade)]];
  }
}

- (void)onTapUserGrade {
  if (_hero == nil) {
    return;
  }

  __weak SameStockHeroTableViewCell *weakSelf = self;
  //花转一圈
  [UIView animateWithDuration:0.1
      animations:^{
        [weakSelf rotateFlower];
      }
      completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1
            animations:^{
              [weakSelf rotateFlower];
            }
            completion:^(BOOL finished) {
              [weakSelf showUserGrade];
            }];
      }];
}

- (void)rotateFlower {
  _btnUserRank.transform =
      CGAffineTransformRotate(_btnUserRank.transform, (M_PI));
}

- (void)showUserGrade {
  NSString *userid = [_hero.user.userId stringValue];

  if (userid) {
    [GameWebViewController showUserGradeReportWithUserId:userid];
  }
}

- (void)bindSameStockHero:(SameStockHero *)hero
          withPriceFormat:(NSString*)format
            withTableView:(UITableView *)tableView
            withIndexPath:(NSIndexPath *)indexPath {
  _hero = hero;
  self.lblListRank.text = [NSString stringWithFormat:@"%ld", (long)hero.rank];
  self.valueProfitRate.text =
      [NSString stringWithFormat:@"%.2f%%", hero.positionProfitRate * 100.0f];
  self.valueProfitRate.textColor =
      [StockUtil getColorByFloat:hero.positionProfitRate];

  self.valueCostPrice.text =
      [NSString stringWithFormat:format, hero.costPrice];

  self.valueHoldDuration.text =
      [NSString stringWithFormat:@"%ld天", (long)hero.positionDays];

  UserListItem *user = hero.user;

  [_imgUserHeadPic bindUserListItem:user];

  [_btnUserRank resetWithRating:user.rating];
//  if (user.rating.length > 0) {
//    _lblTipUserRank.hidden = NO;
//  } else {
//    _lblTipUserRank.hidden = YES;
//  }
  _userNickMark.showUserGrade = NO;
  [_userNickMark bindUserListItem:user isOriginalPoster:NO];
}

@end
