//
//  FirstComeView.m
//  SimuStock
//
//  Created by Mac on 15/2/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FirstComeView.h"

@interface FirstComeView()



@end


@implementation FirstComeView


-(id)initWithFrame:(CGRect)frame
{
  self=[super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor=[UIColor blackColor];
    self.alpha=0.6;
    UITapGestureRecognizer * tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_Click:)];
    [self addGestureRecognizer:tapGestureRecognizer];
  }
  return self;
}
-(void)tap_Click:(UITapGestureRecognizer *)sender
{
  self.hidden=YES;
  [self removeFromSuperview];
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  [self CreatFirstView];
}

-(void)CreatFirstView
{
  if (!_img)
  {
    ///图片
    _img=[[UIImageView alloc]initWithFrame:CGRectMake(30, self.height- self.keyboardHeight - 81 - 65, 35, 81)];
    _img.image=[UIImage imageNamed:@"write_weibo_tip_line.png"];
    [self addSubview:_img];
  }
  _img.frame =CGRectMake(30, self.height- self.keyboardHeight - 81 - 65, 35, 81);

  if (!_upLable)
  {
    ///文字
    _upLable=[[UILabel alloc]initWithFrame:CGRectMake(80,CGRectGetMinY(_img.frame) - 27,150, 50)];
    _upLable.text=@"想发布到哪个聊股吧？\n 戳这里选择吧!";
    _upLable.backgroundColor = [UIColor redColor];
    _upLable.backgroundColor=[UIColor clearColor];
    _upLable.textColor=[UIColor whiteColor];
    _upLable.numberOfLines=2;
    _upLable.textAlignment=NSTextAlignmentLeft;
    _upLable.font=[UIFont systemFontOfSize:15];
    [self addSubview:_upLable];
  }
  _upLable.frame = CGRectMake(80,CGRectGetMinY(_img.frame) - 27,150, 50);
}

@end
