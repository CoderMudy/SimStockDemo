//
//  VericalLineView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "VericalLineView.h"
#import "Globle.h"

@interface VericalLineView ()
{
  NSMutableArray *_mutableArray;
}

@end

@implementation VericalLineView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _mutableArray = [[NSMutableArray alloc] init];
    [self createLineView];
  }
  return self;
}

//竖线
- (void)awakeFromNib {
  _mutableArray = [[NSMutableArray alloc] init];
  [self createLineView];
}
- (void)createLineView {
  CGFloat width = self.bounds.size.width * 0.5;
  CGFloat height = self.bounds.size.height;

  UIView *line1 =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  line1.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:line1];
  [_mutableArray addObject:line1];
  UIView *line2 =
      [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
  line2.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:line2];
  [_mutableArray addObject:line2];
}

-(void)reSetLineFrame
{
  for (int i = 0; i < _mutableArray.count; i++) {
    UIView *line = _mutableArray[i];
    line.height = self.height;
  }
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  [self reSetLineFrame];
}

@end
