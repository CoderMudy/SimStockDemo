//
//  WithdrawalCashViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WithdrawalCashViewController.h"
#import "BankCardView.h"

///提现
///身份验证网络请求
///身份认证界面
/** 视图之间的竖直间距 */
#define Max_Number_Bankcard 5

/** 视图之间的竖直间距 */
#define Subview_Y_Margin 9.0
/** 视图之间的竖直间距 */
#define Radio_Button_Tag_Offset 1000

@interface WithdrawalCashViewController ()

/** 页面滚动器 */
@property(strong, nonatomic) WithdrawScrollView *clientScrollView;
/** 顶部右侧“提现明细”按钮 */
@property(strong, nonatomic) UIButton *withdrawDetailBtn;
/** 已添加的银行卡数组 */
@property(copy, nonatomic) NSMutableArray *bankCardArrayM;
/** 被选中的银行卡视图在已添加的银行卡视图数组中的编号 */
@property(assign, nonatomic) int selectedCardNum;
/** 没有绑定银行卡时添加银行卡的视图 */
@property(strong, nonatomic) AddBankCardBigView *addCardBigView;
/** 已有绑定银行卡时添加银行卡的视图 */
@property(strong, nonatomic) AddBankCardSmallView *addCardSmallView;
/** 提现相关信息视图 */
@property(strong, nonatomic) WithdrawInfoView *withdrawInfoView;
/** 用户是否已经添加过银行卡 */
@property(assign, nonatomic) BOOL hasBankCard;

@end

@implementation WithdrawalCashViewController

- (void)viewDidAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillChange:)
             name:UIKeyboardWillChangeFrameNotification
           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardWillChangeFrameNotification
              object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.topToolBar resetContentAndFlage:@"提现" Mode:TTBM_Mode_Sideslip];
  //  self.indicatorView.hidden = YES;

  self.clientView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [self setupSubviews];
  [self Obtain_bankCard];
}
#pragma mark - 刷新按钮代理方法
- (void)refreshButtonPressDown {
  //停止菊花转动
  [self.indicatorView startAnimating];
  [self Obtain_bankCard];
  [self.withdrawInfoView UsersAssetsInquiry];
}

/** 设置子控件 */
- (void)setupSubviews {
  [self setupWithdrawDetailButton];
  [self setupClientScrollView];

  [self.clientScrollView addSubview:self.withdrawInfoView];

  if (self.hasBankCard) {
    /** 遍历并设置所有已添加的银行卡视图的Frame */
    [self.bankCardArrayM
        enumerateObjectsUsingBlock:^(BankCardView *bank_card_view,
                                     NSUInteger idx, BOOL *stop) {
          [self.clientScrollView addSubview:bank_card_view];
          [self setupView:bank_card_view
                   andTop:(idx == 0 ? 0 : ((BankCardView *)self
                                              .bankCardArrayM[idx - 1])).bottom];
          bank_card_view.selectedBtn.tag = idx + Radio_Button_Tag_Offset;
          [bank_card_view.selectedBtn addTarget:self
                                         action:@selector(clickBankCardBtn:)
                               forControlEvents:UIControlEventTouchUpInside];
        }];
    [self.clientScrollView addSubview:self.addCardSmallView];
    [self.addCardSmallView.addCardButton
               addTarget:self
                  action:@selector(clickAddBankCardBtn:)
        forControlEvents:UIControlEventTouchUpInside];
    /** 设置添加过银行卡时，添加银行卡视图的Frame */
    [self setupView:self.addCardSmallView
             andTop:((BankCardView *)[self.bankCardArrayM lastObject]).bottom];
    /** 设置提现相关信息视图的Frame */
    [self setupView:self.withdrawInfoView
             andTop:(self.addCardSmallView.bottom + Subview_Y_Margin)];

  } else {
    [self.clientScrollView addSubview:self.addCardBigView];
    [self.addCardBigView.addCardBtn addTarget:self
                                       action:@selector(clickAddBankCardBtn:)
                             forControlEvents:UIControlEventTouchUpInside];
    /** 设置没有添加过银行卡时，添加银行卡视图的Frame */
    [self setupView:self.addCardBigView andTop:0.0];
    /** 设置提现相关信息视图的Frame */
    [self setupView:self.withdrawInfoView
             andTop:(self.addCardBigView.bottom + Subview_Y_Margin)];
  }

  self.clientScrollView.contentSize =
      CGSizeMake(WIDTH_OF_SCREEN, self.withdrawInfoView.bottom + 35);

  [self.withdrawInfoView.determineWithdrawBtn
             addTarget:self
                action:@selector(clickDetermineBtn:)
      forControlEvents:UIControlEventTouchUpInside];
}

/** 设置滚动器 */
- (void)setupClientScrollView {
  [self.clientView addSubview:self.clientScrollView];
  [self setupView:self.clientScrollView andTop:0.0];
  self.clientScrollView.height = self.clientView.height;
  self.clientScrollView.scrollEnabled = YES;
  self.clientScrollView.showsHorizontalScrollIndicator = NO;
  self.clientScrollView.showsVerticalScrollIndicator = NO;
}

/** 设置子控件的位置尺寸 */
- (void)setupView:(UIView *)settedView andTop:(CGFloat)top {
  settedView.width = WIDTH_OF_SCREEN;
  settedView.top = top;
  settedView.left = 0;
}

/** 设置顶部右侧“提现明细”按钮 */
- (void)setupWithdrawDetailButton {
  self.withdrawDetailBtn.frame =
      CGRectMake(self.view.width - 120, _topToolBar.height - 44, 80, 44);
  [self.withdrawDetailBtn setTitle:@"提现明细" forState:UIControlStateNormal];
  self.withdrawDetailBtn.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_16_0];
  [self.withdrawDetailBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                               forState:UIControlStateNormal];
  [self.withdrawDetailBtn
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [self.topToolBar addSubview:self.withdrawDetailBtn];
  [self.withdrawDetailBtn addTarget:self
                             action:@selector(clickDetailBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark--- 点击按钮响应函数 ---
/** 选择银行卡按钮响应函数 */
- (void)clickBankCardBtn:(RadioButton *)clickedBtn {
  RadioButton *temp_btn =
      ((BankCardView *)self.bankCardArrayM[self.selectedCardNum]).selectedBtn;
  //  if (clickedBtn == temp_btn) {
  //    return;
  //  }
  self.selectedCardNum = (int)clickedBtn.tag - Radio_Button_Tag_Offset;
  temp_btn.radioBtnSelected = NO;
  clickedBtn.radioBtnSelected = YES;
}

/** 点击确认按钮响应函数 */
- (void)clickDetermineBtn:(UIButton *)clickedBtn {
  NSLog(@"DDDADAFD");
  NSString * amount = self.withdrawInfoView.inputMoney.inputTextField.text;
  if ([amount doubleValue]>0)
  {
    if ([amount doubleValue]>[self.withdrawInfoView.accountBalanceAccountLable.text doubleValue])
    {
      [NewShowLabel setMessageContent:@"提现金额要小于等于你账户余额"];
      return;
    }
    if ([self.withdrawInfoView.accountBalanceAccountLable.text doubleValue]<100)
    {
      if ([amount doubleValue]-[self.withdrawInfoView.accountBalanceAccountLable.text doubleValue]!=0)
      {
        [NewShowLabel setMessageContent:@"账户余额小于100时需全部提取"];
        amount= self.withdrawInfoView.accountBalanceAccountLable.text;
        return;
      }
    }
  
    [self WithdrawNetworkInterface:amount];
  }
  else
  {
    [NewShowLabel setMessageContent:@"请输入提现金额"];
  }
}
///提现网络接口
- (void)WithdrawNetworkInterface:(NSString *)amount {
  if (!amount) {
    return;
  }
  amount = [NSString stringWithFormat:@"%d",(int)[amount doubleValue] * 100];
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel  showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WithdrawalCashViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    WithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.withdrawInfoView UsersAssetsInquiry];
      [NewShowLabel setMessageContent:@"提现申请成功，可进兑现明细查询"];
    }
  };
  BankCardView *bankCardview =
      [self.bankCardArrayM objectAtIndex:_selectedCardNum];

  [WFAccountInterface applyForWFWithdrawWithAmount:amount
                                 WithaccountBankId:bankCardview.bankCardId
                                       andCallback:callback];
}

/** 点击提现明细按钮响应函数 */
- (void)clickDetailBtn:(UIButton *)clickedBtn {
  WithdrawDetailViewController *withdrawDetailVC =
      [[WithdrawDetailViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:withdrawDetailVC];
}

/** 点击添加银行卡按钮响应函数 */
- (void)clickAddBankCardBtn:(UIButton *)clickedBtn {
  UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow]
      performSelector:@selector(firstResponder)];
  /// 判断是否收回键盘结束金额的输入
  if (firstResponder == self.withdrawInfoView.inputMoney.inputTextField) {
    [firstResponder resignFirstResponder];
    return;
  }
  ///身份验证
  [self getUserisRNA];
}

///身份验证
-(void)getUserisRNA
{
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc]init];
  callBack.onSuccess = ^(NSObject *obj) {
    WFBindBankCardViewController *bindBankCard =
    [[WFBindBankCardViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:bindBankCard];
  };
  callBack.onError=^(BaseRequestObject *err, NSException *ex){
    if ([err.status isEqualToString:@"0013"]) {
      RealNameAuthenticationViewController * realName = [[RealNameAuthenticationViewController alloc] initWithRealUserCertBlock:^(BOOL success) {
        if (success)
        {
          WFBindBankCardViewController *bindBankCard =
          [[WFBindBankCardViewController alloc] init];
          [AppDelegate pushViewControllerFromRight:bindBankCard];
        }
      }];
      [AppDelegate pushViewControllerFromRight:realName];
      
    }else{ [BaseRequester defaultErrorHandler](err, ex); }
  };
  
  [WFinquireIsAuthRNA authUserIdentityWithCallback:callBack];
}

#pragma mark--- 键盘监听相关响应函数 ---

/** 键盘出现时的响应函数 */
- (void)keyboardWillChange:(NSNotification *)notification {
  CGRect keyboardRect = [[notification.userInfo
      objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGPoint temp_point = [self.withdrawInfoView.withdrawView
      convertPoint:self.withdrawInfoView.inputMoney.origin
            toView:[UIApplication sharedApplication].keyWindow];
  CGFloat height = keyboardRect.origin.y - temp_point.y -
                   self.withdrawInfoView.inputMoney.height;
  if (keyboardRect.origin.y != HEIGHT_OF_SCREEN && height < 0.0) {
    /// 键盘将要出现且会遮盖输入框时的处理
    [UIView
        animateWithDuration:
            [[notification.userInfo
                objectForKey:
                    UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                 animations:^{
                   [self.clientScrollView
                       setContentOffset:CGPointMake(0, (self.clientScrollView
                                                            .contentOffset.y -
                                                        height))
                               animated:YES];
                 }];
  } else if (keyboardRect.origin.y == HEIGHT_OF_SCREEN) {
    /// 键盘将要消失时的处理
    CGFloat tempHeight =
        self.clientScrollView.contentSize.height - self.clientScrollView.height;
    if (tempHeight < 0) {
      return;
    }
    /// 键盘将要消失时且键盘出现时发生过滚动的处理
    [self.clientScrollView setContentOffset:CGPointMake(0, tempHeight)
                                   animated:YES];
  }
}

#pragma mark--- 懒加载 ---
/** 懒加载页面滚动器 */
- (WithdrawScrollView *)clientScrollView {
  if (_clientScrollView == nil) {
    _clientScrollView = [[WithdrawScrollView alloc] init];
  }
  return _clientScrollView;
}

/** 懒加载没有绑定银行卡时添加银行卡的视图（通过AddBankCardBigView.xib创建） */
- (AddBankCardBigView *)addCardBigView {
  if (_addCardBigView == nil) {
    _addCardBigView = [[[NSBundle mainBundle] loadNibNamed:@"AddBankCardBigView"
                                                     owner:nil
                                                   options:nil] lastObject];
  }
  return _addCardBigView;
}

/** 懒加载已添加的银行卡数组 */
- (NSMutableArray *)bankCardArrayM {
  if (_bankCardArrayM == nil) {
    _bankCardArrayM = [NSMutableArray array];
  }
  return _bankCardArrayM;
}

/** 懒加载已有绑定银行卡时添加银行卡的视图（通过AddBankCardSmallView.xib创建）
 */
- (AddBankCardSmallView *)addCardSmallView {
  if (_addCardSmallView == nil) {
    _addCardSmallView =
        [[[NSBundle mainBundle] loadNibNamed:@"AddBankCardSmallView"
                                       owner:nil
                                     options:nil] lastObject];
  }
  return _addCardSmallView;
}

/** 懒加载提现相关信息视图（通过WithdrawInfoView.xib创建） */
- (WithdrawInfoView *)withdrawInfoView {
  if (_withdrawInfoView == nil) {
    _withdrawInfoView = [[[NSBundle mainBundle] loadNibNamed:@"WithdrawInfoView"
                                                       owner:nil
                                                     options:nil] lastObject];
  }
  return _withdrawInfoView;
}

/** 懒加载顶部右侧“提现明细”按钮 */
- (UIButton *)withdrawDetailBtn {
  if (_withdrawDetailBtn == nil) {
    _withdrawDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _withdrawDetailBtn;
}

#pragma mark--- get方法 ---
/** 重写属性hasBankCard的get方法，获取用户是否已经添加过银行卡 */
- (BOOL)hasBankCard {
  return self.bankCardArrayM.count == 0 ? NO : YES;
}

#pragma mark--- 获取用户绑定的银行卡 ---
///获取用户绑定的银行卡
- (void)Obtain_bankCard {
  if (![SimuUtil isExistNetwork]) {
    //停止菊花转动
    [self.indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WithdrawalCashViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    //停止菊花转动
    [self.indicatorView stopAnimating];
    WithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFBindedBankcardResult *wfResult = (WFBindedBankcardResult *)obj;
      if (wfResult.bank_card_list.count > 0) {
        [self.bankCardArrayM removeAllObjects];
        for (WFBindedBankcardInfo *info in wfResult.bank_card_list) {
          BankCardView *bankCardview =
              [[[NSBundle mainBundle] loadNibNamed:@"BankCardView"
                                             owner:nil
                                           options:nil] lastObject];
          [bankCardview getDataToBandCard:info];
          [self.bankCardArrayM addObject:bankCardview];
        }
      }
      if (self.bankCardArrayM.count > 0) {
        RadioButton *temp_btn =
            ((BankCardView *)self.bankCardArrayM[self.selectedCardNum])
                .selectedBtn;
        temp_btn.radioBtnSelected = YES;
      }
      [self setupSubviews];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    //停止菊花转动
    [self.indicatorView stopAnimating];
    WithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler];
    }
  };
  callback.onFailed = ^{
    //停止菊花转动
    [self.indicatorView stopAnimating];
    WithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
    }
  };
  [WFAccountInterface inquireWFBindedBankcardWithChannel:@"1"
                                           WithCallback:callback];
}

@end
