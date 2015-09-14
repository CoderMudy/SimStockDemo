//
//  MarketHeaderSectionView.m
//  SimuStock
//
//  Created by Mac on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketHeaderSectionView.h"
#import "Globle.h"

@implementation MarketHeaderSectionView

/** 更多小方块的个数 */
static const NSInteger BLOCK_NUM = 3;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          withFrame:(CGRect)frame {

  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
    _moreBlocks = [[NSMutableArray alloc] init];
    [self createViewsWithFrame:frame];
  }
  return self;
}

- (void)createViewsWithFrame:(CGRect)bound {
  _sectionLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(17, 0.0, 60.0, 27.5)];
  _sectionLabel.backgroundColor = [UIColor clearColor];
  _sectionLabel.font = [UIFont systemFontOfSize:13];

  [self addSubview:_sectionLabel];

  for (int i = 0; i < BLOCK_NUM; i++) {
    CGRect frame = CGRectMake(bound.size.width - 15 - i * 9.5,
                              (bound.size.height - 6) / 2, 6, 6);
    UIView *blockView = [[UIView alloc] initWithFrame:frame];
    blockView.backgroundColor = [Globle colorFromHexRGB:@"#8d8e93"];
    [self addSubview:blockView];
    [_moreBlocks addObject:blockView];
  }
}

- (void)setBlockColor:(UIColor *)color {
  for (UIView *blockView in _moreBlocks) {
    blockView.backgroundColor = color;
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  [self setBlockColor:[Globle colorFromHexRGB:@"#8d8e00"]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setBlockColor:[Globle colorFromHexRGB:@"#8d8e93"]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setBlockColor:[Globle colorFromHexRGB:@"#8d8e93"]];
  if (self.action) {
    self.action();
  }
}

@end
