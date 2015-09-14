//
//  BaseS5B5VC.h
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTrendVC.h"
#import "S5B5View.h"
#import "TimerUtil.h"
#import "HorizontalS5B5View.h"

@interface BaseS5B5VC : BaseTrendVC {
  TimerUtil *timerUtil;
}

///报价信息返回，通知观察者
@property(nonatomic, copy) OnStockQuotationInfoReady stockQuotationInfoReady;

- (void)createSB5View;

- (NSString *)priceFormat;

@end

@interface PortaitS5B5VC : BaseS5B5VC

///显示买5卖5的视图
@property(nonatomic, strong) S5B5View *s5b5View;

@end

@interface HorizontalS5B5VC : BaseS5B5VC

///显示买5卖5的视图
@property(nonatomic, strong) HorizontalS5B5View *s5b5View;

@end
