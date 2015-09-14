//
//  StockSchoolViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-4-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockSchoolViewController.h"
#import "SimuAction.h"

#import "SimuUtil.h"
#import "StockSchoolListViewController.h"
#import "MobClick.h"

@implementation StockSchoolViewController

- (id)init {
  if (self = [super init]) {
    _nameArr = @[
      @"基础知识",
      @"交易指南",
      @"政策法规",
      @"证券词典",
      @"公司分析",
      @"财务分析",
      @"宏观分析",
      @"心理分析",
      @"k线形态",
      @"量价理论",
      @"成本分析",
      @"指标分析",
      @"波浪理论",
      @"道氏理论",
      @"江恩理论",
      @"其他理论",
      @"看盘培训",
      @"操盘攻略",
      @"主力研判",
      @"股林秘籍"
    ];
    
    _iconArr = @[
      @"小图标_基础知识",
      @"小图标_交易指南",
      @"小图标_政策法规",
      @"小图标_证券词典",
      @"小图标_公司分析",
      @"小图标_财务分析",
      @"小图标_宏观分析",
      @"小图标_心里分析",
      @"小图标_k线形态",
      @"小图标_量价理论",
      @"小图标_成本分析",
      @"小图标_指标分析",
      @"小图标_波浪理论",
      @"小图标_道氏理论",
      @"小图标_江恩理论",
      @"小图标_其他理论",
      @"看盘培训",
      @"小图标_操盘攻略",
      @"小图标_主力研判",
      @"小图标_股林秘籍"
    ];

    _moduleIdArr = @[
      @"3",
      @"4",
      @"5",
      @"6",
      @"10",
      @"11",
      @"12",
      @"13",
      @"15",
      @"16",
      @"17",
      @"18",
      @"19",
      @"20",
      @"21",
      @"22",
      @"24",
      @"25",
      @"26",
      @"27"
    ];
  }
  return self;
}
//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"股市学堂"];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"股市学堂"];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createViews];
}

#pragma 视图部分
- (void)createViews {
  [self resetTopView];
  [self createScrollView];
  [self createClassificationLabelView];
  [self createOperationalTaxonomicUnitView];
}
//创建分类单元视图
- (void)createOperationalTaxonomicUnitView {

  for (int i = 0; i < 4; i++) {
    if (2 == i) {
      UIView *bgroundView = [[UIView alloc]
          initWithFrame:CGRectMake(0, (49.0 * 3 + 145.0 * 2) / 2,
                                   basemapScroll.bounds.size.width, 145.0)];
      bgroundView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
      [basemapScroll addSubview:bgroundView];

      for (int n = 0; n < 8; n++) {
        CGRect rect =
            CGRectMake(((basemapScroll.bounds.size.width / 2) * (n % 4)) / 2,
                       (n > 3) ? 145 / 2 : 0.0,
                       basemapScroll.bounds.size.width / 4, 145.0 / 2);
        UIView *bgView =
            [self createClickviewimageName:_iconArr[4 * i + n]
                                 labeltext:_nameArr[4 * i + n]
                              buttonMethod:@selector(buttonTriggeringMethod:)
                                 buttonTag:(4 * i + n + 100)
                                      rect:rect];
        [bgroundView addSubview:bgView];
        if (n > 0 && n < 4) {
          UIView *lineView = [[UIView alloc]
              initWithFrame:CGRectMake((bgroundView.bounds.size.width * n) / 4,
                                       0.0, 0.5,
                                       bgroundView.bounds.size.height)];
          lineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
          [bgroundView addSubview:lineView];
        } else if (n > 4 && n < 8) {
          UIView *lineView = [[UIView alloc]
              initWithFrame:CGRectMake(
                                (bgroundView.bounds.size.width * (n - 4)) / 4,
                                0.0, 0.5, bgroundView.bounds.size.height)];
          lineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
          [bgroundView addSubview:lineView];
        }
        UIView *baselineView = [[UIView alloc]
            initWithFrame:CGRectMake(0.0,
                                     bgroundView.bounds.size.height / 2 - 0.5,
                                     bgroundView.bounds.size.width, 0.5)];
        baselineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
        [bgroundView addSubview:baselineView];
      }

    } else {
      UIView *bgroundView = [[UIView alloc]
          initWithFrame:CGRectMake(0, 49.0 / 2 +
                                          ((3 == i) ? (49.0 * 3 + 145.0 * 4) / 2
                                                    : ((49.0 + 145.0) * i) / 2),
                                   basemapScroll.bounds.size.width, 145.0 / 2)];
      bgroundView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
      [basemapScroll addSubview:bgroundView];

      for (int n = 0; n < 4; n++) {
        int index = 4 * ((3 == i) ? 4 : i) + n;
        CGRect rect =
            CGRectMake((((basemapScroll.bounds.size.width / 2) * n)) / 2, 0.0,
                       basemapScroll.bounds.size.width / 4, 145.0 / 2);
        UIView *bgView =
            [self createClickviewimageName:_iconArr[index]
                                 labeltext:_nameArr[index]
                              buttonMethod:@selector(buttonTriggeringMethod:)
                                 buttonTag:(4 * ((3 == i) ? 4 : i) + n + 100)
                                      rect:rect];
        [bgroundView addSubview:bgView];
        if (n > 0 && n < 4) {
          UIView *lineView = [[UIView alloc]
              initWithFrame:CGRectMake((bgroundView.bounds.size.width * n) / 4,
                                       0.0, 0.5,
                                       bgroundView.bounds.size.height)];
          lineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
          [bgroundView addSubview:lineView];
        }
      }
    }
  }
}

//创建分类视图
- (void)createClassificationLabelView {
  NSArray *classNameArr =
      @[ @"新手入门",
         @"基本面分析",
         @"技术面分析",
         @"高手进阶" ];
  for (int i = 0; i < classNameArr.count; i++) {
    UILabel *classNameLab =
        [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 200, 49.0 / 2)];
    classNameLab.font = [UIFont systemFontOfSize:Font_Height_12_0];
    classNameLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
    classNameLab.backgroundColor = [UIColor clearColor];
    classNameLab.text = classNameArr[i];
    if (3 == i) {
      classNameLab.frame =
          CGRectMake(17.0, (49.0 * 3 + 145.0 * 4) / 2, 200, 49.0 / 2);
    } else {
      classNameLab.frame =
          CGRectMake(17.0, ((145.0 + 49.0) * i) / 2, 200, 49.0 / 2);
    }
    [basemapScroll addSubview:classNameLab];
  }
}

#pragma UIScrollView
- (void)createScrollView {
  basemapScroll = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0.0, _topToolBar.bounds.size.height,
                               self.view.bounds.size.width,
                               self.view.bounds.size.height -
                                   _topToolBar.bounds.size.height)];
  basemapScroll.directionalLockEnabled = YES; //只能一个方向滑动
  basemapScroll.backgroundColor = [Globle colorFromHexRGB:@"d1d3d8"];
  basemapScroll.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
  basemapScroll.indicatorStyle =
      UIScrollViewIndicatorStyleWhite;               //滚动指示的风格
  basemapScroll.showsHorizontalScrollIndicator = NO; //水平方向的滚动指示
  basemapScroll.delegate = self;
  CGSize newSize =
      CGSizeMake(self.view.frame.size.width, (49.0 * 4 + 145.0 * 5) / 2);
  [basemapScroll setContentSize:newSize];
  [self.view addSubview:basemapScroll];
  backgroundView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width,
                               (49.0 * 4 + 145.0 * 5) / 2)];
  //修改
  backgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d1d3d8"];
  [basemapScroll addSubview:backgroundView];
}

//顶部导航视图
- (void)resetTopView {
  //顶部导航视图
  [_topToolBar resetContentAndFlage:@"股市学堂" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
}

#pragma mark
#pragma mark SimuTouchMoveViewDelegate
- (void)TouchMoveWidth:(float)width {
  CGPoint pos = CGPointMake(self.view.center.x + width, self.view.center.y);
  if (pos.x > self.view.bounds.size.width / 2 &&
      pos.x < self.view.bounds.size.width * 3.f / 2.f) {
    self.view.center = pos;
  }
}

- (void)TouchEnd {
  if (self.view.center.x <= self.view.bounds.size.width) {
    SimuAction *action = nil;
    if (bvc_showMode == UIView_ShowMode_half) {

      action =
          [[SimuAction alloc] initWithCode:AC_ViewMove_ToFull ActionURL:nil];
      [[NSNotificationCenter defaultCenter]
          postNotificationName:SYS_VAR_NAME_DOACTION_MSG
                        object:action];
    }
    if (stmv_touchView) {
      stmv_touchView.hidden = YES;
    }
  } else {
    SimuAction *action = nil;
    if (bvc_showMode == UIView_ShowMode_half) {
      bvc_showMode = UIView_ShowMode_full;
      action =
          [[SimuAction alloc] initWithCode:AC_ViewMove_ToHalf ActionURL:nil];
      [[NSNotificationCenter defaultCenter]
          postNotificationName:SYS_VAR_NAME_DOACTION_MSG
                        object:action];
    }
  }
}

- (void)TouchEndNotMove {
  SimuAction *action = nil;
  if (bvc_showMode == UIView_ShowMode_half) {
    action = [[SimuAction alloc] initWithCode:AC_ViewMove_ToFull ActionURL:nil];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:SYS_VAR_NAME_DOACTION_MSG
                      object:action];
  }
  if (stmv_touchView) {
    stmv_touchView.hidden = YES;
  }
}

//封装单元控件
- (UIView *)createClickviewimageName:(NSString *)image
                           labeltext:(NSString *)name
                        buttonMethod:(SEL)btnMethod
                           buttonTag:(NSInteger)btnTag
                                rect:(CGRect)rect {
  UIView *bgView = [[UIView alloc] initWithFrame:rect];
  bgView.backgroundColor = [Globle colorFromHexRGB:@"#e6eced"];

  UIImageView *imgView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
  imgView.frame = CGRectMake((bgView.bounds.size.width * 2 - 56.0) / 4,
                             30.0 / 2, 56.0 / 2, 56.0 / 2);
  [bgView addSubview:imgView];

  UILabel *nameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 95.0 / 2, bgView.bounds.size.width,
                               24.0 / 2)];
  nameLab.font = [UIFont systemFontOfSize:Font_Height_12_0];
  nameLab.textAlignment = NSTextAlignmentCenter;
  nameLab.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  nameLab.backgroundColor = [UIColor clearColor];
  nameLab.text = name;
  [bgView addSubview:nameLab];

  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = bgView.bounds;
  btn.backgroundColor = [UIColor clearColor];
  btn.tag = btnTag;
  UIImage *backImage = [UIImage imageNamed:@"点击背景图.png"];
  [btn setBackgroundImage:backImage forState:UIControlStateHighlighted];
  [btn addTarget:self
                action:btnMethod
      forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:btn];
  return bgView;
}

#pragma UIButton触发方法
- (void)buttonTriggeringMethod:(UIButton *)btn {
  NSInteger moduleindex = btn.tag - 100;

  //列表ID
  StockSchoolListViewController *stockSchoolListVC =
      [[StockSchoolListViewController alloc] init];
  stockSchoolListVC.titleName = _nameArr[moduleindex];
  stockSchoolListVC.moduleId = _moduleIdArr[moduleindex];
  [AppDelegate pushViewControllerFromRight:stockSchoolListVC];
}

- (void)changeBtnColor {
  UIButton *btn = (UIButton *)[self.view viewWithTag:buttonTag];
  btn.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
