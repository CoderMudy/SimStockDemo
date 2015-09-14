//
//  CapitalFirstViewCell.h
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserBandPhoneNumber.h"
#import "UIButton+Block.h"
#import "TimerUtil.h"

@class SBTickerView;
@class CapitalScrollView;
/**
 点击按钮的回调函数
 */
typedef void (^CapitalFirstBtnClick)();
@interface CapitalFirstViewCell : UITableViewCell {
  NSString *_currentClock;
  NSArray *_clockTickers;
  NSArray *_backcolorTickers;
  BOOL dataBind;
}

@property(weak, nonatomic) IBOutlet BGColorUIButton *CapitalBtn;

@property(weak, nonatomic) IBOutlet UILabel *labeltext;

@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMillions1;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMillions2;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMillions3;

@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewThousand1;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewThousand2;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewThousand3;

@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMeta1;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMeta2;
@property(weak, nonatomic) IBOutlet SBTickerView *TickerViewMeta3;

@property(weak, nonatomic) IBOutlet CapitalScrollView *CapitalScrollView;

/** 我的配资 button */
@property(weak, nonatomic) IBOutlet UIButton *myWFAccountButton;
/** 我的配资 账户图标 */
@property(weak, nonatomic) IBOutlet UIImageView *myWFAccountImgView;
/** 我的配资 “我的配资”标签 */
@property(weak, nonatomic) IBOutlet UILabel *myWFAccountLabel;
/** 我的配资 button 的触发方法*/
- (IBAction)clickMyWFAccountButtonGotoMyAccountPage:(id)sender;

/** 刷新跑马灯的定时器 */
@property(nonatomic, strong) TimerUtil *timeUtil;
/// block 回调
@property(nonatomic, copy) CapitalFirstBtnClick block;

@property(nonatomic) BOOL isLogin;

/// 当用户登录以后，却还没有配资账户
@property(nonatomic) BOOL isWFamount;
///刷新跑马灯数据
- (void)refreshMarqueeData;

@end
