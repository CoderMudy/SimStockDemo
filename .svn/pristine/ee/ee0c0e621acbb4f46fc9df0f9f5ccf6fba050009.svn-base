//
//  SystemMsgTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SystemMsgTableViewCell.h"
#import "Globle.h"
@implementation SystemMsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
  //内容label
  _contentLabel=[SystemMsgTableViewCell textLabel];
  [self addSubview:_contentLabel];
  
  //下划线1
  _cellTopLineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.size.height - 1, 300, 0.5)];
  _cellTopLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
  _cellTopLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_cellTopLineView];
  //下划线2
  _cellDownLineView = [[UIView alloc]
                       initWithFrame:CGRectMake(10,self.size.height - 0.5, 300, 0.5)];
  _cellDownLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
  _cellDownLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_cellDownLineView];
}

+ (RTLabel*)textLabel
{
  RTLabel *label=[[RTLabel alloc]initWithFrame:CGRectMake(15, 42, 290, 0)];
  label.backgroundColor=[UIColor clearColor];
  [label setFont:[UIFont systemFontOfSize:13]];
  label.textColor=[Globle colorFromHexRGB:@"5a5a5a"];
  [label setTextAlignment:RTTextAlignmentJustify];
  [label setParagraphReplacement:@""];
  return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
