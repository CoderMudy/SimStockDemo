//
//  BankCardView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFAccountInterface.h"

@class RadioButton;

@interface BankCardView : UIView

/** 银行卡所属银行图标 */
@property(weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
/** 银行卡信息 */
@property(weak, nonatomic) IBOutlet UILabel *bankCardInfoLable;
/** 银行卡选择按钮 */
@property(weak, nonatomic) IBOutlet RadioButton *selectedBtn;
/** 视图间分隔线 */
@property(weak, nonatomic) IBOutlet UIView *marginView;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImage;

///银行id
@property (copy,nonatomic) NSString * bankCardId;


/** 设置子控件 */
- (void)setupSubviews;
- (void)getDataToBandCard:(WFBindedBankcardInfo *)info;
@end
