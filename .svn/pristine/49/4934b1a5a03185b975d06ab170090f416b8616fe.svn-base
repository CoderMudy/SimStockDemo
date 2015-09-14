//
//  BankCardView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFBindedBankcardYouGuuResult;

@class RadioButton;

@interface LianLianBankCardView : UIView

/** 银行卡所属银行图标 */
@property(weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
/** 银行卡信息 */
@property(weak, nonatomic) IBOutlet UILabel *bankCardInfoLable;

/** 视图间分隔线 */
@property(weak, nonatomic) IBOutlet UIView *marginView;
@property(weak, nonatomic) IBOutlet UIImageView *LogoImage;

@property(copy, nonatomic) NSString *bankName;
@property(copy, nonatomic) NSString *bankLogo;
@property(copy, nonatomic) NSString *bankNOLast;

/** 设置子控件 */
- (void)setupSubviews;
- (void)bindDataFromYouGuu:(WFBindedBankcardYouGuuResult *)info;

@end
