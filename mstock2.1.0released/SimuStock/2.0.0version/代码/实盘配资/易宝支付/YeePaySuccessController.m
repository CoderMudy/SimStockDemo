//
//  YeePaySuccessController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YeePaySuccessController.h"
#import "UIButton+Hightlighted.h"
#import "CutomerServiceButton.h"
#import "RechargeAccountViewController.h"

@implementation YeePaySuccessController

- (instancetype)initWithAmount:(NSString *)amount andIsSuccess:(BOOL)isSuccess {
  self = [self initWithAmount:amount andIsSuccess:isSuccess andCallBack:nil];
  return self;
}

- (instancetype)initWithAmount:(NSString *)amount
                  andIsSuccess:(BOOL)isSuccess
                   andCallBack:(callBackBlock)callBack {
  self = [super init];
  if (self) {
    self.amount = amount;
    self.isSuccess = isSuccess;
    self.callBack = callBack;
  }
  return self;
}

- (void)awakeFromNib {
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.clientView.hidden = YES;

  //创建客服电话按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
  self.indicatorView.hidden = YES;
  [self.topToolBar resetContentAndFlage:@"充值" Mode:TTBM_Mode_Sideslip];

  [self setupSubviews];
}

- (void)setupSubviews {
  self.amountLable.text = [NSString stringWithFormat:@"¥%@.00", self.amount];

  if (self.isSuccess) {
    [self.resultImageView
        setImage:[UIImage imageNamed:@"APayRes.bundle/payResult_success.png"]];
    self.resultLable.text = @"恭喜，您已付款成功";
  } else {
    [self.resultImageView
        setImage:[UIImage imageNamed:@"APayRes.bundle/payResult_fail.png"]];
    self.resultLable.text = @"支付失败，请联系客服";
  }

  [self.confirmBtn buttonWithNormal:Color_WFOrange_btn
               andHightlightedColor:Color_WFOrange_btnDown];
  self.confirmBtn.layer.cornerRadius = self.confirmBtn.height / 2;
  self.confirmBtn.layer.masksToBounds = YES;

  [self.confirmBtn addTarget:self
                      action:@selector(clickOnConfirmBtn:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickOnConfirmBtn:(UIButton *)clickedBtn {
  [self leftButtonPress];
}

- (void)leftButtonPress {
  if (self.callBack) {
    self.callBack();
  } else {
    __block RechargeAccountViewController *vc;
    [self.navigationController.viewControllers
        enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          if ([obj isKindOfClass:[RechargeAccountViewController class]]) {
            vc = (RechargeAccountViewController *)obj;
            *stop = YES;
          }
        }];
    [self.navigationController popToViewController:vc animated:NO];
  }
}

@end
