//
//  FundHoldStockHeaderCell.h
//  SimuStock
//
//  Created by Mac on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundHoldStockHeaderCell : UITableViewCell

///更新时间
@property(weak, nonatomic) IBOutlet UILabel *lblUpdateTime;

///调整持仓明细的按钮
@property(weak, nonatomic) IBOutlet UIButton *btnHoldStockDetail;

- (void)bindUpdateDate:(NSString *)date
          withFundCode:(NSString *)fundCode
          withFundName:(NSString *)fundName;

@end
