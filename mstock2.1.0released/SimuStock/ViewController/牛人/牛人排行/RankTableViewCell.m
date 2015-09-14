//
//  RankTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15-4-23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RankTableViewCell.h"
#import "SimuUtil.h"
#import "UIImage+ColorTransformToImage.h"
#import "StockPositionViewController.h"
#import "HomepageViewController.h"
#import "GameWebViewController.h"

@implementation RankTableViewCell

- (void)awakeFromNib {

  if (_flowerView.gestureRecognizers.count == 0) {
    [_flowerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onTapUserGrade)]];
  }

  UIImage *positionInfoImage = [UIImage imageFromView:_userPositionInfoButton
                                  withBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
  [_userPositionInfoButton setBackgroundImage:positionInfoImage forState:UIControlStateHighlighted];
  [_successRateBtn setBackgroundImage:positionInfoImage forState:UIControlStateHighlighted];
  [_tradeNumBtn setBackgroundImage:positionInfoImage forState:UIControlStateHighlighted];
  [_fansNumBtn setBackgroundImage:positionInfoImage forState:UIControlStateHighlighted];

  /**
   * 由于需求变动，持仓按钮（_userPositionInfoButton）以及成功率按钮（_successRateBtn）响应方法发生变化，持仓为左下第一个按钮，成功率为左下第二个按钮，
   */
  //持仓按钮触发的方法
  [_userPositionInfoButton addTarget:self
                              action:@selector(showMainInfo:)
                    forControlEvents:UIControlEventTouchUpInside];
  //成功率按钮的触发方法
  //  [_successRateBtn addTarget:self
  //                      action:@selector(showPositionInfoView:)
  //            forControlEvents:UIControlEventTouchUpInside];
  [_tradeNumBtn addTarget:self
                   action:@selector(showMainInfo:)
         forControlEvents:UIControlEventTouchUpInside];
  [_fansNumBtn addTarget:self
                  action:@selector(showMainInfo:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapUserGrade {
  if (_rankingListItem == nil) {
    return;
  }
  //花转一圈
  [UIView animateWithDuration:0.1
      animations:^{
        _flowerView.transform = CGAffineTransformRotate(_flowerView.transform, (M_PI));
      }
      completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1
            animations:^{
              _flowerView.transform = CGAffineTransformRotate(_flowerView.transform, (M_PI));
            }
            completion:^(BOOL finished) {

              if (_rankingListItem.mUserID) {
                [GameWebViewController showUserGradeReportWithUserId:_rankingListItem.mUserID];
              }
            }];
      }];
}

- (void)leftNumberShowView:(UIView *)leftView
             withCellIndex:(NSInteger)cellIndex
                withMyRank:(NSString *)myRank {

  [leftView removeAllSubviews];
  //名次设计
  switch (cellIndex) {
  case -1: {
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 24, 46, 12)];
    if ([myRank integerValue] > 100000) {
      leftLabel.text = @"10万+";
      NSString *str = [NSString stringWithFormat:@"%ld万+", (long)([myRank integerValue] / 10000)];
      leftLabel.text = str;
    } else
      leftLabel.text = myRank;
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = [Globle colorFromHexRGB:@"0c5585"];
    leftLabel.font = [UIFont boldSystemFontOfSize:11];
    [leftView addSubview:leftLabel];
  } break;
  case 0: {
    UIImageView *firstRow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 26, 25)];
    firstRow.image = [UIImage imageNamed:@"排行_1"];
    [leftView addSubview:firstRow];
  } break;
  case 1: {
    UIImageView *firstRow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 26, 25)];
    firstRow.image = [UIImage imageNamed:@"排行_1"];
    [leftView addSubview:firstRow];
  } break;
  case 2: {
    UIImageView *seconRow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 26, 25)];
    seconRow.image = [UIImage imageNamed:@"排行_2"];
    [leftView addSubview:seconRow];
  } break;
  case 3: {
    UIImageView *thirdRow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 26, 25)];
    thirdRow.image = [UIImage imageNamed:@"排行_3"];
    [leftView addSubview:thirdRow];
  } break;
  default: {
    if (cellIndex < 10) { //一位
      NSString *theUnitNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex % 10)];
      UIImage *theUnitImage = [UIImage imageNamed:theUnitNumber];
      CGSize theUnitImageSize = theUnitImage.size;
      theUnitImageSize = CGSizeMake(theUnitImageSize.width / 2, theUnitImageSize.height / 2);
      UIImageView *theUnitImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theUnitImageSize.width, theUnitImageSize.height)];
      theUnitImageView.image = theUnitImage;
      //确定image的位置
      CGRect frame = theUnitImageView.frame;
      theUnitImageView.frame =
          CGRectMake((47 - frame.size.width) / 2, 23, frame.size.width, frame.size.height);
      [leftView addSubview:theUnitImageView];
    } else if (cellIndex <= 99) //两位
    {
      NSString *theUnitNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex % 10)];
      NSString *theTensNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex % 100 / 10)];
      UIImage *theUnitImage = [UIImage imageNamed:theUnitNumber];
      UIImage *tensImage = [UIImage imageNamed:theTensNumber];
      CGSize theUnitImageSize = theUnitImage.size;
      CGSize tensImageSize = tensImage.size;
      theUnitImageSize = CGSizeMake(theUnitImageSize.width / 2, theUnitImageSize.height / 2);
      tensImageSize = CGSizeMake(tensImageSize.width / 2, tensImageSize.height / 2);
      UIImageView *theTensImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tensImageSize.width, tensImageSize.height)];
      UIImageView *theUnitImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theUnitImageSize.width, theUnitImageSize.height)];
      theTensImageView.image = tensImage;
      theUnitImageView.image = theUnitImage;
      //确定image的位置
      CGRect frame1 = theTensImageView.frame;
      CGRect frame2 = theUnitImageView.frame;
      theTensImageView.frame = CGRectMake((47 - frame1.size.width - frame2.size.width) / 2, 23,
                                          frame1.size.width, frame1.size.height);
      theUnitImageView.frame = CGRectMake((47 - frame1.size.width - frame2.size.width) / 2 + frame1.size.width,
                                          23, frame2.size.width, frame2.size.height);
      [leftView addSubview:theTensImageView];
      [leftView addSubview:theUnitImageView];
    } else //三位
    {
      NSString *theUnitNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex % 10)];
      NSString *theTensNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex % 100 / 10)];
      NSString *theHundredsNumber = [NSString stringWithFormat:@"%ld", (long)(cellIndex / 100)];
      UIImage *theUnitImage = [UIImage imageNamed:theUnitNumber];
      UIImage *tensImage = [UIImage imageNamed:theTensNumber];
      UIImage *hundredImage = [UIImage imageNamed:theHundredsNumber];
      CGSize theUnitImageSize = theUnitImage.size;
      CGSize theTensImageSize = tensImage.size;
      CGSize theHundredsImageSize = hundredImage.size;
      theUnitImageSize = CGSizeMake(theUnitImageSize.width / 2, theUnitImageSize.height / 2);
      theTensImageSize = CGSizeMake(theTensImageSize.width / 2, theTensImageSize.height / 2);
      theHundredsImageSize = CGSizeMake(theHundredsImageSize.width / 2, theHundredsImageSize.height / 2);
      UIImageView *theTensImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theUnitImageSize.width, theUnitImageSize.height)];
      UIImageView *theUnitImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theTensImageSize.width, theTensImageSize.height)];
      UIImageView *theHundredImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theHundredsImageSize.width, theHundredsImageSize.height)];
      theTensImageView.image = tensImage;
      theUnitImageView.image = theUnitImage;
      theHundredImageView.image = hundredImage;
      //确定image的位置
      CGRect frame1 = theTensImageView.frame;
      CGRect frame2 = theUnitImageView.frame;
      CGRect frame3 = theHundredImageView.frame;
      theUnitImageView.frame =
          CGRectMake((47 - frame1.size.width - frame2.size.width - frame3.size.width) / 2 + frame3.size.width,
                     23, frame1.size.width, frame1.size.height);
      theTensImageView.frame =
          CGRectMake((47 - frame1.size.width - frame2.size.width - frame3.size.width) / 2 +
                         frame3.size.width + frame2.size.width,
                     23, frame2.size.width, frame2.size.height);
      theHundredImageView.frame =
          CGRectMake((47 - frame1.size.width - frame2.size.width - frame3.size.width) / 2, 23,
                     frame3.size.width, frame3.size.height);
      [leftView addSubview:theTensImageView];
      [leftView addSubview:theUnitImageView];
      [leftView addSubview:theHundredImageView];
    }
  } break;
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (IBAction)userHeadImageBtn:(UIButton *)sender {
}

//持仓
- (void)showPositionInfoView:(UIButton *)button {
  //按钮色值还原
  [button setTitleColor:[Globle colorFromHexRGB:@"086dae"] forState:UIControlStateNormal];
  button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];

  [SimuUtil performBlockOnMainThread:^{
    button.backgroundColor = [UIColor clearColor];
    if (_rankingListItem.mUserID) {
      [AppDelegate pushViewControllerFromRight:[[StockPositionViewController alloc] initWithID:_rankingListItem.mUserID
                                                                                  withNickName:_rankingListItem.mNickName
                                                                                   withHeadPic:_rankingListItem.mHeadPic
                                                                                   withMatchID:@"1"
                                                                                   withViptype:[_rankingListItem.mVipType integerValue]
                                                                                  withUserItem:_rankingListItem.userListItem]];
    }
  } withDelaySeconds:0.2];
}

//主页
- (void)showMainInfo:(UIButton *)button {
  //按钮色值还原
  [button setTitleColor:[Globle colorFromHexRGB:@"086dae"] forState:UIControlStateNormal];
  button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];

  [SimuUtil performBlockOnMainThread:^{
    button.backgroundColor = [UIColor clearColor];
    if (_rankingListItem.mUserID)
      [HomepageViewController showWithUserId:_rankingListItem.mUserID
                                   titleName:_rankingListItem.mNickName
                                     matchId:MATCHID];
  } withDelaySeconds:0.2];
}

- (void)bindRankingListItem:(RankingListItem *)item
        withRankingSortName:(NSString *)rankingSortName {
  _rankingListItem = item;
  [_flowerView resetWithRating:item.userListItem.rating];
  _tradeNumberLabel.text = item.mTradeCount;
  _fansNumberLabel.text = item.mFansCount;
  [_headImageView bindUserListItem:_rankingListItem.userListItem];
  _userGradeView.showUserGrade = NO;
  _userGradeView.width = WIDTH_OF_SCREEN - 145;
  [_userGradeView bindUserListItem:_rankingListItem.userListItem isOriginalPoster:NO];

  _rankSortNameLabel.text = rankingSortName;
  if ([rankingSortName isEqualToString:@"（推荐指数）"] ||
      [rankingSortName isEqualToString:@"（人气值）"]) {
    _rankSortNumberLabel.text = item.mExponent;
    _rankSortNumberLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  } else if ([rankingSortName isEqualToString:@"（成功率）"]) {
    [_rankSortNumberLabel setAttributedText:[self settingUpmSuccessRateWith:item]];
    _rankSortNumberLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  } else if ([rankingSortName isEqualToString:@"（总盈利率）"] ||
             [rankingSortName isEqualToString:@"（周盈利率）"] ||
             [rankingSortName isEqualToString:@"（月盈利率）"]) {
    [_rankSortNumberLabel setAttributedText:[self settingUpmProfitRateLabelWith:item]];
    _rankSortNumberLabel.textColor = [StockUtil getColorByProfit:item.mProfitRate];
  } else {
    [_rankSortNumberLabel setAttributedText:[self settingUpmProfitRateLabelWith:item]];
    _rankSortNumberLabel.textColor = [StockUtil getColorByProfit:item.mProfitRate];
  }

  /** 判断总盈利率和成功率 */
  if ([rankingSortName isEqualToString:@"（总盈利率）"]) {
    _positionTitleLabel.text = @"成功率";
    [_positionNumberLabel setAttributedText:[self settingUpmSuccessRateWith:item]];
    _positionNumberLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    //总盈利率设置
  } else if ([rankingSortName isEqualToString:@"（周盈利率）"] ||
             [rankingSortName isEqualToString:@"（月盈利率）"]) {
    _positionTitleLabel.text = @"总盈利率";
    if (item.exponent && item.exponent.length != 0) {
      NSMutableAttributedString *str = [self getString:item.exponent];
      [_positionNumberLabel setAttributedText:str];
    }
    _positionNumberLabel.textColor = [StockUtil getColorByProfit:item.exponent];
  } else {
    _positionTitleLabel.text = @"总盈利率";
    [_positionNumberLabel setAttributedText:[self settingUpmProfitRateLabelWith:item]];
    _positionNumberLabel.textColor = [StockUtil getColorByProfit:item.mProfitRate];
  }

  /** 判断当前持仓和成功率 */
  if ([rankingSortName isEqualToString:@"（总盈利率）"] ||
      [rankingSortName isEqualToString:@"（成功率）"]) {
    //当前持仓
    _successLabel.text = @"当前持仓";
    _tradeSuccessRateLabel.text = item.mPositionCount;
    _tradeSuccessRateLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    [_successRateBtn addTarget:self
                        action:@selector(showPositionInfoView:)
              forControlEvents:UIControlEventTouchUpInside];
  } else {
    ///成功率设置
    _successLabel.text = @"成功率";
    [_tradeSuccessRateLabel setAttributedText:[self settingUpmSuccessRateWith:item]];
    _tradeSuccessRateLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    [_successRateBtn addTarget:self
                        action:@selector(showMainInfo:)
              forControlEvents:UIControlEventTouchUpInside];
  }
}
/** 盈利率 */
- (NSMutableAttributedString *)settingUpmProfitRateLabelWith:(RankingListItem *)item {
  NSMutableAttributedString *str = nil;
  if (item.mProfitRate && item.mProfitRate.length != 0) {
    str = [self getString:item.mProfitRate];
  }
  return str;
}
/** 成功率 */
- (NSMutableAttributedString *)settingUpmSuccessRateWith:(RankingListItem *)item {
  NSMutableAttributedString *str = nil;
  if (item.mSuccessRate && item.mSuccessRate.length != 0) {
    str = [self getString:item.mSuccessRate];
  }
  return str;
}
- (NSMutableAttributedString *)getString:(NSString *)str {

  NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:str];
  if ([str floatValue] > 0.0f) {
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, [Globle colorFromHexRGB:@"ca332a"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(0, str.length - 1)];
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:9], NSFontAttributeName, [Globle colorFromHexRGB:@"ca332a"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(str.length - 1, 1)];

  } else if ([str floatValue] < 0) {
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, [Globle colorFromHexRGB:@"5a8a02"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(0, str.length - 1)];
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:9], NSFontAttributeName, [Globle colorFromHexRGB:@"5a8a02"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(str.length - 1, 1)];

  } else {
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, [Globle colorFromHexRGB:@"454545"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(0, str.length - 1)];
    [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:9], NSFontAttributeName, [Globle colorFromHexRGB:@"454545"], NSForegroundColorAttributeName, nil]
                  range:NSMakeRange(str.length - 1, 1)];
  }

  return str1;
}
@end
