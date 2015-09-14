//
//  RealTradeHisDealVC.h
//  SimuStock
//
//  Created by Mac on 14-9-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RealTradeHistoryDealQueryVC : BaseViewController {
  //绑定数据
  BOOL _dataBind;
}
- (id)initWithCapital:(BOOL)isCapital;

@end
