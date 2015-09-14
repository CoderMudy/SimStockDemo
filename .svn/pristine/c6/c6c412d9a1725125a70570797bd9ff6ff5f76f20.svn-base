//
//  AboutWeIntroductionView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AboutWeIntroductionView.h"
#import "TopDividingLineView.h"
#import "Globle.h"
#import "MobClick.h"
#import "SchollWebViewController.h"

NSString *const USER_AGREEMENT = @"优顾用户服务协议";

@interface AboutWeIntroductionView ()
@property(weak, nonatomic) IBOutlet TopDividingLineView *dividingLine;

@end

@implementation AboutWeIntroductionView

/** 对外初始化 */
+ (AboutWeIntroductionView *)showAboutWeIntroductionView {
  return [[[NSBundle mainBundle] loadNibNamed:@"AboutWeIntroductionView"
                                        owner:self
                                      options:nil] lastObject];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  //添加线
  /**
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:Font_Height_11_0]};
    size = [self.phoneNumberLabel.text
               boundingRectWithSize:CGSizeMake(self.phoneNumberLabel.size.width,
  self.phoneNumberLabel.size.height)
                            options:(NSStringDrawingUsesLineFragmentOrigin |
  NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)
                         attributes:attribute
                            context:nil]
               .size;

    _lineLabelNumber = [[UIView alloc] initWithFrame:CGRectZero];
    _lineLabelNumber.backgroundColor = [Globle colorFromHexRGB:@"ca332a"];
    [self addSubview:_lineLabelNumber];
    [self sendSubviewToBack:_lineLabelNumber];
  **/
  NSMutableAttributedString *content =
      [[NSMutableAttributedString alloc] initWithString:self.phoneNumberLabel.text];
  NSRange contentRange = {0, [content length]};
  [content addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                  range:contentRange];
  self.phoneNumberLabel.attributedText = content;
  [self bringSubviewToFront:self.phoneNumberLabel];

  //版本号
  NSString *version =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  self.versionNumberLabel.text = [NSString stringWithFormat:@"软件版本:%@", version];
  // web
  self.aboutWeWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  self.aboutWeWebView.dataDetectorTypes = UIDataDetectorTypeNone;
  self.aboutWeWebView.backgroundColor = [UIColor clearColor];
  self.aboutWeWebView.opaque = NO;
  self.aboutWeWebView.scrollView.bounces = NO;
  [self loadHtmlString];

  //用户协议
  self.attributedLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  self.attributedLabel.textAlignment = NSTextAlignmentCenter;
  self.attributedLabel.delegate = self;
  self.attributedLabel.userInteractionEnabled = YES;
  self.attributedLabel.numberOfLines = 0;
  self.attributedLabel.backgroundColor = [UIColor clearColor];
  self.attributedLabel.text = USER_AGREEMENT;
  NSRange r = [USER_AGREEMENT rangeOfString:USER_AGREEMENT];
  [self.attributedLabel addLinkToURL:[NSURL URLWithString:@"action://show-user-agreement"]
                           withRange:r];

  UITapGestureRecognizer *gesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink)];
  [self.attributedLabel addGestureRecognizer:gesture];

  [MobClick beginLogPageView:@"设置-关于我们"];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  [self userTappedOnLink];
}

- (void)userTappedOnLink {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"];

  [SchollWebViewController startWithTitle:USER_AGREEMENT
                                  withUrl:[[NSURL fileURLWithPath:path] absoluteString]];
}

- (void)loadHtmlString {
  // clang-format off
  NSString *textStr = [NSString
      stringWithFormat:
          @"<div " @"style=\"margin:0;background-color:transparent;color:#"
          @"2F2E2E;word-wrap:break-word;word-break:break-all;"
          @"text-decoration:none;letter-spacing:-1px;font:13px/"
          @"20px system\">%@</div>",
          @"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          @"&nbsp;&nbsp;&nbsp;“ 优顾炒股 " @"”"
          @"是国内第一款集A股高仿真交易、"
          @"投资者行为数据挖掘、股" @"市" @"闯" @"关" @"、"
          @"股市对战游戏为一身的理财投资类手机应用。是您"
          @"学习炒股、提高技能、与股友切磋对战的神器。"];

  [self.aboutWeWebView loadHTMLString:textStr baseURL:nil];
  // clang-format on
}
/** 打电话 */
- (IBAction)phoneButtonDown:(UIButton *)sender {
  //操作表
  NSString *number = @"01053599702"; // 此处读入电话号码
  NSURL *backURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}

@end
