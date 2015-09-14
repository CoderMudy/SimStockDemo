//
//  MessageCenterCell.m
//  SimuStock
//
//  Created by moulin wang on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageCenterCell.h"
#import "Globle.h"

@implementation MessageCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self createMessageCenterCell];
  }
  return self;
}

- (void)createMessageCenterCell {
  self.backgroundColor = [Globle colorFromHexRGB:@"#F7F7F7"];
  CGRect frame = self.frame;
  // header图片
  self.headerImage =
      [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 32, 32)];
  [self addSubview:self.headerImage];
  //消息图片
  self.newsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [self addSubview:self.newsImage];
  //箭头
  self.arrowImage = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.frame.size.width - 20, 17, 9, 15)];
  self.arrowImage.image = [UIImage imageNamed:@"箭头"];
  [self addSubview:self.arrowImage];
  //内容ContentLabel
  self.contentLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(64, 14, 100, 20)];
  self.contentLabel.backgroundColor = [UIColor clearColor];
  self.contentLabel.textColor = [UIColor blackColor];
  self.contentLabel.textAlignment = NSTextAlignmentLeft;
  self.contentLabel.font = [UIFont systemFontOfSize:16];
  [self addSubview:self.contentLabel];
  //大红点
  self.redDotImage = [[UIImageView alloc]
      initWithFrame:CGRectMake(frame.size.width - 50, 14, 20, 20)];
  self.redDotImage.backgroundColor = [Globle colorFromHexRGB:@"#dd2526"];
  [self.redDotImage.layer setMasksToBounds:YES];
  [self.redDotImage.layer setCornerRadius:10.0f];
  [self addSubview:self.redDotImage];
  //大红点内容
  self.redDotLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(frame.size.width - 50, 14, 20, 20)];
  self.redDotLabel.text = @"";
  self.redDotLabel.backgroundColor = [UIColor clearColor];
  self.redDotLabel.textColor = [Globle colorFromHexRGB:@"#ffffff"];
  self.redDotLabel.textAlignment = NSTextAlignmentCenter;
  self.redDotLabel.font = [UIFont systemFontOfSize:13];
  [self addSubview:self.redDotLabel];
  //下划线1
  _cellTopLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 47, self.frame.size.width, 0.5f)];
  _cellTopLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_cellTopLineView];
  //下划线2
  _cellDownLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 47.5f, self.frame.size.width, 0.5f)];
  _cellDownLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_cellDownLineView];
}

- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum {
  _redDotLabel.hidden = unReadMessageNum <= 0;
  _redDotImage.hidden = unReadMessageNum <= 0;
  self.redDotImage.frame = CGRectMake(self.frame.size.width - 50, 14, 20, 20);
  [self.redDotImage.layer setCornerRadius:10.0f];

  if (unReadMessageNum < 100) {
    _redDotLabel.text =
        [NSString stringWithFormat:@"%ld", (long)unReadMessageNum];
    _redDotLabel.font = [UIFont systemFontOfSize:13];
  } else {
    _redDotLabel.text = @"99+";
    _redDotLabel.font = [UIFont systemFontOfSize:9];
  }
}

- (void)setUnReadDot:(NSInteger)unReadMessageNum {
  _redDotImage.hidden = unReadMessageNum <= 0;
  _redDotLabel.hidden = YES;
  self.redDotImage.frame = CGRectMake(self.frame.size.width - 45, 19, 10, 10);
  [self.redDotImage.layer setCornerRadius:5.0f];
}

@end
