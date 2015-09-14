//
//  WFBindBankCardViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFBindBankCardViewController.h"
#import "WFIdentityInformation.h"
#import "WFRegularExpression.h"
#import "WFBindBankRequestData.h"
#import "UIButton+Hightlighted.h"
#import "CutomerServiceButton.h"

@interface WFBindBankCardViewController () {
  //加个滚动视图
  UIScrollView *_myScrollView;

  /** 银行卡信息 */
  WFBankCarInformation *_bankCarInfo;
  /** 身份信息 */
  WFIdentityInformation *_identityInfo;
}

@property(nonatomic, strong) BGColorUIButton *submissionButton;

@end
@implementation WFBindBankCardViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"银行卡绑定" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  [self isNetwork];
  //创建界面
  [self createScrollView];
  [self creatView];
  //创建客服热线 和 确认提交按钮
  [self creatCreateCustomerServicePhoneAndSubmissionButton];
}
/** 判断网络状态 */
- (void)isNetwork {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
}

/** 创建一个滚动器 */
- (void)createScrollView {
  _myScrollView = [[UIScrollView alloc] init];
  _myScrollView.frame =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 45);
  _myScrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, _myScrollView.height);
  _myScrollView.showsVerticalScrollIndicator = NO;
  [_clientView addSubview:_myScrollView];

  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapClick)];
  [_myScrollView addGestureRecognizer:tap];
}
- (void)tapClick {
  [self.view endEditing:NO];
  _myScrollView.contentOffset = CGPointMake(0, 0);
}
//创建界面
- (void)creatView {
  _identityInfo = [[[NSBundle mainBundle] loadNibNamed:@"WFIdentityInformation"
                                                 owner:nil
                                               options:nil] lastObject];
  _identityInfo.frame = CGRectMake(0, 0, CGRectGetWidth(_identityInfo.bounds),
                                   CGRectGetHeight(_identityInfo.bounds));
  [_myScrollView addSubview:_identityInfo];

  _bankCarInfo = [[[NSBundle mainBundle] loadNibNamed:@"WFBankCarInformation"
                                                owner:nil
                                              options:nil] lastObject];
  _bankCarInfo.delegate = self;
  _bankCarInfo.frame = CGRectMake(0, CGRectGetMaxY(_identityInfo.frame) + 10,
                                  CGRectGetWidth(_bankCarInfo.bounds),
                                  CGRectGetHeight(_bankCarInfo.bounds));
  [_myScrollView addSubview:_bankCarInfo];
}
////delegate 的高度
///跳转高度
- (void)ChangeScrollviewHight {
  _myScrollView.contentOffset = CGPointMake(0, 160);
}

//创建客服电话 和 确认提交按钮
- (void)creatCreateCustomerServicePhoneAndSubmissionButton {
  //创建客服电话
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
  //确定按钮
  self.submissionButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  self.submissionButton.frame =
      CGRectMake((CGRectGetWidth(self.clientView.bounds) - 150) * 0.5,
                 CGRectGetMaxY(_bankCarInfo.frame) + 30, 150, 40);
  [self.submissionButton buttonWithTitle:@"确认提交"
                      andNormaltextcolor:Color_White
                andHightlightedTextColor:Color_White];
  [self.submissionButton buttonWithNormal:Color_WFOrange_btn
                     andHightlightedColor:Color_WFOrange_btnDown];
  self.submissionButton.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_16_0];
  self.submissionButton.layer.cornerRadius = self.submissionButton.height * 0.5;
  self.submissionButton.layer.masksToBounds = YES;
  [self.submissionButton addTarget:self
                            action:@selector(submissionButtonAction)
                  forControlEvents:UIControlEventTouchUpInside];
  self.submissionButton.backgroundColor = [Globle colorFromHexRGB:@"fe8519"];
  [_myScrollView addSubview:self.submissionButton];
}

/** 确认提交按钮的触发方法 */
- (void)submissionButtonAction {
  [self tapClick];

  [self isNetwork];
  if (_bankCarInfo.bankID == 0) {
    [NewShowLabel setMessageContent:@"请选择银行卡类型"];
    return;
  }
  //判断银行卡的真实性，并且进行网络请求
  [self checkBankCardAuthenticity];
}
/** 判断银行卡的真实性 */
- (void)checkBankCardAuthenticity {
  if (_bankCarInfo.MainTextField.text.length > 0) {
    //判断银行卡的位数
    BOOL isNo = [WFRegularExpression
        judgmentFullNameLegitimacy:_bankCarInfo.MainTextField.text
              withBankIdentityInfo:BankCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"银行卡号输入有误," @"请"
                    @"重新填" @"写"];
      return;
    } else {
      //判断银行卡的真实性
      BOOL bankCardNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              _bankCarInfo.MainTextField.text
                                           withBankIdentityInfo:BankCardNumber];
      if (bankCardNo == NO) {
        [NewShowLabel setMessageContent:@"请填写正确的银行卡号"];
        return;
      } else {
        //银行卡正确 【请求绑定手机号】
        [self bindBankCardWithChannel:@"1"
                           withCardNo:_bankCarInfo.MainTextField.text
                           withBankid:_bankCarInfo.bankID];
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"银行卡号不能为空"];
  }
}

#pragma mark - 绑定银行卡
- (void)bindBankCardWithChannel:(NSString *)channel
                     withCardNo:(NSString *)cardNo
                     withBankid:(NSString *)bankId {
  // 1.2 用户实名认证接口
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  if (!self.submissionButton.enabled) {
    return;
  }
  self.submissionButton.enabled = NO;
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WFBindBankCardViewController *weakSelf = self;

  callBack.onCheckQuitOrStopProgressBar = ^{
    WFBindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      self.submissionButton.enabled = YES;
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    WFBindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:@"银行卡绑定成功"];
      if (strongSelf.block) {
        strongSelf.block(YES);
      } else {
        [strongSelf.navigationController popViewControllerAnimated:NO];
      }
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    WFBindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler](obj, exc);
    }
  };
  callBack.onFailed = ^{
    WFBindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler]();
    }
  };

  [WFBindBankRequestData requestBindBankWithChannel:channel
                                         withCardNo:cardNo
                                         withBankid:bankId
                                       withCallback:callBack];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
