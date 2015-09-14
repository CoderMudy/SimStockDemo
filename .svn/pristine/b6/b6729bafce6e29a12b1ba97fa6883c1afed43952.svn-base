//
//  WFLianLianGetAuthCodeViewController.m
//  SimuStock
//
//  Created by Jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//


@interface WFLianLianGetAuthCodeViewController ()

@end

@implementation WFLianLianGetAuthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //设置页面中的控件
  [self setUpViewControls];
  
  
  
    // Do any additional setup after loading the view from its nib.
}

///设置View上的控件
-(void)setUpViewControls
{
  //显示顶部“支付”
  [_topToolBar resetContentAndFlage:@"支付" Mode:TTBM_Mode_Leveltwo];
  _clientView.alpha = 0;
  //短信输入框
  self.smsTextField.delegate = self;
  
  //设置按钮“下一步”的高亮状态
  [self.confirmButton buttonWithNormal:Color_WFOrange_btn andHightlightedColor:Color_WFOrange_btnDown];
  [self.confirmButton buttonWithTitle:@"确认" andNormaltextcolor:Color_White andHightlightedTextColor:Color_White];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
  [textField.text stringByReplacingCharactersInRange:range
                                          withString:string];
  if (textField == self.smsTextField) {
    if ([toBeString length] > 5) {
      textField.text = [toBeString substringToIndex:6];
      return NO;
  }
  }
  return YES;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/** 点击“获得验证码”按钮触发的方法 */
- (IBAction)sendSmsGetAuthCodePress:(id)sender
{


}
/** ”确认“ 按钮的触发方法 */
- (IBAction)clickConfirmButtonPress:(id)sender {
  
  
}




@end
