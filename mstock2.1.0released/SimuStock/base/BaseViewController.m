//
//  BaseViewController.m
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "WeiBoExtendButtons.h"

@implementation BaseViewController

+ (BOOL)isIOS7 {
  return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
}

- (id)initWithFrame:(CGRect)frame {
  self.frameInParent = frame;
  return [super init];
}

- (id)init {
  self = [super init];
  if (self) {
    bvc_showMode = UIView_ShowMode_full;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (CGRectIsEmpty(self.frameInParent)) {
    self.frameInParent = self.view.frame;
  } else {
    self.view.frame = self.frameInParent;
  }
  NSLog(@"\n-------------------\n%@ 已创建\n-------------------",
        self); //[NSString stringWithUTF8String:object_getClassName(self)]
  //设置统一的页面背景色
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _dataBinded = NO;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    // ios7.0及以上版本
    startY = 20;
  } else {
    // ios7.0版本
    startY = 0;
  }

  topToolBarHeight = 45 + startY;
  [self creatTopToolBarView];
  [self creatIndicatorView];
  [self creatClientView];
  [self createLittleCattleView];
}

#pragma mark
#pragma mark PV统计相应函数

//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark
#pragma mark 创建页面控件
//创建上工具栏控件
- (void)creatTopToolBarView {
  //创建上工具栏
  _topToolBar = [[SimTopBannerView alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, topToolBarHeight)];
  _topToolBar.delegate = self;
  [_topToolBar resetContentAndFlage:@"" Mode:TTBM_Mode_Leveltwo];
  [self.view addSubview:_topToolBar];
}
//创建联网等待菊花
- (void)creatIndicatorView {
  _indicatorView = [[SimuIndicatorView alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 40, topToolBarHeight - 45, 40, 45)];
  _indicatorView.delegate = self;
  [_topToolBar addSubview:_indicatorView];
}
//创建客户区视图
- (void)creatClientView {
  _clientView =
      [[UIView alloc] initWithFrame:CGRectMake(0, topToolBarHeight, self.view.bounds.size.width,
                                               self.view.bounds.size.height - topToolBarHeight)];
  [self.view addSubview:_clientView];
}

//创建小牛视图
- (void)createLittleCattleView {
  _littleCattleView = [[LittleCattleView alloc] initWithFrame:self.view.frame information:nil];
  __weak BaseViewController *weakSelf = self;
  _littleCattleView.cryRefreshBlock = ^(){
    BaseViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf refreshButtonPressDown];
    }
  };
  [self.view addSubview:_littleCattleView];
}

#pragma mark
#pragma mark SimTopBannerViewDelegate 协议
- (void)leftButtonPress {
  if (self.backHandlerInContainer) {
    self.backHandlerInContainer();
    return;
  }

  [[UIApplication sharedApplication] setStatusBarHidden:NO];

  //隐藏当前显示的弹出框
  [[WeiBoExtendButtons sharedExtendButtons] hideAndScaleSmall];

  //  //先将未到时间执行前的任务取消。
  //  [[self class] cancelPreviousPerformRequestsWithTarget:self
  //  selector:@selector(todoSomething) object:nil];
  //  [self performSelector:@selector(todoSomething) withObject:nil
  //  afterDelay:0.5f];
  [AppDelegate popViewController:YES];
}

//-(void)todoSomething
//{
//  [AppDelegate popViewController:YES];
//}

///右边按钮按下  delegate代理
- (void)rightButtonPress {
}
///隐藏右边原有的刷新按钮
- (void)hideRefreshButton {
  _indicatorView.hidden = YES;
}
#pragma mark SimuIndicatorDelegate 协议
- (void)refreshButtonPressDown {
  if (_indicatorView) {
    [_indicatorView startAnimating];
  }
  if (_refreshButtonPressDownBlock) {
    _refreshButtonPressDownBlock();
  }
}

- (void)setBackButtonPressedHandler:(onBackButtonPressed)handler {
  self.backHandlerInContainer = handler;
};

- (BOOL)isVisible {
  return [self isViewLoaded] && self.view.window;
}

- (void)resetTitle:(NSString *)title {
  [_topToolBar resetContentAndFlage:title Mode:TTBM_Mode_Leveltwo];
}

- (void)dealloc {
  NSLog(@"\n-------------------\n%@ 已经释放\n----------------", self);
}

- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime =
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), block);
}

+ (void)onIllegalLogin {
  [[NSNotificationCenter defaultCenter] postNotificationName:Illegal_Logon_SimuStock object:nil];
}

@end
