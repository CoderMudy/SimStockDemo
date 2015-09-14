//
//  MyFeedBackViewController.m
//  Settings
//
//  Created by jhss on 13-9-10.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import "SimuUtil.h"

#import "NetLoadingWaitView.h"
#import "CommonFunc.h"
#import "JsonFormatRequester.h"

#define IS_IOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

@implementation PaddingUITextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10, 10);
}

@end

@implementation MyFeedBackViewController {
  UIAlertView *alertView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
  [self resetUI];
}

- (void)createMainView {
  //回拉效果
  mpvc_adjust = NO;
  viewRect = self.view.frame;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar resetContentAndFlage:@"我要反馈" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  //文字输入背景
  UIImage *textViewBackImage = [UIImage imageNamed:@"输入框"];
  textViewBackImage = [textViewBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  // textView
  tvFeedback =
      [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 12, viewRect.size.width - 24, 88)];
  tvFeedback.textAlignment = NSTextAlignmentLeft;
  tvFeedback.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
  tvFeedback.font = [UIFont systemFontOfSize:14];
  tvFeedback.delegate = self;
  tvFeedback.tag = 101;
  tvFeedback.backgroundColor = [UIColor clearColor];
  tvFeedback.placeholder = @"您的意见将帮助我们不断改进";
  tvFeedback.placeholderColor = [Globle colorFromHexRGB:@"939393"];
  // textView背景
  UIImageView *imageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, viewRect.size.width - 24, 88)];
  imageView.image = textViewBackImage;
  [self.clientView addSubview:imageView];
  [self.clientView addSubview:tvFeedback];

  //字数统计label
  lblWordCountDown =
      [[UILabel alloc] initWithFrame:CGRectMake(viewRect.size.width - 24 - 5 - 20, 88 - 5 - 10, 20, 10)];
  CALayer *layer = lblWordCountDown.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:2];
  lblWordCountDown.backgroundColor = [UIColor lightGrayColor];
  lblWordCountDown.alpha = 0.7;
  lblWordCountDown.tag = 103;
  lblWordCountDown.font = [UIFont systemFontOfSize:8];
  lblWordCountDown.textColor = [UIColor blackColor];
  lblWordCountDown.textAlignment = NSTextAlignmentCenter;
  [imageView addSubview:lblWordCountDown];
  // phone、email、qq及其背景
  UIImageView *contantWaysImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(12, 109, viewRect.size.width - 24, 33)];
  contantWaysImageView.image = textViewBackImage;
  [self.clientView addSubview:contantWaysImageView];

  tfContactWay =
      [[PaddingUITextField alloc] initWithFrame:CGRectMake(12, 100 + 9, viewRect.size.width - 24, 33)];
  tfContactWay.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
  tfContactWay.font = [UIFont systemFontOfSize:14];
  tfContactWay.delegate = self;
  tfContactWay.tag = 102;
  tfContactWay.placeholder = @"选填请输入你的手机、邮箱或QQ号";
  tfContactWay.keyboardType = UIKeyboardTypeNumberPad;
  tfContactWay.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:tfContactWay];

  //提交
  UIButton *sumitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  sumitButton.frame = CGRectMake(12, 142 + 9, viewRect.size.width - 24, 38);
  [sumitButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [sumitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [sumitButton setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [sumitButton setTitle:@"提交" forState:UIControlStateNormal];
  [self.clientView addSubview:sumitButton];

  __weak MyFeedBackViewController *weakSelf = self;
  [sumitButton setOnButtonPressedHandler:^{
    [weakSelf sumitFeedBackInformation];
  }];

  //对于3.5寸机型做适配
  if (viewRect.size.height <= 460) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
  }
}

#pragma mark
#pragma mark-----辅助协议函数-------
static NSInteger MAX_FEEDBACK_NUM = 140;
static NSInteger MAX_CONTACT_NUM = 11;

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  //过滤换行
  if ([text isEqualToString:@"\n"]) {
    return YES;
  }
  if (textView.tag == 101) {
    long remainderTextNumeber = MAX_FEEDBACK_NUM - [textView.text length];
    lblWordCountDown.text = [NSString stringWithFormat:@"%ld", (long)remainderTextNumeber];
    return YES;
  } else {
    if (range.location >= MAX_CONTACT_NUM) {
      NSString *toBeString = [textView.text substringToIndex:MAX_CONTACT_NUM];
      textView.text = toBeString;
      return NO;
    } else {
      return YES;
    }
  }
}
- (void)textViewDidChange:(UITextView *)textView {
  if (textView.tag == 101) {
    long remainderTextNumeber = MAX_FEEDBACK_NUM - textView.text.length;
    if ([textView.text length] > MAX_FEEDBACK_NUM) {
      //超过140
      lblWordCountDown.textColor = [UIColor redColor];
    } else {
      lblWordCountDown.textColor = [UIColor blackColor];
    }
    lblWordCountDown.text = [NSString stringWithFormat:@"%ld", (long)remainderTextNumeber];
  } else {
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:NO];
}
#pragma mark
#pragma mark KeyboardObserver
- (void)keyboardWillShow:(NSNotification *)notification {
  CGRect keyboardRect;
  __weak MyFeedBackViewController *weakSelf = self;
  [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
  if (keyboardRect.size.height > 240) {
    if (!mpvc_adjust) {
      mpvc_adjust = YES;
      double animationDuaration;
      UIViewAnimationOptions animationOption;
      NSLog(@"%@", notification.userInfo);
      [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuaration];
      [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationOption];
      [UIView animateWithDuration:animationDuaration
          delay:0.0f
          options:animationOption
          animations:^{
            weakSelf.view.frame = CGRectMake(0, -45, viewRect.size.width, viewRect.size.height);
          }
          completion:^(BOOL finished){
          }];
    }
  } else {
    if (mpvc_adjust) {
      mpvc_adjust = NO;
      double animationDuaration;
      UIViewAnimationOptions animationOption;
      NSLog(@"%@", notification.userInfo);
      [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuaration];
      [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationOption];
      [UIView animateWithDuration:animationDuaration
          delay:0.0f
          options:animationOption
          animations:^{
            weakSelf.view.frame = CGRectMake(0, 0, viewRect.size.width, viewRect.size.height);
          }
          completion:^(BOOL finished){
          }];
    }
  }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  double animationDuaration;
  __weak MyFeedBackViewController *weakSelf = self;
  UIViewAnimationOptions animationOption;
  [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuaration];
  [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationOption];
  [UIView animateWithDuration:animationDuaration
      delay:0.0f
      options:animationOption
      animations:^{
        weakSelf.view.frame = CGRectMake(0, 0, viewRect.size.width, viewRect.size.height);
      }
      completion:^(BOOL finished){
      }];
}

- (void)dealloc {
  //针对home键引起的问题
  alertView.delegate = nil;
  if (viewRect.size.height <= 460) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
  }
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 提交button点击函数
- (void)sumitFeedBackInformation {
  [self.view endEditing:NO];

  //去除空格和回车
  NSString *text =
      [tvFeedback.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([text length] < 1) {
    [NewShowLabel setMessageContent:@"反馈内容为空"];
    return;
  } else if ([text length] > MAX_FEEDBACK_NUM) {
    [NewShowLabel setMessageContent:@"反馈内容超过限定字数"];
    return;
  }
  //判断有无网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  [NetLoadingWaitView startAnimating];

  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/dofeedback/%@/%@/%@/%@/%@", user_address, [SimuUtil getAK],
                                 [SimuUtil getSesionID], [SimuUtil getUserID], @"0", @"***"];
  NSLog(@"url = %@", url);

  NSDictionary *dict = @{
    @"feedtext" : [CommonFunc base64StringFromText:text],
    @"contact" : [CommonFunc base64StringFromText:tfContactWay.text],
    @"am" : @"",
    @"ua" : @"",
    @"username" : [SimuUtil getUserName]
  };

  __weak MyFeedBackViewController *weakSelf = self;
  HttpRequestCallBack *callback = [HttpRequestCallBack initWithOwner:self
                                                       cleanCallback:^{
                                                         [NetLoadingWaitView stopAnimating];
                                                       }];

  callback.onSuccess = ^(NSObject *obj) {
    [NetLoadingWaitView stopAnimating];
    [weakSelf didSubmit];
  };

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"POST"
                 withRequestParameters:dict
                withRequestObjectClass:[JsonRequestObject class]
               withHttpRequestCallBack:callback];
}

- (void)didSubmit {
  if (IS_IOS8) {
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:
            @"提示" message:
                          @"提交成功，非常感谢您的宝贵意见，是否继续反馈？"
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                           [self updateData];
                                                           [self leftButtonPress];
                                                         }];

    [alertController addAction:cancelAction];

    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                        [self updateData];
                                                        [self resetUI];
                                                      }];

    [alertController addAction:yesAction];

    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    //提示框
    alertView = [[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:@"提交成功，非常感谢您的宝贵意见，是否继续反馈？"
                 delegate:self
        cancelButtonTitle:@"否"
        otherButtonTitles:@"是", nil];
    [alertView show];
  }
}

- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self updateData];
  if (buttonIndex == 0) {
    [self leftButtonPress];
  } else {
    [self resetUI];
  }
}

- (void)resetUI {
  lblWordCountDown.text = @"140";
  tvFeedback.text = @"";
  tfContactWay.text = @"";
}

- (void)updateData {
  //获取解析内容
  UITextView *feedbackTextView = (UITextView *)[self.view viewWithTag:101];
  NSMutableArray *newDataArray = [[NSMutableArray alloc] init];
  //第二次加入的时候存在重复的情况
  //头像得先转化为base64编码
  for (int i = 0; i < [_dataArray.array count]; i++) {
    if (i == 1) {
      [newDataArray addObject:[NSString stringWithFormat:@"#%@#%@", [SimuUtil getUserImageURL], feedbackTextView.text]];
      [newDataArray addObject:_dataArray.array[1]];
    } else {
      [newDataArray addObject:_dataArray.array[i]];
    }
  }
  //数组大小为1的时候，单独判断
  if ([_dataArray.array count] == 1) {
    [newDataArray addObject:[NSString stringWithFormat:@"#%@#%@", [SimuUtil getUserImageURL], feedbackTextView.text]];
  }
  NSLog(@"_dataArray2 = %@", _dataArray);
  [_dataArray.array removeAllObjects];
  //再添加回来
  for (NSString *subStr in newDataArray) {
    [_dataArray.array addObject:subStr];
  }

  //初始加载内容（20项)
  //<20
  [_visibleArray removeAllObjects];
  if ([_dataArray.array count] < 20) {
    for (int i = 0; i < [newDataArray count]; i++) {
      [_visibleArray addObject:_dataArray.array[i]];
    }
  } else {
    for (int i = 0; i < 20; i++) {
      [_visibleArray addObject:_dataArray.array[i]];
    }
  }
  [_feedbackTableView reloadData];
}

- (void)leftButtonPress {
  [self.view endEditing:NO];
  tvFeedback.delegate = nil;
  tfContactWay.delegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super leftButtonPress];
}
@end
