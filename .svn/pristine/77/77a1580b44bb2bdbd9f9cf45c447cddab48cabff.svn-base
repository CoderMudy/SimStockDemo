//
//  RefrashTimeTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/1/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RefrashTimeTableViewCell.h"
#import "Globle.h"
@implementation RefrashTimeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.TitleLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 50)];
    self.TitleLable.backgroundColor=[UIColor clearColor];
    self.TitleLable.font=[UIFont systemFontOfSize:20];
    self.TitleLable.textColor=[UIColor blackColor];
    self.TitleLable.userInteractionEnabled=NO;
    self.TitleLable.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.TitleLable];
    
    _selectedbtn=[[UIImageView alloc]initWithFrame:CGRectMake(210, 13, 24, 24)];
    _selectedbtn.clipsToBounds=YES;
    _selectedbtn.layer.cornerRadius=12;
    _selectedbtn.userInteractionEnabled=NO;
    [_selectedbtn.layer setBorderWidth:1.0f];
    [_selectedbtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self addSubview:_selectedbtn];
    
    //分割线
    UIView * _grayCuttingLine = [[UIView alloc]
                                 initWithFrame:CGRectMake(0,49, self.frame.size.width, 0.5)];
    _grayCuttingLine.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    _grayCuttingLine.userInteractionEnabled=NO;
    [self addSubview:_grayCuttingLine];
    
    UIView * _whiteCuttinLine = [[UIView alloc]
                                 initWithFrame:CGRectMake(0,49.5, self.frame.size.width, 0.5)];
    _whiteCuttinLine.backgroundColor = [Globle colorFromHexRGB:Color_White];
    _whiteCuttinLine.userInteractionEnabled=NO;
    [self addSubview:_whiteCuttinLine];

  }
  return self;
}
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    
  }
  return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
