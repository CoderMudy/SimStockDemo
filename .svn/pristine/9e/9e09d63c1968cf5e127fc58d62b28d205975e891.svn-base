//
//  SimuGainsView.m
//  SimuStock
//
//  Created by Mac on 13-8-17.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuGainsView.h"
#import "SimuUtil.h"
#import "StockUtil.h"

@implementation SimuGainsView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self creatcontrol];
  }
  return self;
}

- (void)creatcontrol {
  sgv_backimageRect =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  //上边线（暗色）
  UIView *_upLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0, self.bounds.size.width, 1)];
  _upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_upLineView];
  //上边线（亮色）
  UIView *_downLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 1, self.bounds.size.width, 1)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_downLineView];

  //上边线（暗色）
  UIView *_upLineView2 =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - 2,
                                               self.bounds.size.width, 1)];
  _upLineView2.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_upLineView2];
  //上边线（亮色）
  UIView *_downLineView2 =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - 1,
                                               self.bounds.size.width, 1)];
  _downLineView2.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_downLineView2];
  //创建纵向分割线
  UIImage *lineimage = [UIImage imageNamed:@"SST_YK_line.png"];
  CGRect linerect =
      CGRectMake(0, 0, lineimage.size.width / [UIScreen mainScreen].scale,
                 lineimage.size.height / [UIScreen mainScreen].scale);
  CGFloat width = sgv_backimageRect.size.width / 4.0;
  CGFloat height = sgv_backimageRect.size.height / 2.0;
  //分割线1
  UIView *sgv_sepLineImageViewleft =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageViewleft.backgroundColor =
      [Globle colorFromHexRGB:Color_Cell_Line];
  sgv_sepLineImageViewleft.bounds = linerect;
  sgv_sepLineImageViewleft.center = CGPointMake(width, height);
  [self addSubview:sgv_sepLineImageViewleft];

  UIView *sgv_sepLineImageViewright =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageViewright.backgroundColor = [UIColor whiteColor];
  sgv_sepLineImageViewright.bounds = linerect;
  sgv_sepLineImageViewright.center = CGPointMake(width + 1, height);
  [self addSubview:sgv_sepLineImageViewright];
  //分割线2
  UIView *sgv_sepLineImageView2left =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageView2left.backgroundColor =
      [Globle colorFromHexRGB:Color_Cell_Line];
  sgv_sepLineImageView2left.bounds = linerect;
  sgv_sepLineImageView2left.center = CGPointMake(2 * width, height);
  [self addSubview:sgv_sepLineImageView2left];

  UIView *sgv_sepLineImageView2right =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageView2right.backgroundColor = [UIColor whiteColor];
  sgv_sepLineImageView2right.bounds = linerect;
  sgv_sepLineImageView2right.center = CGPointMake(2 * width + 1, height);
  [self addSubview:sgv_sepLineImageView2right];

  //分割线3
  UIView *sgv_sepLineImageView3left =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageView3left.bounds = linerect;
  sgv_sepLineImageView3left.center = CGPointMake(3 * width, height);
  sgv_sepLineImageView3left.backgroundColor =
      [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:sgv_sepLineImageView3left];

  UIView *sgv_sepLineImageView3right =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineimage.size.height)];
  sgv_sepLineImageView3right.backgroundColor = [UIColor whiteColor];
  sgv_sepLineImageView3right.bounds = linerect;
  sgv_sepLineImageView3right.center = CGPointMake(3 * width + 1, height);
  [self addSubview:sgv_sepLineImageView3right];
  //浮动盈亏标题
  CGRect floatrect = CGRectMake(0, 4, width, height);
  sgv_floatProfitLable = [[UILabel alloc] initWithFrame:floatrect];
  sgv_floatProfitLable.backgroundColor = [UIColor clearColor];
  sgv_floatProfitLable.text = @"持仓盈亏";
  sgv_floatProfitLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  sgv_floatProfitLable.textAlignment = NSTextAlignmentCenter;
  sgv_floatProfitLable.font = [UIFont systemFontOfSize:11];
  // sgv_floatProfitLable.center=CGPointMake(width/2, height/4);
  [self addSubview:sgv_floatProfitLable];

  //持股市值标题
  sgv_stockLable = [[UILabel alloc] initWithFrame:floatrect];
  sgv_stockLable.backgroundColor = [UIColor clearColor];
  sgv_stockLable.text = @"持股市值";
  sgv_stockLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  sgv_stockLable.textAlignment = NSTextAlignmentCenter;
  sgv_stockLable.font = [UIFont systemFontOfSize:11];

  sgv_stockLable.center =
      CGPointMake(width / 2 + width, sgv_floatProfitLable.center.y);
  [self addSubview:sgv_stockLable];

  //资金余额
  sgv_foundTitleLable = [[UILabel alloc] initWithFrame:floatrect];
  sgv_foundTitleLable.backgroundColor = [UIColor clearColor];
  sgv_foundTitleLable.text = @"资金余额";
  sgv_foundTitleLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  sgv_foundTitleLable.textAlignment = NSTextAlignmentCenter;
  sgv_foundTitleLable.font = [UIFont systemFontOfSize:11];
  sgv_foundTitleLable.center =
      CGPointMake(width / 2 + 2 * width, sgv_floatProfitLable.center.y);
  [self addSubview:sgv_foundTitleLable];

  //总资产
  sgv_totolAssetLable = [[UILabel alloc] initWithFrame:floatrect];
  sgv_totolAssetLable.backgroundColor = [UIColor clearColor];
  sgv_totolAssetLable.text = @"总资产";
  sgv_totolAssetLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  sgv_totolAssetLable.textAlignment = NSTextAlignmentCenter;
  sgv_totolAssetLable.font = [UIFont systemFontOfSize:11];
  sgv_totolAssetLable.center =
      CGPointMake(width / 2 + 3 * width, sgv_floatProfitLable.center.y);
  [self addSubview:sgv_totolAssetLable];

  //浮动盈亏数值
  CGRect valuesrect = CGRectMake(0, height - 2, width, height);
  sgv_floatValuesLable = [[UILabel alloc] initWithFrame:valuesrect];
  sgv_floatValuesLable.backgroundColor = [UIColor clearColor];
  sgv_floatValuesLable.text = @"0.00";
  sgv_floatValuesLable.textColor = [StockUtil getColorByFloat:0];
  sgv_floatValuesLable.textAlignment = NSTextAlignmentCenter;
  sgv_floatValuesLable.font = [UIFont systemFontOfSize:11];
  [self addSubview:sgv_floatValuesLable];

  //持股市值的数值
  sgv_stockValuesLable = [[UILabel alloc] initWithFrame:valuesrect];
  sgv_stockValuesLable.backgroundColor = [UIColor clearColor];
  sgv_stockValuesLable.text = @"0.00";
  sgv_stockValuesLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  sgv_stockValuesLable.center =
      CGPointMake(width / 2 + width, sgv_floatValuesLable.center.y);
  sgv_stockValuesLable.textAlignment = NSTextAlignmentCenter;
  sgv_stockValuesLable.font = [UIFont systemFontOfSize:11];
  [self addSubview:sgv_stockValuesLable];

  //资金余额的数值
  sgv_fonundValueLable = [[UILabel alloc] initWithFrame:valuesrect];
  sgv_fonundValueLable.backgroundColor = [UIColor clearColor];
  sgv_fonundValueLable.text = @"0.00";
  sgv_fonundValueLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  sgv_fonundValueLable.center =
      CGPointMake(width / 2 + 2 * width, sgv_floatValuesLable.center.y);
  sgv_fonundValueLable.textAlignment = NSTextAlignmentCenter;
  sgv_fonundValueLable.font = [UIFont systemFontOfSize:11];
  [self addSubview:sgv_fonundValueLable];

  //总资产的数值
  sgv_totolAssetValuesLable = [[UILabel alloc] initWithFrame:valuesrect];
  sgv_totolAssetValuesLable.backgroundColor = [UIColor clearColor];
  sgv_totolAssetValuesLable.text = @"0.00";
  sgv_totolAssetValuesLable.textColor =
      [Globle colorFromHexRGB:Color_Text_Common];
  sgv_totolAssetValuesLable.center =
      CGPointMake(width / 2 + 3 * width, sgv_floatValuesLable.center.y);
  sgv_totolAssetValuesLable.textAlignment = NSTextAlignmentCenter;
  sgv_totolAssetValuesLable.font = [UIFont systemFontOfSize:11];
  [self addSubview:sgv_totolAssetValuesLable];
}

- (void)setPagedata:(MatchUserAccountData *)pagedata {
  if (pagedata == nil)
    return;
  //浮动盈亏
  float value = [pagedata.floatProfit floatValue];
  sgv_floatValuesLable.textColor = [StockUtil getColorByFloat:value];
  sgv_floatValuesLable.text = pagedata.floatProfit;
  //持股市值
  sgv_stockValuesLable.text = pagedata.positionValue;
  //资金余额
  sgv_fonundValueLable.text = pagedata.fundBalance;
  //总资产
  sgv_totolAssetValuesLable.text = pagedata.totalAssets;
}

@end
