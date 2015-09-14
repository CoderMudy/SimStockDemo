//
//  RealNameAuthenticationViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RealNameAuthenticationViewController.h"
#import "WFRegularExpression.h"
#import "NSString+validate.h"
#import "CutomerServiceButton.h"
@interface RealNameAuthenticationViewController ()

@property(nonatomic, copy) NSString *stringA;

@end

@implementation RealNameAuthenticationViewController

-(void)awakeFromNib{
  [super awakeFromNib];
  self.view.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
}

- (id)initWithRealUserCertBlock:(RealUserCertBlock)block {
  self = [super init];
  if (self) {
    self.realUsercertBlock = block;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //显示实名认证
  [_topToolBar resetContentAndFlage:@"实名认证" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  self.clientView.alpha = 0;
  //设置右上角“客服热线”按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
  //设置textField
  [self setUpTextFieldNameAndIdCard];
  //设置按钮的高亮状态
  [self setConfirmButtonHighlighted];
  //设置阅读并同意的小按钮
  self.isSelected = YES;
  [self clickOnHaveReadBtn:self.agreeButton];
  // Do any additional setup after loading the view from its nib.
}
/** 设置了身份证和姓名的输入框 */
- (void)setUpTextFieldNameAndIdCard {
  //身份证
  self.realIdCardTF.delegate = self;
  self.realIdCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.realIdCardTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  self.realIdCardTF.textColor = [Globle colorFromHexRGB:@"454545"];
  self.realIdCardTF.font = [UIFont systemFontOfSize:14];

  //姓名
  self.realNameTF.delegate = self;
  self.realNameTF.textColor = [Globle colorFromHexRGB:@"454545"];
  self.realNameTF.font = [UIFont systemFontOfSize:14];
}

//限定身份证的输入位数
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  //判断身份证输入框
  if (textField == self.realIdCardTF) {
    //设定输入身份证号码
    if (![NSString validataIdCardNumberOnInput:[textField text]]) {
      return NO;
    }
    if ([toBeString length] > 18) {
      textField.text = [toBeString substringToIndex:18];
      return NO;
    }
  }
  //判断姓名输入框
  if (textField == self.realNameTF) {
    if ([toBeString length] > 16) {
      textField.text = [toBeString substringToIndex:16];
      return NO;
    }
  }
  return YES;
}
/** 设置确定按钮的高亮状态 */
- (void)setConfirmButtonHighlighted {
  self.confirmButton.normalBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.confirmButton.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];
  [self.confirmButton buttonWithTitle:@"确定"
                   andNormaltextcolor:Color_White
             andHightlightedTextColor:Color_White];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
/** 重写了左上角的返回按钮 */
- (void)leftButtonPress {
  [super leftButtonPress];
}

///点击”确认“按钮提交认证信息
- (IBAction)confirmSubmitInfomationButtonPress:(id)sender {
  //判断是否阅读并勾选提示
  if (self.isSelected == YES) {
    //没有阅读并勾选提示
    [NewShowLabel setMessageContent:@"请确认已阅读提醒信息"];
  } else {
    ///验证姓名，姓名内嵌套了身份证验证，身份证验证成功后进行网络请求
    ///【1.首先验证姓名】
    [self checkReaNameAuthenticity];
  }
}
/** 判断姓名的真实性 */
- (void)checkReaNameAuthenticity {
  if (self.realNameTF.text.length > 0) {
    if (self.realNameTF.text.length >= 2) {
      //判断内容的是否合法
      BOOL isNo =
          [WFRegularExpression judgmentFullNameLegitimacy:self.realNameTF.text
                                     withBankIdentityInfo:FullName];
      if (isNo == NO) {
        [NewShowLabel setMessageContent:@"请输入中文"];
        return;
      } else {
        //姓名验证正确  【2.第二步验证身份证号】
        [self checkRealIdCardAuthenticity];
      }
    } else {
      [NewShowLabel setMessageContent:@"请填真实的姓名"];
      return;
    }
  } else {
    [NewShowLabel setMessageContent:@"姓名不能为空"];
  }
}
/** 判断身份证号真实性 */
- (void)checkRealIdCardAuthenticity {
  if (self.realIdCardTF.text.length > 0) {
    //判断身份证位数的合法性
    BOOL isNo =
        [WFRegularExpression judgmentFullNameLegitimacy:self.realIdCardTF.text
                                   withBankIdentityInfo:IdentityCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"身份证号输入有误," @"请"
                    @"重新填" @"写"];
      return;
    } else {
      //身份证的有效性
      BOOL idnetityNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              self.realIdCardTF.text withBankIdentityInfo:IdentityCardNumber];
      if (idnetityNo == NO) {
        [NewShowLabel setMessageContent:@"请填写正确的身份证号"];
        return;
      } else {
        NSLog(@"断点");
        //身份证验证正确  【3.发送姓名和身份证号进行实名认证】
        [self performSelector:@selector(
                                  returnsTheRealNameAuthenticationNetworkData)
                   withObject:nil
                   afterDelay:0.3];
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"身份证号不能为空"];
  }
}

#pragma mark - 进行实名认证
/** 实名认证的接口请求 */
- (void)returnsTheRealNameAuthenticationNetworkData {
  // 1.2 用户实名认证接口
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  if (!self.confirmButton.enabled) {
    return;
  }
  self.confirmButton.enabled = NO;
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  //解析
  __weak RealNameAuthenticationViewController *weakSelf = self;

  callBack.onSuccess = ^(NSObject *obj) {
    RealNameAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf onRealNameAuthenticationSuccess];
      self.confirmButton.enabled = YES;
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    RealNameAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler](obj, exc);
      self.confirmButton.enabled = YES;
    }
  };
  callBack.onFailed = ^{
    RealNameAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler]();
      self.confirmButton.enabled = YES;
    }
  };

  [WFFinancingParse
      wfUserRealNameAuthenticationWithRealName:self.realNameTF.text
                                  withCertType:@"1"
                                    withCertNo:self.realIdCardTF.text
                                  withCallback:callBack];
}

- (void)onRealNameAuthenticationSuccess {
  [SimuUtil setUserCertName:self.realNameTF.text];
  [SimuUtil setUserCertNo:self.realIdCardTF.text];
  [self.navigationController popViewControllerAnimated:NO];
  [SimuUtil performBlockOnMainThread:^{
    if (self.realUsercertBlock) {
      self.realUsercertBlock(YES);
    }
  } withDelaySeconds:0.2];
}

/** 使键盘消失 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.realIdCardTF resignFirstResponder];
  [self.realNameTF resignFirstResponder];
}
/** 阅读并同意注意事项点击按钮 的点击事件*/
- (IBAction)checkAgreeButtonIsSelected:(id)sender {
  [self clickOnHaveReadBtn:self.agreeButton];
}

/** 已阅读按钮点击相应函数 */
- (void)clickOnHaveReadBtn:(UIButton *)clickBtn {
  clickBtn.layer.masksToBounds = YES;
  clickBtn.imageEdgeInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
  clickBtn.layer.cornerRadius = self.agreeButton.height / 2;
  if (self.isSelected == YES) {
    [clickBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
              forState:UIControlStateNormal];
    [clickBtn setBackgroundColor:[Globle colorFromHexRGB:Color_WFOrange_btn]];
    self.isSelected = NO;
  } else {
    [clickBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
              forState:UIControlStateNormal];
    [clickBtn setBackgroundColor:[Globle colorFromHexRGB:Color_Gray]];
    self.isSelected = YES;
  }
}

@end
