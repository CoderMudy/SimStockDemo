//
//  StockPriceRemindViewController.h
//  SimuStock
//
//  Created by xuming tan on 15-3-12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

/**提醒设置自控制器*/
@interface StockPriceRemindViewController : UIViewController {
  /**股价提醒界面*/
  UIView *stockRemindVC;
}
@property(nonatomic, strong) NSString *firstType;
@property(nonatomic, strong) NSString *stockCode;

/**股价涨到单位标签*/
@property(weak, nonatomic) IBOutlet UILabel *unitOfStockPriceDropTo;
/**股价跌到单位标签*/
@property(weak, nonatomic) IBOutlet UILabel *unitOfStockPriceUpto;
/**股价涨到标签*/
@property(weak, nonatomic) IBOutlet UILabel *stockPriceUpToLabel;
/**股价跌到标签*/
@property(weak, nonatomic) IBOutlet UILabel *stockPriceDropToLabel;
/**股票名称*/
@property(weak, nonatomic) IBOutlet UILabel *stockNameLabel;
/**股票代码*/
@property(weak, nonatomic) IBOutlet UILabel *stockIDLabel;
/**最新价*/
@property(weak, nonatomic) IBOutlet UILabel *latestPriceLabel;
/**涨跌幅*/
@property(weak, nonatomic) IBOutlet UILabel *stockPriceChangeLabel;
/**股价涨到开关*/
@property(weak, nonatomic) IBOutlet UISwitch *stockPriceUptoSwitch;
/**股价跌到开关*/
@property(weak, nonatomic) IBOutlet UISwitch *stockPriceDowntoSwitch;
/**日涨幅到开关*/
@property(weak, nonatomic) IBOutlet UISwitch *dailyGainsToSwitch;
/**日跌幅到开关*/
@property(weak, nonatomic) IBOutlet UISwitch *dailyDropsToSwitch;
/**断线精灵开关*/
@property(weak, nonatomic) IBOutlet UISwitch *shotSpiritSwitch;

/**股价涨到文本输入框*/
@property(weak, nonatomic) IBOutlet UITextField *stockPriceUptoTextField;
/**股价跌到文本输入框*/
@property(weak, nonatomic) IBOutlet UITextField *stockPriceDropstoTextField;
/**日涨幅到文本输入框*/
@property(weak, nonatomic) IBOutlet UITextField *dailyGainsTextField;
/**日跌幅到文本输入框*/
@property(weak, nonatomic) IBOutlet UITextField *dailyDropsTextField;
/** 股票精灵 */
@property(weak, nonatomic) IBOutlet UIView *shotSpiritView;

@property (weak, nonatomic) IBOutlet UILabel *upAndDownLabel;
/**最新价的宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *latestPriceWidth;

/**重置股价涨到股价跌到输入文本颜色*/
- (void)resetTextColorOfTextField;
/**当是大盘指数股价提醒页面要作改变*/
- (void)changeElement;

/** 验证最新价格，不可用为空或0，必须大于0 */
- (BOOL)validateLatestPrice;

/** 验证价格上限，不可为空，0，或者小数点，必须大于最新价 */
- (BOOL)validatePriceUpLimit;

/** 验证价格下限，不可为空，0，或者小数点，必须小于最新价 */
- (BOOL)validatePriceDownLimit;

/** 验证价格上涨百分比，不可为空，0，或者小数点 */
- (BOOL)validateDailyGain;

/** 验证价格下跌百分比，不可为空，0，或者小数点 */
- (BOOL)validateDailyDrop;

@end
