//
//  UserTradeGradeWidget.m
//  SimuStock
//
//  Created by Yuemeng on 15/3/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserTradeGradeWidget.h"
#import "ArcAndNumberView.h"
#import "Globle.h"
#import "Flowers.h"
#import "UserTradeGradeItem.h"

#define OFFSET_X (WIDTH_OF_SCREEN - 290) / 2

@implementation UserTradeGradeWidget

- (instancetype)initWithFrame:(CGRect)frame {

  if (self =
          [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, WIDTH_OF_SCREEN, 30)]) {
  }
  return self;
}

- (void)refreshData:(UserTradeGradeItem *)item {

  // 1.交易评级
  // 1.1大花
  if (!_flowers) {
    _flowers = [[Flowers alloc] initBigFlowerWithRating:item.ratingGrade
                                              withFrame:CGRectMake(OFFSET_X + 12, 0, 20, 20)];
    [self addSubview:_flowers];
  } else {
    [_flowers resetWithRating:item.ratingGrade];
  }

  // 1.2评级等级
  if (!_gradeLabel) {
    _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET_X + 25, 0, 38, 20)];
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    _gradeLabel.backgroundColor = [UIColor clearColor];
    _gradeLabel.textColor = [Globle colorFromHexRGB:@"ff9900"];
    _gradeLabel.font = [UIFont systemFontOfSize:Font_Height_21_0];
    [self addSubview:_gradeLabel];
  }
  _gradeLabel.text = item.ratingGrade;

  if (!titleLabel) {
    // 1.3名称(交易评级)
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET_X, 23, 63, 9)];
    titleLabel.text = @"交易评级";
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
  }

  // 2.盈利性
  if (!_profitView) {
    _profitView =
        [[ArcAndNumberView alloc] initWithFrame:CGRectMake(80 + OFFSET_X + 4.5f, 0, 63, 32)
                                      withTitle:@"盈利性"
                                        withNum:item.profitability
                                      withColor:[Globle colorFromHexRGB:@"#f6786f"]];
    [self addSubview:_profitView];
  } else {
    [_profitView resetWithNum:item.profitability];
  }

  // 3.稳定性
  if (!_stableView) {
    _stableView = [[ArcAndNumberView alloc] initWithFrame:CGRectMake(160 + OFFSET_X - 2, 0, 63, 32)
                                                withTitle:@"稳定性"
                                                  withNum:item.stability
                                                withColor:[Globle colorFromHexRGB:@"#74d9f5"]];
    [self addSubview:_stableView];
  } else {
    [_stableView resetWithNum:item.stability];
  }

  // 4.准确性
  if (!_accurateView) {
    _accurateView =
        [[ArcAndNumberView alloc] initWithFrame:CGRectMake(240 + OFFSET_X - 8.5f, 0, 63, 32)
                                      withTitle:@"准确性"
                                        withNum:item.accuracy
                                      withColor:[Globle colorFromHexRGB:@"#f2ab13"]];
    [self addSubview:_accurateView];
  } else {
    [_accurateView resetWithNum:item.accuracy];
  }
}

@end
