//
//  CellBottomLinesView.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CellBottomLinesView.h"
#import "Globle.h"

@implementation CellBottomLinesView {
  UIView *uplineView;
  UIView *downlineView;
}

+ (id)addBottomLinesToCell:(UITableViewCell *)cell {
  return [[CellBottomLinesView alloc] initWithCell:cell isShort:NO];
}

+ (id)addShortBottomLinesToCell:(UITableViewCell *)cell {
  return [[CellBottomLinesView alloc] initWithCell:cell isShort:YES];
}

- (void)awakeFromNib {
  [self createUI];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self createUI];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  }
  return self;
}

- (id)initWithCell:(UITableViewCell *)cell isShort:(BOOL)isShort {
  self = [super
      initWithFrame:CGRectMake(0, cell.bounds.size.height -
                                      HEIGHT_OF_BOTTOM_LINE * 2,
                               WIDTH_OF_SCREEN, HEIGHT_OF_BOTTOM_LINE * 2)];
  if (self) {
    if (isShort) {
      [self createShortUI];
    } else {
      [self createUI];
    }
  }
  self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [cell.contentView addSubview:self];
  [cell sendSubviewToBack:self];

  return self;
}

- (void)createUI {
  //底边灰线。细
  uplineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEW, HEIGHT_OF_BOTTOM_LINE)];
  uplineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self addSubview:uplineView];
  //下(分割线)
  downlineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, HEIGHT_OF_BOTTOM_LINE, WIDTH_OF_VIEW,
                               HEIGHT_OF_BOTTOM_LINE)];
  downlineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self addSubview:downlineView];
}

- (void)createShortUI {
  //底边灰线。细
  uplineView =
      [[UIView alloc] initWithFrame:CGRectMake(43, 0, WIDTH_OF_VIEW - 63,
                                               HEIGHT_OF_BOTTOM_LINE)];
  uplineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:uplineView];
  //下(分割线)
  downlineView = [[UIView alloc]
      initWithFrame:CGRectMake(43, HEIGHT_OF_BOTTOM_LINE - 63, WIDTH_OF_VIEW,
                               HEIGHT_OF_BOTTOM_LINE)];
  downlineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:downlineView];
}

- (void)resetViewWidth:(CGFloat)width {
  self.width = width;
  uplineView.width = width;
  downlineView.width = width;
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  uplineView.width = self.width;
  downlineView.width = self.width;
}


@end
