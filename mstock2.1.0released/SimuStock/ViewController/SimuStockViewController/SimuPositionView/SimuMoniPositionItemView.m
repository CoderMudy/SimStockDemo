//
//  SimuMoniPositionItemView.m
//  SimuStock
//
//  Created by Mac on 13-12-13.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuMoniPositionItemView.h"
#import "SimuUtil.h"

@implementation SimuMoniPositionItemView

@synthesize baseview = smpi_BaseView;

- (id)initWithFrame:(CGRect)frame
          HeadWidth:(int)headwidth
       ContentWidth:(int)contentwidth {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor blackColor];
    smpi_BaseView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:smpi_BaseView];
    //[smpi_BaseView release];
    smpi_BaseView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];

    smpi_RightScrollView = [[UIScrollView alloc]
        initWithFrame:CGRectMake(headwidth, 0, frame.size.width - headwidth,
                                 frame.size.height)];
    smpi_RightScrollView.contentSize =
        CGSizeMake(contentwidth, frame.size.height);
    smpi_RightScrollView.showsVerticalScrollIndicator = NO;
    smpi_RightScrollView.showsHorizontalScrollIndicator = NO;
    [smpi_BaseView addSubview:smpi_RightScrollView];
    smpi_ViewArray = [[NSMutableArray alloc] init];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//加入持仓的股票代码头
- (void)addheadView:(UIView *)headView {
  for (UIView *obj in smpi_ViewArray) {
    [obj removeFromSuperview];
  }
  [smpi_ViewArray removeAllObjects];

  headView.center = CGPointMake(headView.center.x, smpi_BaseView.center.y);
  [smpi_BaseView addSubview:headView];
  [smpi_ViewArray addObject:headView];
}
//加入持仓的股票代码各项目
- (void)addRightView:(UIView *)contentView {
  contentView.center =
      CGPointMake(contentView.center.x, smpi_BaseView.center.y);
  [smpi_RightScrollView addSubview:contentView];
  [smpi_ViewArray addObject:contentView];
}
- (void)addOpratinView:(UIView *)oprationView {
  oprationView.center =
      CGPointMake(oprationView.center.x, smpi_BaseView.center.y);
  [smpi_BaseView addSubview:oprationView];
  [smpi_ViewArray addObject:oprationView];
}
//设定滑动情况
- (void)resetScrolPos:(CGPoint)scrol_pos {
  if (smpi_RightScrollView) {
    [smpi_RightScrollView setContentOffset:scrol_pos animated:NO];
  }
}

@end
