//
//  BaseViewController.h
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：本类为视图控制器基本类。用来存放基本的八个视图控制器共有的控件
 *
 */
#import <UIKit/UIKit.h>
#import "Globle.h"
#import "SimTopBannerView.h"
#import "SimuIndicatorView.h"
#import "LittleCattleView.h"

#define BGViewWidth self.view.frame.size.width

//标志当前页面展示模式
typedef enum {
  //全屏展示模式
  UIView_ShowMode_full,
  //半屏展示模式
  UIView_ShowMode_half,
} UISimuShowViewMode;

typedef void (^refreshButtonPressDownBlock)(void);

@interface BaseViewController
    : UIViewController <SimTopBannerViewDelegate, SimuIndicatorDelegate> {
  SimTopBannerView *_topToolBar;

  SimuIndicatorView *_indicatorView;

  UIView *_clientView;

  /** 当前视图的展示模式 */
  UISimuShowViewMode bvc_showMode;

  /** 工具栏高度 */
  float topToolBarHeight;

  /** 适配后的起始位置，ios7=20, ios7以下为0 */
  int startY;

  /** 小牛视图，使用isCry:(BOOL)来切换哭牛和笑牛。setInformation设置笑牛标签*/
  LittleCattleView *_littleCattleView;
}

/** 可使用的客户区 */
@property(strong, nonatomic) UIView *clientView;

/** 顶部工具栏 */
@property(strong, nonatomic) SimTopBannerView *topToolBar;

/** 顶部联网等待菊花 */
@property(strong, nonatomic) SimuIndicatorView *indicatorView;

/** 容器VC设置的frame */
@property(assign, nonatomic) CGRect frameInParent;

/** 容器VC设置的返回处理 */
@property(copy, nonatomic) onBackButtonPressed backHandlerInContainer;
@property(copy, nonatomic)
    refreshButtonPressDownBlock refreshButtonPressDownBlock;
@property(assign, nonatomic) BOOL dataBinded;

/** 使用指定的frame大小设置页面的大小 */
- (id)initWithFrame:(CGRect)frame;

/** 非法登录处理 */
+ (void)onIllegalLogin;

/**
 设置点击back按钮的处理逻辑
 当多个页面公用一个处理逻辑时，使用此接口
 */
- (void)setBackButtonPressedHandler:(onBackButtonPressed)handler;

/**
 点击back按钮调用的函数
 */
- (void)leftButtonPress;

+ (BOOL)isIOS7;

/**
 返回当前页面是否用户可视状态
 */
- (BOOL)isVisible;
/**
 重新设定页面标题
 */
- (void)resetTitle:(NSString *)title;

/**延迟指定的秒数，执行block代码块 */
- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds;
@end
