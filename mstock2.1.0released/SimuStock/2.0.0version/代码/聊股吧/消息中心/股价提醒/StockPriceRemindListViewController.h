//
//  StockPriceRemindListViewController.h
//  SimuStock
//
//  Created by jhss on 15-4-19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageSystemViewController.h"
#import "StockPriceRemindTableVC.h"
@interface StockPriceRemindListViewController
    : BaseViewController <SimuIndicatorDelegate> {
  StockPriceRemindTableVC *_stockPriceRemindVC;
  /** 清除按钮*/
  UIButton *_clearBtn;
}
@end
