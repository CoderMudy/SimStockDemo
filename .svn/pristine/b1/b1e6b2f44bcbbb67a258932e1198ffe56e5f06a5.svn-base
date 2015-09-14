//
//  SystemCell.m
//  SimuStock
//
//  Created by moulin wang on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation SystemCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self createView];
  }
  return self;
}

- (void)createView {
  self.backgroundColor = [Globle colorFromHexRGB:@"#F7F7F7"];
  CGRect frame = [self frame];
  //通知label
  self.noticeLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(10, 10,self.width-20, 17)];
  self.noticeLabel.backgroundColor = [UIColor clearColor];
  self.noticeLabel.textAlignment = NSTextAlignmentLeft;
  self.noticeLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  self.noticeLabel.font = [UIFont systemFontOfSize:18];
  self.noticeLabel.text = @"";
  [self addSubview:self.noticeLabel];
  //内容label
  _contentLabel=[SystemCell textLabel];
  [self addSubview:_contentLabel];
  //时间Label
  self.timeLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(frame.size.width - 130, 35, 125, 10)];
  self.timeLabel.backgroundColor = [UIColor clearColor];
  self.timeLabel.textAlignment = NSTextAlignmentRight;
  self.timeLabel.textColor = [Globle colorFromHexRGB:@"#939393"];
  self.timeLabel.font = [UIFont systemFontOfSize:9];
  self.noticeLabel.text = @"";
  [self addSubview:self.timeLabel];
  //下划线1
  _cellTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, 320, 0.5)];
  _cellTopLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
  _cellTopLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_cellTopLineView];
  //下划线2
  _cellDownLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, frame.size.height - 0.5, 320, 0.5)];
  _cellDownLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
  _cellDownLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_cellDownLineView];
}


+ (RTLabel*)textLabel
{
  RTLabel *label=[[RTLabel alloc]initWithFrame:CGRectMake(11, 47, 295, 0)];
  label.backgroundColor=[UIColor clearColor];
  [label setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
  label.textColor=[UIColor blackColor];
  [label setTextAlignment:RTTextAlignmentJustify];
  [label setParagraphReplacement:@""];
  return label;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
