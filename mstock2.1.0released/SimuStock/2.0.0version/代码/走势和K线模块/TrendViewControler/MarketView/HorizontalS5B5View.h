//
//  HorizontalS5B5View.h
//  SimuStock
//
//  Created by Mac on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrendKLineModel.h"

@interface HorizontalS5B5View : UIView

@property(weak, nonatomic) IBOutlet UILabel *lblCurPrice;

@property(strong, nonatomic) IBOutletCollection(UILabel)
    NSArray *sellPriceLabels;

@property(strong, nonatomic) IBOutletCollection(UILabel)
    NSArray *sellAmountLabels;

@property(strong, nonatomic) IBOutletCollection(UILabel)
    NSArray *buyPriceLabels;

@property(strong, nonatomic) IBOutletCollection(UILabel)
    NSArray *buyAmountLabels;

- (void)initViews;

- (void)bindS5B5Data:(StockQuotationInfo *)quotationInfo
         priceFormat:(NSString *)priceFormat;

@end
