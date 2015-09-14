//
//  SliederViewContrer.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@interface SliederViewContrer ()

@end

@implementation SliederViewContrer

- (void)viewDidLoad {
    [super viewDidLoad];

  //滑块
  [self createSlider];
  //买入按钮
  [self createBuyButton];
  
  
}

#pragma mark -- 初始化 滑块
-(void)createSlider
{
  //给滑块 和 买入按钮 设置
  self.sliderPrice.maximumValue = 0.0f;
  self.sliderPrice.minimumValue = 0.0f;
  self.sliderPrice.value = 0.0f;
  [self.sliderPrice setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                         forState:UIControlStateNormal];
  [self.sliderPrice setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                         forState:UIControlStateHighlighted];
  
  [self.sliderPrice
   setMaximumTrackImage:[[UIImage imageNamed:@"买入数量进度条.png"]
                         stretchableImageWithLeftCapWidth:4
                         topCapHeight:0]
   forState:UIControlStateNormal];
  [self.sliderPrice
   setMinimumTrackImage:[[UIImage imageNamed:@"买入数量进度条左.png"]
                         stretchableImageWithLeftCapWidth:4
                         topCapHeight:0]
   forState:UIControlStateNormal];
}

-(void)createBuyButton
{
  self.buyButton.layer.cornerRadius = 15.0f;
  self.buyButton.layer.masksToBounds = YES;
  
}

@end
