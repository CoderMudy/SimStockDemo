//
//  StockInformationTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockInformationTableViewCell.h"
#import "SimuUtil.h"
@implementation StockInformationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createacontrolmethod];
  }
  return self;
}
- (void)createacontrolmethod {
  self.round = [CALayer layer];
  self.round.frame = CGRectMake(38.0f / 2, (103.0f - 20.0f) / 4, 20.0f / 2, 20.0f / 2);
  self.round.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  self.round.cornerRadius = 20.0 / 4;
  [self.layer addSublayer:self.round];

  _contentTitle =
      [[UILabel alloc] initWithFrame:CGRectMake((38.0 + 20.0 + 25.0) / 2, 7.0,
                                                WIDTH_OF_SCREEN - (38.0 + 20.0 + 25.0 + 20.0) / 2 - 5, 80.0 / 2)];
  _contentTitle.text = @"";
  _contentTitle.textAlignment = NSTextAlignmentLeft;
  _contentTitle.backgroundColor = [UIColor clearColor];
  _contentTitle.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  _contentTitle.font = [UIFont systemFontOfSize:15];
  _contentTitle.numberOfLines = 0;
  [self addSubview:_contentTitle];

  //时间
  _timeLab =
      [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 20.0 / 2 - 110.0, 62.0 / 2, 110.0, 11)];
  _timeLab.textAlignment = NSTextAlignmentRight;
  _timeLab.backgroundColor = [UIColor clearColor];
  _timeLab.font = [UIFont systemFontOfSize:Font_Height_10_0];
  _timeLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  _timeLab.text = @"2014年04月15日 10:38";
  [self addSubview:_timeLab];
  //新分栏线
  UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 101.0 / 2, WIDTH_OF_SCREEN, 0.5)];
  downView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:downView];
  UIView *_downLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 101.0 / 2 + 0.5, WIDTH_OF_SCREEN, 0.5)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_downLineView];
}

@end
