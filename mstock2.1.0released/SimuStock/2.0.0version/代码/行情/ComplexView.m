//
//  ComplexView.m
//  SimuStock
//
//  Created by moulin wang on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComplexView.h"
#import "SimuUtil.h"
@implementation ComplexView

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
  //股票名称和大盘名称
  _nameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 22.0 / 2, WIDTH_OF_SCREEN / 3.f, 30.0 / 2)];
  _nameLab.text = @"";
  _nameLab.textAlignment = NSTextAlignmentCenter;
  _nameLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  _nameLab.font = [UIFont systemFontOfSize:28.0 / 2];
  _nameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_nameLab];

  //箭头图标
  _arrowImage = [[UIImageView alloc]
      initWithFrame:CGRectMake(16.0, 31, 16.0 / 2, 25.0 / 2)];
  [self addSubview:_arrowImage];

  //行业涨幅
  _curPriceLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 29, WIDTH_OF_SCREEN / 3.f, 34.0 / 2)];
  _curPriceLab.text = @"";
  _curPriceLab.textAlignment = NSTextAlignmentCenter;
  _curPriceLab.textColor = [Globle colorFromHexRGB:Color_Red];
  _curPriceLab.font = [UIFont systemFontOfSize:18];
  _curPriceLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_curPriceLab];

  //领涨股名称
  _leaderNameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 98.0 / 2, WIDTH_OF_SCREEN / 3.f, 28.0 / 2)];
  _leaderNameLab.text = @"";
  _leaderNameLab.textAlignment = NSTextAlignmentCenter;
  _leaderNameLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  _leaderNameLab.font = [UIFont systemFontOfSize:26.0 / 2];
  _leaderNameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_leaderNameLab];

  //领涨股 价格+涨幅
  _changeLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 105.0 / 2, WIDTH_OF_SCREEN / 3.f, 22.0 / 2)];
  _changeLab.text = @"";
  _changeLab.textAlignment = NSTextAlignmentCenter;
  _changeLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  _changeLab.font = [UIFont systemFontOfSize:20.0 / 2];
  _changeLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_changeLab];
}

@end
