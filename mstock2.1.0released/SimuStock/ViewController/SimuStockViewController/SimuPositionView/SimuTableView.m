//
//  SimuTableView.m
//  SimuStock
//
//  Created by Mac on 13-8-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuTableView.h"

@implementation SimuTableView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
      _index = -1;
    [self LayoutControlView];
  }
  return self;
}

#pragma mark
#pragma mark 控制创建和设置相关函数
//初始化创建控件
- (void)LayoutControlView {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  CGRect headRect = CGRectMake(0, 0, self.bounds.size.width, 36);
  UIImageView *headView = [[UIImageView alloc] initWithFrame:headRect];
  headView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  [self addSubview:headView];

  //创建左边标题头视图
  CGRect m_leftHeadRect = CGRectMake(0, 0, self.bounds.size.width / 4, 36);
  _leftHeadView = [[UIImageView alloc] initWithFrame:m_leftHeadRect];
  _leftHeadView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Table_Title];
  [self addSubview:_leftHeadView];
  //创建右边标题头视图
  CGRect m_rightHeadRect =
      CGRectMake(self.bounds.size.width / 4, 0,
                 self.bounds.size.width - m_leftHeadRect.size.width,
                 m_leftHeadRect.size.height);
  _rightHeadView = [[UIImageView alloc] initWithFrame:m_rightHeadRect];
  _rightHeadView.userInteractionEnabled = YES;
  [self insertSubview:_rightHeadView belowSubview:_leftHeadView];

  //创建左边滚动视图
  CGRect m_leftScrolRect =
      CGRectMake(0, m_leftHeadRect.size.height, self.bounds.size.width,
                 self.bounds.size.height - m_leftHeadRect.size.height);
  _leftScrollView = [[UIScrollView alloc] initWithFrame:m_leftScrolRect];
  _leftScrollView.backgroundColor = [UIColor clearColor];
  _leftScrollView.contentSize =
      CGSizeMake(self.bounds.size.width, m_leftScrolRect.size.height);
  _leftScrollView.showsVerticalScrollIndicator = YES;
  _leftScrollView.showsHorizontalScrollIndicator = NO;
  _leftScrollView.delaysContentTouches = YES;
  [self addSubview:_leftScrollView];

  //创建左边滚动视图上的承载视图
  CGRect m_leftContentRect =
      CGRectMake(0, 0, m_leftHeadRect.size.width, m_leftScrolRect.size.height);
  _letfContentView = [[UIView alloc] initWithFrame:m_leftContentRect];
  _letfContentView.backgroundColor = [UIColor clearColor];
  [_leftScrollView addSubview:_letfContentView];

  //创建右边滚动视图
  CGRect m_rightScrollRect =
      CGRectMake(m_leftHeadRect.size.width, 0, m_rightHeadRect.size.width,
                 m_leftScrolRect.size.height);
  _rightScrollView = [[UIScrollView alloc] initWithFrame:m_rightScrollRect];
  _rightScrollView.backgroundColor = [UIColor clearColor];
  _rightScrollView.contentSize =
      CGSizeMake(m_rightScrollRect.size.width, m_rightScrollRect.size.height);
  _rightScrollView.delegate = self;
  _rightScrollView.showsVerticalScrollIndicator = NO;
  _rightScrollView.showsHorizontalScrollIndicator = YES;
  _rightScrollView.delaysContentTouches = YES;
  [_leftScrollView addSubview:_rightScrollView];

  //创建右边承载视图
  _rightContentView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, m_rightScrollRect.size.width,
                               m_rightScrollRect.size.height)];
  _rightContentView.backgroundColor = [UIColor clearColor];
  [_rightScrollView addSubview:_rightContentView];
}

//重新设置表格视图大小
- (void)resetTableSize {
  //创建左边标题头视图
  CGRect m_leftHeadRect = CGRectMake(0, 0, self.bounds.size.width / 4, 36);
  _leftHeadView.frame = m_leftHeadRect;

  //创建右边标题头视图
  CGRect m_rightHeadRect =
      CGRectMake(m_leftHeadRect.size.width, 0,
                 self.bounds.size.width - m_leftHeadRect.size.width,
                 m_leftHeadRect.size.height);
  _rightHeadView.frame = m_rightHeadRect;

  //创建左边滚动视图
  CGRect m_leftScrolRect =
      CGRectMake(0, m_leftHeadRect.size.height, self.bounds.size.width,
                 self.bounds.size.height - m_leftHeadRect.size.height);
  _leftScrollView.frame = m_leftScrolRect;
  _leftScrollView.contentSize =
      CGSizeMake(self.bounds.size.width, m_leftScrolRect.size.height);

  //创建左边滚动视图上的承载视图
  CGRect m_leftContentRect =
      CGRectMake(0, 0, m_leftHeadRect.size.width, m_leftScrolRect.size.height);
  _letfContentView.frame = m_leftContentRect;

  //创建右边滚动视图
  CGRect m_rightScrollRect =
      CGRectMake(m_leftHeadRect.size.width, 0, m_rightHeadRect.size.width,
                 m_leftScrolRect.size.height);
  _rightScrollView.frame = m_rightScrollRect;

  _rightScrollView.contentSize =
      CGSizeMake(m_rightScrollRect.size.width, m_rightScrollRect.size.height);

  //创建右边承载视图
  _rightContentView.frame = CGRectMake(0, 0, m_rightScrollRect.size.width,
                                          m_rightScrollRect.size.height);
}

//重新设置表格数据
- (void)resetTable {
  if (_dataResource == nil)
    return;
  //清除以前数据
  [self clearTableContent];
  //设置新数据
  [self creatNewTableContent];
}
//重新设置表格数据
- (void)resetTableForSelfStock {
  if (_dataResource == nil)
    return;
  //清除以前数据
  [self clearTableContentForSelfStock];
  //设置新数据
  [self creatNewTableContent];
}
//创建表格新数据
- (void)creatNewTableContent {
  if (_dataResource == nil)
    return;
  //设置左标题头区域
  CGRect m_leftHeadRect = CGRectMake(0, 0, _dataResource.FirstColWidth,
                                     _dataResource.HeadHeight);
  _leftHeadView.frame = m_leftHeadRect;
  //设置右标题头区域
  CGRect m_rightHeadRect =
      CGRectMake(m_leftHeadRect.size.width, 0, _dataResource.allcolWidth,
                 _dataResource.HeadHeight);
  _rightHeadView.frame = m_rightHeadRect;
  //设置左承载视图区域和左滚动视图内容区域高度
  CGRect m_leftContentRect = CGRectMake(0, 0, _dataResource.FirstColWidth,
                                        _dataResource.allHeight);
  _leftScrollView.contentSize = CGSizeMake(
      self.bounds.size.width, fmaxf(_dataResource.allHeight,
                                    _leftScrollView.bounds.size.height + 1));
  _leftScrollView.delegate = self;
  _letfContentView.frame = m_leftContentRect;
  //设置右承载视图区域和右滚动视图高度，内容高度
  CGFloat m_height = _dataResource.allHeight;
  if (m_height < _leftScrollView.bounds.size.height)
    m_height = _leftScrollView.bounds.size.height;
  CGRect m_rightContentRect = CGRectMake(
      _dataResource.FirstColWidth, 0,
      self.bounds.size.width - _dataResource.FirstColWidth, m_height);
  _rightScrollView.frame = m_rightContentRect;
  _rightScrollView.contentSize =
      CGSizeMake(_dataResource.allcolWidth, _dataResource.allHeight);
  _rightContentView.frame =
      CGRectMake(0, 0, _dataResource.allcolWidth, _dataResource.allHeight);
  if (_moniItemView == nil) {
    _moniItemView = [[SimuMoniPositionItemView alloc]
        initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 47)
            HeadWidth:m_leftContentRect.size.width
         ContentWidth:_dataResource.allcolWidth];
  }

  //开始设置内容
  //设置左边头区域内容
  UIView *m_TitleView = [_dataResource getTableHeadCellLable:0 Column:0];
  if (nil != m_TitleView) {
    [_leftHeadView addSubview:m_TitleView];
  }
  //设置右边头区域内容
  for (int i = 1; i < [_dataResource.CelWidthArray count]; i++) {
    UIView *m_TitleView = [_dataResource getTableHeadCellLable:0 Column:i];

    if (nil != m_TitleView) {
      [_rightHeadView addSubview:m_TitleView];
    }
  }
  //设置左承载视图区域内容
  for (int i = 0; i < _dataResource.LineNumber; i++) {
    // if([_dataResource isKindOfClass:<#(Class)#> )
    UIView *view = [_dataResource getTableCellLable:i Column:0];
    if (view) {
      [_letfContentView addSubview:view];
    }
    //添加横向分割线
    //(zxc改动 linetopview高度从1改为0.5)
    UIView *lineTopView = [[UIView alloc]
        initWithFrame:CGRectMake(0, (i + 1) * _dataResource.LineHeight - 1,
                                 _dataResource.FirstColWidth, 0.5)];
    lineTopView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    [_letfContentView addSubview:lineTopView];
    UIView *lineBottomView = [[UIView alloc]
        initWithFrame:CGRectMake(0, (i + 1) * _dataResource.LineHeight - 0.5,
                                 _dataResource.FirstColWidth, 0.5)];
    lineBottomView.backgroundColor = [UIColor whiteColor];
    [_letfContentView addSubview:lineBottomView];
  }
  //设置右承载视图区域内容
  for (int row = 0; row < _dataResource.LineNumber; row++) {
    for (int col = 1; col < _dataResource.ColNumber; col++) {
      UIView *view = [_dataResource getTableCellLable:row Column:col];
      if (view) {
        [_rightContentView addSubview:view];
      }
    }
    //添加横向分割线
    //(zxc改动 linetopview高度改为0.5)
    UIView *lineTopView = [[UIView alloc]
        initWithFrame:CGRectMake(0, (row + 1) * _dataResource.LineHeight - 1,
                                 _dataResource.allcolWidth, 0.5)];
    lineTopView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    [_rightContentView addSubview:lineTopView];
    UIView *lineBottomView = [[UIView alloc]
        initWithFrame:CGRectMake(0,
                                 (row + 1) * _dataResource.LineHeight - 0.5,
                                 _dataResource.allcolWidth, 0.5)];
    lineBottomView.backgroundColor = [Globle colorFromHexRGB:Color_White];
    [_rightContentView addSubview:lineBottomView];
  }
  //刷新
  if (_rightScrollView) {
    CGPoint pos = _rightScrollView.contentOffset;
    int randomNumber = arc4random() + 80;
    if (randomNumber % 2 == 0)
      [_rightScrollView setContentOffset:CGPointMake(pos.x + 0.5, pos.y)
                                   animated:NO];
    else
      [_rightScrollView setContentOffset:CGPointMake(pos.x - 0.5, pos.y)
                                   animated:NO];
  }
}
//创建选中效果视图
- (void)creatselectedView {
  if (_selectedView == nil) {
    _selectedView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                                                 _dataResource.LineHeight)];
    _selectedView.backgroundColor = [Globle colorFromHexRGB:@"#e2e2e2"];
    _selectedView.alpha = 0.5;
    //[self insertSubview:_selectedView atIndex:0];
    [_leftScrollView insertSubview:_selectedView
                              atIndex:0]; // addSubview:_selectedView
    if (_index >= 0) {
      _selectedView.center = CGPointMake(
          self.bounds.size.width / 2, (_dataResource.LineHeight * _index +
                                       _dataResource.LineHeight / 2));
      if (_isPositon == YES && _interstingView) {
        //当前页面是持仓页面
        _selectedView.hidden = YES;
        //[_leftScrollView insertSubview:_interstingView atIndex:100];
        _interstingView.hidden = NO;
        //得到模拟行
        _moniItemView.hidden = NO;
        UIView *headView =
            [_dataResource getTableCellLable:_index Column:0];
        if (headView && _moniItemView) {
          [_moniItemView addheadView:headView];
        }
        for (int col = 1; col < _dataResource.ColNumber; col++) {
          UIView *view =
              [_dataResource getTableCellLable:_index Column:col];
          if (view) {
            [_moniItemView addRightView:view];
          }
        }
        _moniItemView.center = _selectedView.center;
        [_leftScrollView addSubview:_moniItemView];
        //
        // _interstingView.center=_selectedView.center;
        _interstingView.hidden = NO;
        [self performSelector:@selector(ChangeViewWithClubAnitmation)
                   withObject:nil
                   afterDelay:0.1];
      }
    }
  } else {
    if (_index >= 0) {
      //
      _selectedView.hidden = NO;
      _selectedView.center = CGPointMake(
          self.bounds.size.width / 2, (_dataResource.LineHeight * _index +
                                       _dataResource.LineHeight / 2));
      if (_isPositon == YES && _interstingView) {
        //当前页面是持仓页面

        if (_interstingView.hidden == NO) {
          _interstingView.hidden = YES;
          [self performSelector:@selector(HideViewWithClubAnitmation)
                     withObject:nil
                     afterDelay:0.001];
          //[self animationsChangeView:_interstingView IsShow:NO];

        } else {
          //得到模拟行
          _moniItemView.hidden = NO;
          UIView *headView =
              [_dataResource getTableCellLable:_index Column:0];
          if (headView && _moniItemView) {
            [_moniItemView addheadView:headView];
          }
          for (int col = 1; col < _dataResource.ColNumber; col++) {
            UIView *view =
                [_dataResource getTableCellLable:_index Column:col];
            if (view) {
              [_moniItemView addRightView:view];
            }
          }
          _moniItemView.center = _selectedView.center;
          [_leftScrollView addSubview:_moniItemView];
          //
          // _interstingView.center=_selectedView.center;
          _interstingView.hidden = NO;
          //[self animationsChangeView:_interstingView IsShow:YES];
          [self performSelector:@selector(ChangeViewWithClubAnitmation)
                     withObject:nil
                     afterDelay:0.01];
        }
      }

    } else {
      _interstingView.hidden = YES;
      [self performSelector:@selector(HideViewWithClubAnitmation)
                 withObject:nil
                 afterDelay:0.01];
    }
  }
}
//清除表格显示内容
- (void)clearTableContent {
  //清除左标题上子页面
  if (_leftHeadView) {
    for (UIView *view in [_leftHeadView subviews]) {
      [view removeFromSuperview];
    }
  }
  //清除右标题上页面
  if (_rightHeadView) {
    for (UIView *view in [_rightHeadView subviews]) {
      [view removeFromSuperview];
    }
  }
  //清除左承载视图上子页面
  if (_letfContentView) {
    for (UIView *view in [_letfContentView subviews]) {
      [view removeFromSuperview];
    }
  }

  //清除右承载视图上子页面
  if (_rightContentView) {
    for (UIView *view in [_rightContentView subviews]) {
      [view removeFromSuperview];
    }
  }
}

//为自选股表格重新设置内容清除上次设置的内容
- (void)clearTableContentForSelfStock {
  //[self clearTableContent];
  //清除左承载视图上子页面
  if (_letfContentView) {
    for (UIView *view in [_letfContentView subviews]) {
      [view removeFromSuperview];
    }
  }

  //清除右承载视图上子页面
  if (_rightContentView) {
    for (UIView *view in [_rightContentView subviews]) {
      [view removeFromSuperview];
    }
  }
}

#pragma mark
#pragma mark 动画相关
//详情，明细，盘口等视图的切换函数
- (BOOL)animationsChangeView:(UIView *)m_root IsShow:(BOOL)isshow {
  if (isshow) {
    //展示
    m_root.alpha = 1;
    CATransform3D transform = CATransform3DMakeRotation(-M_PI, 1.0, 0.0, 0.0);
    _interstingView.layer.transform = transform;
  }

  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.5];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  if (!isshow) {
    [UIView setAnimationDidStopSelector:@selector(stopshowAnimation)];
  }

  //[UIView setAnimationDidStopSelector:@selector(stopshowAnimation)];
  if (isshow) {
    m_root.alpha = 1;
    CATransform3D transform = CATransform3DMakeRotation(0, 1.0, 0.0, 0.0);
    m_root.layer.transform = transform;
  } else {
    m_root.alpha = 0;
    CATransform3D transform = CATransform3DMakeRotation(-M_PI, 1.0, 0.0, 0.0);
    m_root.layer.transform = transform;
  }

  [UIView commitAnimations];

  return YES;
}
- (void)stopshowAnimation {
  _interstingView.hidden = YES;
}

//立方体翻转动画
- (void)changeViewWithClubAnitmation {
  if (_moniItemView == nil)
    return;
  _moniItemView.hidden = NO;
  _interstingView.hidden = NO;
  CATransition *tran = [CATransition animation];
  tran.type = @"cube";
  tran.subtype = kCATransitionFromTop;
  [_moniItemView.layer addAnimation:tran forKey:@"kongyu"];
  //[self.navigationController pushViewController:detailVc animated:YES];
  [_moniItemView addOpratinView:teiew];
  tran.duration = 0.5;
  // tran.delegate=self;
  [_moniItemView.layer addAnimation:tran forKey:@"ads"];
}

- (void)hideViewWithClubAnitmation {
  if (_moniItemView == nil)
    return;
  CATransition *tran = [CATransition animation];
  tran.type = @"cube";
  tran.subtype = kCATransitionFromBottom;
  [_moniItemView.layer addAnimation:tran forKey:@"kongyu"];
  //[self.navigationController pushViewController:detailVc animated:YES];
  [teiew removeFromSuperview];
  tran.duration = 0.5;
  tran.delegate = self;
  [_moniItemView.layer addAnimation:tran forKey:@"ads"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag == YES) {
    _moniItemView.hidden = YES;
  }
}

#pragma mark
#pragma mark 对外接口
- (void)setPostionFlage:(UIView *)interiew {
  _isPositon = YES;
  teiew = interiew;
  _interstingView = [[UIView alloc] initWithFrame:interiew.bounds];
}

- (void)setScrollVisible:(BOOL)isVisible {
  if (_leftScrollView) {
    _leftScrollView.scrollEnabled = isVisible;
  }
}

#pragma mark
#pragma mark 点击消息回调

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  //纪录初始点
  CGPoint pos = [[touches anyObject] locationInView:self];
  if (CGPointEqualToPoint(pos, _lastpos))
    return;
  _index = -1;
  // NSLog(@"pos.x=%f \n pos.y=%f",pos.x,pos.y);
  float m_y =
      _heightMoveHeight + pos.y - _leftHeadView.bounds.size.height;
  CGPoint m_realpos = CGPointMake(pos.x, m_y);
  for (int i = 0; i < _dataResource.LineNumber; i++) {
    CGRect rect =
        CGRectMake(0, i * _dataResource.LineHeight, self.bounds.size.width,
                   _dataResource.LineHeight);
    if (CGRectContainsPoint(rect, m_realpos)) {
      _index = i;
      break;
    }
  }
  // NSLog(@"index is : %d",_index);
  _lastpos = pos;
  // if(_index<0)
  // return;
  // NSLog(@"index is : %d",_index);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pos = [[touches anyObject] locationInView:self];
  if (CGPointEqualToPoint(pos, _lastUpPos))
    return;
  // NSInteger index=_index;
  // NSLog(@"index is : %d",_index);
  // if(_index<0)
  // return;
  if (_selectedView) {
    _selectedView.hidden = YES;
  }
  if (_delegate) {
    [self creatselectedView];
    [_delegate SimuTableItemDidSelected:_index];
  }
  _lastUpPos = pos;
}

#pragma mark
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (_rightHeadView && scrollView == _rightScrollView) {
    if (_selectedView) {
      _selectedView.hidden = YES;
    }

    CGFloat center_x = _leftHeadView.bounds.size.width +
                       _rightHeadView.bounds.size.width / 2;
    _rightHeadView.center = CGPointMake(
        center_x - scrollView.contentOffset.x, _rightHeadView.center.y);
  }
  if (scrollView == _leftScrollView) {
    // NSLog(@"scroll height= %f",scrollView.contentOffset.y);
    _heightMoveHeight = scrollView.contentOffset.y;
  }
}

- (UIScrollView *)getUpdateScrollView {
  return _leftScrollView;
}

//#pragma mark
//#pragma mark SimuTableDataResouceDelegate
//-(void)ResequenceTableList:(UISortListMode)Sequence Cor:(NSInteger)m_col
//{
//    if(_delegate!=nil)
//    {
//        [_delegate ResequenceTableList:Sequence Cor:m_col];
//    }
//}

// any offset changes
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
