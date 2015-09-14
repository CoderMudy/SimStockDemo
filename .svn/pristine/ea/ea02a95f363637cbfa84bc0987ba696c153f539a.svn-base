//
//  YeePaySuccessController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^callBackBlock)(void);

@class BGColorUIButton;

@interface YeePaySuccessController : BaseViewController

/** 支付金额Lable */
@property(weak, nonatomic) IBOutlet UILabel *amountLable;
/** 支付结果图片 */
@property(weak, nonatomic) IBOutlet UIImageView *resultImageView;
/** 支付结果Lable */
@property(weak, nonatomic) IBOutlet UILabel *resultLable;
/** 确定按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmBtn;

/** 支付金额 */
@property(copy, nonatomic) NSString *amount;
/** 是否支付成功 */
@property(assign, nonatomic) BOOL isSuccess;

/** 回调Block */
@property(copy, nonatomic) callBackBlock callBack;

- (instancetype)initWithAmount:(NSString *)amount andIsSuccess:(BOOL)isSuccess;

- (instancetype)initWithAmount:(NSString *)amount
                  andIsSuccess:(BOOL)isSuccess
                   andCallBack:(callBackBlock)callBack;

@end
