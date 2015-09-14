//
//  CompetitionDetailsCell.m
//  SimuStock
//
//  Created by moulin wang on 14-5-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CompetitionDetailsCell.h"
#import "Globle.h"

@implementation CompetitionDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self createacontrolmethod];
  }
  return self;
}

- (void)awakeFromNib {
  [self createacontrolmethod];
}

- (void)createacontrolmethod {

  //排名 60
  _rankNumLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, (72.0 - 36.0) / 4, 60, 36.0 / 2)];
  _rankNumLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  _rankNumLab.textAlignment = NSTextAlignmentCenter;
  _rankNumLab.backgroundColor = [UIColor clearColor];
  _rankNumLab.font = [UIFont systemFontOfSize:17.0];
  [self addSubview:_rankNumLab];

  //用户名 160
  _userGradeView = [[UserGradeView alloc]
      initWithFrame:CGRectMake(60, (72.0 - 30.0) / 4, 160, 30.0 / 2)];
  [self addSubview:_userGradeView];

  //盈利率 100
  _profitabilityLab = [[UILabel alloc]
      initWithFrame:CGRectMake(220, (72.0 - 30.0) / 4, 100.0, 30.0 / 2)];
  _profitabilityLab.textColor = [Globle colorFromHexRGB:@"#e70707"];
  _profitabilityLab.textAlignment = NSTextAlignmentCenter;
  _profitabilityLab.backgroundColor = [UIColor clearColor];
  _profitabilityLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [self addSubview:_profitabilityLab];

  //底边灰线。细
  _cmpVCUplineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, HEIGHT_OF_BOTTOM_LINE * 2,
                               WIDTH_OF_SCREEN, HEIGHT_OF_BOTTOM_LINE)];
  _cmpVCUplineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_cmpVCUplineView];
  //下(分割线)
  _cmpVCDownlineView = [[UIView alloc]
      initWithFrame:CGRectMake(0,HEIGHT_OF_BOTTOM_LINE,
                               WIDTH_OF_SCREEN, HEIGHT_OF_BOTTOM_LINE)];
  _cmpVCDownlineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_cmpVCDownlineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
