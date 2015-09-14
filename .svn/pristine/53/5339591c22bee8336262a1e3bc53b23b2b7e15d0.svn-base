//
//  CompetitionCycleCell.m
//  SimuStock
//
//  Created by moulin wang on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CompetitionCycleCell.h"
#import "SimuUtil.h"

@implementation CompetitionCycleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createView];
  }
  return self;
}
- (void)createView {
  //钻石
  _diamondLab =
      [[UILabel alloc] initWithFrame:CGRectMake((46.0 + 35.0 + 26.0) / 2, (76.0 - 30.0) / 4, 80.0, 15.0)];
  _diamondLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _diamondLab.backgroundColor = [UIColor clearColor];
  _diamondLab.textAlignment = NSTextAlignmentLeft;
  _diamondLab.textColor = [UIColor blackColor];
  [self addSubview:_diamondLab];
  //购买周期或购买金额
  _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(190.0, (76.0 - 30.0) / 4, 50.0, 15.0)];
  _quantityLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _quantityLab.backgroundColor = [UIColor clearColor];
  _quantityLab.textAlignment = NSTextAlignmentLeft;
  _quantityLab.textColor = [UIColor blackColor];
  [self addSubview:_quantityLab];

  //底图圆
  UIImageView *bottomImageV =
      [[UIImageView alloc] initWithFrame:CGRectMake(46.0 / 2, (76.0 - 34.0) / 4, 34.0 / 2, 34.0 / 2)];
  [bottomImageV setImage:[UIImage imageNamed:@"单选_未选中"]];
  [self addSubview:bottomImageV];
  //选中状态的圆圈
  _circleImageV =
      [[UIImageView alloc] initWithFrame:CGRectMake(46.0 / 2, (76.0 - 34.0) / 4, 34.0 / 2, 34.0 / 2)];
  [_circleImageV setImage:[UIImage imageNamed:@"单选_选中图标"]];
  [self addSubview:_circleImageV];
  _circleImageV.hidden = YES;

  //新分栏线
  UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 76.0 / 2, WIDTH_OF_SCREEN, 1.0)];
  downView.backgroundColor = [Globle colorFromHexRGB:@"d8d8d8"];
  [self addSubview:downView];
}

@end
