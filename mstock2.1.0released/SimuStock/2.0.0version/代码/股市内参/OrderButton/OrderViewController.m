//
//  OrderViewController.m
//  ifengNewsOrderDemo
//
//  Created by zer0 on 14-2-27.
//  Copyright (c) 2014年 zer0. All rights reserved.
//

#import "OrderViewController.h"
#import "TouchViewModel.h"
#import "TouchView.h"
#import "Header.h"



@implementation OrderViewController


- (void)viewDidAppear:(BOOL)animated {
  [self setExclusiveTouchForButtons:self.view];
  [super viewDidAppear:animated];
}

- (void)setExclusiveTouchForButtons:(UIView *)myView {
  for (UIView *v in [myView subviews]) {
    if ([v isKindOfClass:[UIButton class]])
      [((UIButton *)v)setExclusiveTouch:YES];
    else if ([v isKindOfClass:[UIView class]]) {
      [self setExclusiveTouchForButtons:v];
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"新闻栏目管理" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  //    取消移动
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:@"0" forKey:@"Move_View"];
  [defaults synchronize];

  myChannelList = [[NewsChannelList alloc] init];
  myChannelList.channels = [[NSMutableArray alloc] init];
  moreChannelList = [[NewsChannelList alloc] init];
  moreChannelList.channels = [[NSMutableArray alloc] init];

  NewsChannelList *list = [FileStoreUtil loadMyNewsChannelList];
  if (list.channels.count > 0) {
    [myChannelList.channels addObjectsFromArray:list.channels];
  }
  NewsChannelList *Morelist = [FileStoreUtil loadMoreNewsChannelList];
  if (Morelist.channels.count > 0) {
    [moreChannelList.channels addObjectsFromArray:Morelist.channels];
  }

  _viewArr1 = [[NSMutableArray alloc] init];
  _viewArr2 = [[NSMutableArray alloc] init];

  _titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, KTableStartPointY - 50, 100, 40)];
  _titleLabel.text = @"我的栏目";
  _titleLabel.backgroundColor = [UIColor clearColor];
  [_titleLabel setTextAlignment:NSTextAlignmentCenter];
  _titleLabel.font = [UIFont systemFontOfSize:18];
  [_titleLabel setTextColor:[UIColor blackColor]];
  [self.clientView addSubview:_titleLabel];

  label_text = [[UILabel alloc]
      initWithFrame:CGRectMake(100, KTableStartPointY - 45, 200, 30)];
  label_text.text = @"(点击增删，长按拖拽排序)";
  label_text.font = [UIFont systemFontOfSize:13];
  label_text.backgroundColor = [UIColor clearColor];
  label_text.textColor = [UIColor blackColor];
  [self.clientView addSubview:label_text];

  _titleLabel2 = [[UILabel alloc]
      initWithFrame:CGRectMake(0, KTableStartPointY +
                                      (KButtonHeight + KTable_Distance_PointY) *
                                          ([self array2StartY] - 1),
                               WIDTH_OF_SCREEN, 42)];
  _titleLabel2.text = @"  更多频道";
  _titleLabel2.backgroundColor = [UIColor clearColor];
  [_titleLabel2 setFont:[UIFont systemFontOfSize:18]];
  [_titleLabel2 setTextAlignment:NSTextAlignmentLeft];
  [_titleLabel2 setTextColor:[UIColor blackColor]];
  [self.clientView addSubview:_titleLabel2];

  //    加上下，分界线
  View_1 =
      [[UIView alloc] initWithFrame:CGRectMake(12, 0, WIDTH_OF_SCREEN - 24, 1)];
  [_titleLabel2 addSubview:View_1];

  for (int i = 0; i < myChannelList.channels.count; i++) {
    TouchView *touchView = [[TouchView alloc]
        initWithFrame:CGRectMake(KTableStartPointX +
                                     (KButtonWidth + KTable_Distance_PointX) *
                                         (i % KTable_Num_btn),
                                 KTableStartPointY +
                                     (KButtonHeight + KTable_Distance_PointY) *
                                         (i / KTable_Num_btn),
                                 KButtonWidth, KButtonHeight)];
    //    touchView.layer.cornerRadius = 5;
    [_viewArr1 addObject:touchView];
    touchView->_array = _viewArr1;
    NewsChannelItem *item = [myChannelList.channels objectAtIndex:i];
    touchView.text = item.name;
    touchView.item = item;
    touchView.isEditable = item.isEditable;
    [touchView setTextAlignment:NSTextAlignmentCenter];
    [touchView setMoreChannelsLabel:_titleLabel2];
    touchView->_viewArr11 = _viewArr1;
    touchView->_viewArr22 = _viewArr2;

    [self.clientView addSubview:touchView];
  }

  for (int i = 0; i < moreChannelList.channels.count; i++) {
    TouchView *touchView = [[TouchView alloc]
        initWithFrame:CGRectMake(
                          KTableStartPointX +
                              (KButtonWidth + KTable_Distance_PointX) *
                                  (i % KTable_Num_btn),
                          KTableStartPointY +
                              [self array2StartY] *
                                  (KButtonHeight + KTable_Distance_PointY) +
                              (KButtonHeight + KTable_Distance_PointY) *
                                  (i / KTable_Num_btn),
                          KButtonWidth, KButtonHeight)];
    //    touchView.layer.cornerRadius = 5;
    [_viewArr2 addObject:touchView];
    touchView->_array = _viewArr2;
    NewsChannelItem *item = [moreChannelList.channels objectAtIndex:i];
    touchView.text = item.name;
    touchView.item = item;
    touchView.isEditable = item.isEditable;
    [touchView setTextAlignment:NSTextAlignmentCenter];
    [touchView setMoreChannelsLabel:_titleLabel2];
    touchView->_viewArr11 = _viewArr1;
    touchView->_viewArr22 = _viewArr2;
    [self.clientView addSubview:touchView];
  }
  [self Night_to_Day];
}

#pragma mark - 消息中心，回调，夜间、白天和无图、有图
//夜间模式和白天模式
- (void)Night_to_Day {
  _titleLabel.textColor = [Globle colorFromHexRGB:@"252525"];
  label_text.textColor = [Globle colorFromHexRGB:@"606060"];
  _titleLabel2.textColor = [Globle colorFromHexRGB:@"252525"];
  self.clientView.backgroundColor =
      [Globle colorFromHexRGB:customBGColor alpha:1.0f];
  X_view.backgroundColor = [Globle colorFromHexRGB:customGrayCuttingLine];
  View_1.backgroundColor = [Globle colorFromHexRGB:customGrayCuttingLine];
}

- (void)leftButtonPress {
  [myChannelList.channels removeAllObjects];
  //获取，新的被选择的
  for (TouchView *touchView in _viewArr1) {
    [myChannelList.channels addObject:touchView.item];
  }
  [FileStoreUtil saveMyNewsChannelList:myChannelList];

  [moreChannelList.channels removeAllObjects];
  //获取，未被选择的频道
  for (TouchView *touchView in _viewArr2) {
    [moreChannelList.channels addObject:touchView.item];
  }
  [FileStoreUtil saveMoreNewsChannelList:moreChannelList];
  self.block();
  [super leftButtonPress];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (unsigned long)array2StartY {
  unsigned long y = 0;

  y = myChannelList.channels.count / KTable_Num_btn + 2;
  if (myChannelList.channels.count % KTable_Num_btn == 0) {
    y -= 1;
  }
  return y;
}

@end
