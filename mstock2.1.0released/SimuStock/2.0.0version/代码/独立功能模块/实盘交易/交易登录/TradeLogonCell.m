//
//  TradeLogonCell.m
//  SimuStock
//
//  Created by jhss on 14-10-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TradeLogonCell.h"
#import "Globle.h"

@implementation TradeLogonCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [Globle colorFromHexRGB:@"e5e5e5"];
    _leftTitle = [[UILabel alloc] initWithFrame:self.frame];
    _leftTitle.center = CGPointMake((self.frame.size.width - 20 * 2) / 2,
                                    self.frame.size.height / 2);
    _leftTitle.backgroundColor = [UIColor clearColor];
    _leftTitle.textAlignment = NSTextAlignmentCenter;
    _leftTitle.textColor = [Globle colorFromHexRGB:@"222222"];
    _leftTitle.font = [UIFont systemFontOfSize:Font_Height_16_0];

    [self addSubview:_leftTitle];
    _topCuttingLine = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _topCuttingLine.backgroundColor = [Globle colorFromHexRGB:@"bfbfbf"];
    [self addSubview:_topCuttingLine];
    _downCuttingLine = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0.5, self.frame.size.width, 0.5)];
    _downCuttingLine.backgroundColor = [Globle colorFromHexRGB:@"f8f8f8"];
    [self addSubview:_downCuttingLine];
  }
  return self;
}
- (void)dealloc {
  self.leftTitle = nil;
  self.topCuttingLine = nil;
  self.downCuttingLine = nil;
}
- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
