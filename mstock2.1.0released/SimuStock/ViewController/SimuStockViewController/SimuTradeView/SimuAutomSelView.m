//
//  SimuAutomSelView.m
//  SimuStock
//
//  Created by Mac on 13-8-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuAutomSelView.h"
#import "SimuUtil.h"

@implementation SimuAutomSelView
@synthesize delegate = sasv_delegate;
@synthesize selectIndex = sasv_corIndex;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    //创建背景
    sasv_corIndex = 4;
    sasv_delegate = nil;
    sasv_isAnimateRun = NO;
    sasv_buttonArray = [[NSMutableArray alloc] init];
    UIImage *backimage = [UIImage imageNamed:@"SST_YK_back.png"];
    CGRect sgv_backimageRect = CGRectMake(
        0, 0, backimage.size.width / [UIScreen mainScreen].scale, 40);
    sasv_backgroundImageView = [[UIImageView alloc] initWithImage:backimage];
    sasv_backgroundImageView.frame = sgv_backimageRect;
    [self addSubview:sasv_backgroundImageView];
    //创建背景分割线
    UIImage *lineimage = [UIImage imageNamed:@"SST_YK_line.png"];
    CGRect linerect = CGRectMake(
        0, 0, lineimage.size.width / [UIScreen mainScreen].scale, 20);
    CGFloat width = sgv_backimageRect.size.width / 5.0;
    CGFloat height = sgv_backimageRect.size.height / 2.0;
    //分割线1
    UIImageView *sgv_sepLineImageView1 =
        [[UIImageView alloc] initWithImage:lineimage];
    sgv_sepLineImageView1.bounds = linerect;
    sgv_sepLineImageView1.center = CGPointMake(width, height);
    [self addSubview:sgv_sepLineImageView1];
    //分割线2
    UIImageView *sgv_sepLineImageView2 =
        [[UIImageView alloc] initWithImage:lineimage];
    sgv_sepLineImageView2.bounds = linerect;
    sgv_sepLineImageView2.center = CGPointMake(2 * width, height);
    [self addSubview:sgv_sepLineImageView2];
    //分割线3
    UIImageView *sgv_sepLineImageView3 =
        [[UIImageView alloc] initWithImage:lineimage];
    sgv_sepLineImageView3.bounds = linerect;
    sgv_sepLineImageView3.center = CGPointMake(3 * width, height);
    [self addSubview:sgv_sepLineImageView3];

    //分割线4
    UIImageView *sgv_sepLineImageView4 =
        [[UIImageView alloc] initWithImage:lineimage];
    sgv_sepLineImageView4.bounds = linerect;
    sgv_sepLineImageView4.center = CGPointMake(4 * width, height);
    [self addSubview:sgv_sepLineImageView4];

    UIImage *frontimage = [UIImage imageNamed:@"ST_Autom_up.png"];
    sasv_frontImageView = [[UIImageView alloc] initWithImage:frontimage];
    CGRect firstrect = CGRectMake(11, 0, 45, 42);
    sasv_frontImageView.frame = CGRectOffset(firstrect, 240, 0);
    ;
    [self addSubview:sasv_frontImageView];

    //        for (int i=0; i<5; i++)
    //        {
    //            sasv_frontRectArray[i]=CGRectOffset(firstrect, i*60, 0);
    //        }
    //加入按钮
    // CGFloat m_width=self.bounds.size.width/5;
    for (int i = 0; i < 5; i++) {
      UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
      button1.frame = CGRectMake(width * i, 0, width, 45);
      button1.tag = i;
      sasv_frontPointArray[i] = button1.center;
      if (i == 0) {
        [button1 setTitle:@"1/5" forState:UIControlStateNormal];
        [button1 setTitle:@"1/5" forState:UIControlStateHighlighted];
      } else if (i == 1) {
        [button1 setTitle:@"1/4" forState:UIControlStateNormal];
        [button1 setTitle:@"1/4" forState:UIControlStateHighlighted];
      } else if (i == 2) {
        [button1 setTitle:@"1/3" forState:UIControlStateNormal];
        [button1 setTitle:@"1/3" forState:UIControlStateHighlighted];
        //[button1 setBackgroundColor:[UIColor redColor]];
      } else if (i == 3) {
        [button1 setTitle:@"1/2" forState:UIControlStateNormal];
        [button1 setTitle:@"1/2" forState:UIControlStateHighlighted];
        // button1.backgroundColor=[UIColor blueColor];
      } else if (i == 4) {
        [button1 setTitle:@"全部" forState:UIControlStateNormal];
        [button1 setTitle:@"全部" forState:UIControlStateHighlighted];
      }
      [button1 setTitleColor:[Globle colorFromHexRGB:Color_Dark]
                    forState:UIControlStateNormal];
      [button1 setTitleColor:[Globle colorFromHexRGB:Color_Dark]
                    forState:UIControlStateHighlighted];
      button1.backgroundColor = [UIColor clearColor];
      [self addSubview:button1];
      button1.titleLabel.font = [UIFont boldSystemFontOfSize:15];
      [button1 addTarget:self
                    action:@selector(TopButtonPress:)
          forControlEvents:UIControlEventTouchDown];
      [sasv_buttonArray addObject:button1];
    }
    //第一个按钮设定未选中状态
    sasv_frontImageView.center = sasv_frontPointArray[4];
    UIButton *button = sasv_buttonArray[4];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }
  return self;
}
//按钮点击
- (void)TopButtonPress:(UIButton *)button {
  NSInteger index = button.tag;
  //点击一个按钮可以多次
  //    if(index==sasv_corIndex)
  //        return;
  if (sasv_isAnimateRun == YES)
    return;
  sasv_isAnimateRun = YES;
  sasv_corIndex = index;
  [self changeButtonTextColor:index];
  if (sasv_delegate &&
      [sasv_delegate performSelector:@selector(automDidSelecte:)]) {
    [sasv_delegate automDidSelecte:self];
  }

  [self frontMoveWidthAnimation:sasv_corIndex];
}
//按钮前景色移动
- (void)frontMoveWidthAnimation:(NSInteger)index {

  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.4];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAni)];
  // sasv_frontImageView.frame=sasv_frontRectArray[index];
  sasv_frontImageView.center = sasv_frontPointArray[index];
  [UIView commitAnimations];
}

- (void)frontMoveToBegin {
  sasv_corIndex = 4;
  [self changeButtonTextColor:4];
  [self frontMoveWidthAnimation:4];
}

- (void)stopAni {
  sasv_isAnimateRun = NO;
}
//修改按钮颜色
- (void)changeButtonTextColor:(NSInteger)index {
  if (sasv_buttonArray == nil || index < 0 || index >= [sasv_buttonArray count])
    return;
  for (UIButton *obj in sasv_buttonArray) {
    if (index == obj.tag) {
      [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
      [obj setTitleColor:[Globle colorFromHexRGB:Color_Dark]
                forState:UIControlStateNormal];
    }
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {

  // self.delegate=nil;
  [sasv_buttonArray removeAllObjects];
}

@end
