//
//  FirmSaleTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleTableViewCell.h"
#import "SimuUtil.h"

@interface FirmSaleTableViewCell ()

@property(nonatomic, copy) NSString *isEnd;

@property(nonatomic, strong) NSMutableArray *lineArray;

@end

@implementation FirmSaleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createView];
  }
  return self;
}
- (void)createView {
  _arrLab = [[NSMutableArray alloc] init];
  _lineArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < 8; i++) {
    UILabel *fsLabel =
        [[UILabel alloc] initWithFrame:CGRectMake((i % 4) * (WIDTH_OF_SCREEN / 4),
                                                  7.0 + ((i > 3) ? 16.0 : 0), WIDTH_OF_SCREEN / 4, 14.0)];
    fsLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    fsLabel.backgroundColor = [UIColor clearColor];
    fsLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    fsLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:fsLabel];
    [_arrLab addObject:fsLabel];
  }
  //上(分割线)
  UIView *upLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 45.0 - 1.0, WIDTH_OF_SCREEN, 0.5)];
  upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:upLineView];
  [_lineArray addObject:upLineView];
  //下(分割线)
  UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 45.0 - 0.5, WIDTH_OF_SCREEN, 0.5)];
  downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:downLineView];
  [_lineArray addObject:downLineView];
}
- (void)awakeFromNib {
}
/** 重新设置frame */
- (void)reSetUpFirmSaleCellFrameWithWidth:(CGFloat)width {
  CGFloat labelWidth = width / 4;
  for (int i = 0; i < _arrLab.count; i++) {
    UILabel *label = _arrLab[i];
    label.frame = CGRectMake((i % 4) * labelWidth, 7.0 + ((i > 3) ? 16.0 : 0), labelWidth, 14.0);
  }

  for (int i = 0; i < _lineArray.count; i++) {
    UIView *line = _lineArray[i];
    line.frame = CGRectMake(0, line.frame.origin.y, width, line.frame.size.height);
  }
}
@end
