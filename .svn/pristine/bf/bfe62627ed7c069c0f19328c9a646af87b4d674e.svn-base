//
//  TopDividingLineView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TopDividingLineView.h"
#import "Globle.h"

@interface TopDividingLineView () {
  NSMutableArray *_mutableArray;
}

@end

@implementation TopDividingLineView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self cretaTopDivingLine];
  }
  return self;
}

//上面的横线
- (void)awakeFromNib {
  [self cretaTopDivingLine];
}

- (void)cretaTopDivingLine {
  _mutableArray = [NSMutableArray array];
  //宽 高
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height * 0.5;
  //上面的线
  UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  line1.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:line1];
  [_mutableArray addObject:line1];
  UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, height)];
  line2.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:line2];
  [_mutableArray addObject:line2];
}

- (void)reSetUpFrame {
  for (int i = 0; i < _mutableArray.count; i++) {
    UIView *line1 = _mutableArray[i];
    line1.width = self.width;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self reSetUpFrame];
}

@end
