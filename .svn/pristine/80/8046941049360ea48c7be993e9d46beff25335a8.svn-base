//
//  GainersView.m
//  SimuStock
//
//  Created by moulin wang on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GainersView.h"
#import "SimuUtil.h"

@implementation GainersView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self createView];
  }
  return self;
}
- (void)createView {
  _nameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(20.0f / 2, 24.0f / 2 - 2.0f,
                               self.bounds.size.width - 20.0f / 2 - 10.0f,
                               30.0f / 2)];
  _nameLab.text = @"";
  _nameLab.textAlignment = NSTextAlignmentCenter;
  _nameLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _nameLab.font = [UIFont boldSystemFontOfSize:Font_Height_14_0];
  _nameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_nameLab];

  _gainView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, 36.0, 0.0, 42.0f / 2)];
  _gainView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self addSubview:_gainView];

  //涨幅名称
  self.gainTitleLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0.0, 5.0, 80.0f / 2, 22.0f / 2)];
  self.gainTitleLab.textAlignment = NSTextAlignmentLeft;
  self.gainTitleLab.text = @"涨幅";
  self.gainTitleLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  self.gainTitleLab.font = [UIFont boldSystemFontOfSize:Font_Height_10_0];
  self.gainTitleLab.backgroundColor = [UIColor clearColor];
  [_gainView addSubview:self.gainTitleLab];
  _arrowsImageV = [[UIImageView alloc]
      initWithFrame:CGRectMake(45.0f / 2 + 12.0f / 2 + 30.0f / 2, 5.0,
                               15.0f / 2, 20.0f / 2)];
  _arrowsImageV.image = [UIImage imageNamed:@""];
  _arrowsImageV.backgroundColor = [UIColor clearColor];
  [_gainView addSubview:_arrowsImageV];
  //涨幅
  _gainLab = [[UILabel alloc]
      initWithFrame:CGRectMake(45.0 / 2 + 12.0 / 2 + 15.0 / 2 + 24.0 / 2 +
                                   20.0f / 2,
                               0.0, self.bounds.size.width -
                                        (20.0 / 2 + 45.0 / 2 + 12.0 / 2 +
                                         15.0 / 2 + 24.0 / 2 - 5.0),
                               42.0f / 2)];
  _gainLab.text = @"";
  _gainLab.textAlignment = NSTextAlignmentLeft;
  _gainLab.textColor = [Globle colorFromHexRGB:Color_Red];
  _gainLab.font = [UIFont boldSystemFontOfSize:20.0];
  _gainLab.backgroundColor = [UIColor clearColor];
  [_gainView addSubview:_gainLab];

  _curPriView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, 67.0, 0.0, 42.0f / 2)];
  _curPriView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self addSubview:_curPriView];

  //最新价名称
  _priceTitleLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0.0, 5.0, 80.0f / 2, 22.0f / 2)];
  _priceTitleLab.textAlignment = NSTextAlignmentLeft;
  _priceTitleLab.text = @"最新价：";
  _priceTitleLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  _priceTitleLab.font = [UIFont boldSystemFontOfSize:Font_Height_10_0];
  _priceTitleLab.backgroundColor = [UIColor clearColor];
  [_curPriView addSubview:_priceTitleLab];

  _priceLab = [[UILabel alloc]
      initWithFrame:CGRectMake(45.0f / 2 + 12.0f / 2 + 30.0f / 2 + 2.0, 5.0,
                               self.bounds.size.width -
                                   (30.0 / 2 + 45.0 / 2 + 12.0 / 2 + 15.0 / 2 +
                                    24.0 / 2 - 3.0),
                               20.0f / 2)];
  _priceLab.text = @"";
  _priceLab.textAlignment = NSTextAlignmentLeft;
  _priceLab.textColor = [Globle colorFromHexRGB:Color_Red];
  _priceLab.font = [UIFont boldSystemFontOfSize:Font_Height_10_0];
  _priceLab.backgroundColor = [UIColor clearColor];
  [_curPriView addSubview:_priceLab];
}

@end
