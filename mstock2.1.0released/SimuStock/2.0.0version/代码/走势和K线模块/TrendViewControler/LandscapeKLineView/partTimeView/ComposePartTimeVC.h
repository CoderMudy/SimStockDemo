//
//  ComposePartTimeVC.h
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTrendVC.h"
#import "BaseS5B5VC.h"
#import "BasePartTimeVC.h"

@interface ComposePartTimeVC : BaseTrendVC

@property(nonatomic, strong) BaseS5B5VC *baseS5B5VC;

@property(nonatomic, strong) PortaitPartTimeVC *partTimeVC;

///报价信息返回，通知观察者
@property(nonatomic, copy) OnStockQuotationInfoReady stockQuotationInfoReady;
@end
