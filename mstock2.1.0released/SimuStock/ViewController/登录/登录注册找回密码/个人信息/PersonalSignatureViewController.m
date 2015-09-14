//
//  PersonalSignatureViewController.m
//  SimuStock
//
//  Created by moulin wang on 13-12-2.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "PersonalSignatureViewController.h"
#import "JsonFormatRequester.h"
#import "ChangeUserInfoRequest.h"
#import "NetLoadingWaitView.h"
#import "DoTaskStatic.h"
#import "TaskIdUtil.h"

#define WORD_MAXNUM 30

@implementation PersonalSignatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithSignature:(NSString *)signature {
  if (self = [super init]) {
    self.sigNatureStr = signature;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"个性签名" Mode:TTBM_Mode_Leveltwo];

  [self createViews];

  _sigNatureText.text = self.sigNatureStr;
}

- (void)createViews {
  UIImage *textViewBackImage = [UIImage imageNamed:@"输入框"];
  textViewBackImage = [textViewBackImage
      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  UIImageView *imageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(16, 10, self.view.bounds.size.width - 30, 102)];
  imageView.image = textViewBackImage;
  [self.clientView addSubview:imageView];
  //保存按钮
  UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
  saveButton.frame = CGRectMake(self.view.frame.size.width - 60,
                                _topToolBar.frame.size.height - 44, 60, 44);
  [saveButton setTitle:@"保存" forState:UIControlStateNormal];
  saveButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [saveButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                   forState:UIControlStateNormal];
  [saveButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                        forState:UIControlStateHighlighted];
  [saveButton addTarget:self
                 action:@selector(saveSignature)
       forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:saveButton];
  //签名编辑框
  _sigNatureText = [[UITextView alloc]
      initWithFrame:CGRectMake(21, 10, self.view.bounds.size.width - 36, 97)];
  _sigNatureText.textColor = [Globle colorFromHexRGB:@"454545"];
  _sigNatureText.font = [UIFont systemFontOfSize:Font_Height_16_0];
  _sigNatureText.backgroundColor = [UIColor clearColor];
  _sigNatureText.delegate = self;
  [self.clientView addSubview:_sigNatureText];

  _wordCountLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(imageView.bounds.size.width - 20,
                               imageView.bounds.size.height - 15, 16, 12)];
  CALayer *layer = _wordCountLabel.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:3];
  _wordCountLabel.backgroundColor = [UIColor lightGrayColor];
  _wordCountLabel.alpha = 0.7;
  _wordCountLabel.textColor = [UIColor blackColor];
  _wordCountLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  NSInteger remainNumber = WORD_MAXNUM - [_sigNatureStr length];
  if (remainNumber < 0) {
    remainNumber = 0;
  }
  _wordCountLabel.text =
      [NSString stringWithFormat:@"%ld", (long)remainNumber]; //@"30";
  _wordCountLabel.textAlignment = NSTextAlignmentCenter;
  [imageView addSubview:_wordCountLabel];
}

- (void)showSimuMessageContent:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)saveSignature {
  [_sigNatureText resignFirstResponder];
  if ([_sigNatureText.text length] > 30) {
    [self showSimuMessageContent:@"签名长度超过限制"];
    return;
  }
  NSString *newSignature =
      [_sigNatureText.text stringByReplacingOccurrencesOfString:@"\n"
                                                     withString:@" "];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  __weak PersonalSignatureViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    PersonalSignatureViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf onChangeSuccess:newSignature];
    }
  };

  //加入阻塞
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  [ChangeUserInfoRequest changeNickname:nil
                       withNewSignature:newSignature
                             withSyspic:nil
                            withPicFile:nil
                withHttpRequestCallBack:callback];
}

- (void)onChangeSuccess:(NSString *)newSignature {

  [NewShowLabel setMessageContent:@"签名修改成功"];
  if ([[SimuUtil getPersonalInfo] isEqualToString:@""]) {
    [SimuUtil setPersonalInfo:TASK_PERSONAL_INFO];
    [DoTaskStatic doTaskWithTaskType:TASK_PERSONAL_INFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalInfo"
                                                        object:nil];
  } else {
    NSLog(@"完善个人资料任务已完成！！！");
  }

  [SimuUtil setUserSignature:newSignature];
  [[NSNotificationCenter defaultCenter] postNotificationName:NT_Signature_Change
                                                      object:nil];
  [self leftButtonPress];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
  remainderTextNumeber = WORD_MAXNUM - textView.text.length;
  _wordCountLabel.text =
      [NSString stringWithFormat:@"%ld", (long)remainderTextNumeber];
  if ([textView.text length] > 30) {
    //超过140
    _wordCountLabel.textColor = [UIColor redColor];
  } else {
    _wordCountLabel.textColor = [UIColor blackColor];
  }
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"])
    return YES;
  //（zxc修改140改30）
  // remainderTextNumeber = 140 - [textView.text length];
  remainderTextNumeber = 30 - [textView.text length];
  _wordCountLabel.text =
      [NSString stringWithFormat:@"%ld", (long)remainderTextNumeber];
  return YES;
}
- (void)leftButtonPress {
  [_sigNatureText resignFirstResponder];
  [super leftButtonPress];
}
@end
