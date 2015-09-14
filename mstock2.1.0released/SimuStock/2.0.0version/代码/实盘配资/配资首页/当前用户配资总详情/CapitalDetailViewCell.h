//
//  CapitalDetailViewCell.h
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFProductContract.h"
#import "UIButton+Block.h"
@interface CapitalDetailViewCell : UITableViewCell {
  WFCurrentContractList *wfContractList;
}
///浮动盈亏
@property(weak, nonatomic) IBOutlet UILabel *FloatingLabel;
///总资产
@property(weak, nonatomic) IBOutlet UILabel *TotalAssetsLabel;
///股票市值
@property(weak, nonatomic) IBOutlet UILabel *StockmarketLable;
///可用金额
@property(weak, nonatomic) IBOutlet UILabel *AmountAvailableLabel;
///总保证金
@property(weak, nonatomic) IBOutlet UILabel *TotalMarginLabel;
@property(weak, nonatomic) IBOutlet UIButton *MyAmountBtn;

///实盘申请
@property(weak, nonatomic) IBOutlet BGColorUIButton *FirmApplicationBtn;

///赋值
- (void)giveWithUIAssignment:(WFCurrentContractList *)object;
@end
