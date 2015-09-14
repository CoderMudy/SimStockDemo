//
//  GameWebViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-6-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GameWebViewController.h"
#import "MakingShareAction.h"



@implementation GameWebViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  [self createShareControl];
}
#pragma mark
#pragma mark-------分享---------
// lq分享控件
- (void)createShareControl {
  CGRect frame = self.view.frame;
  UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  shareButton.frame = CGRectMake(frame.size.width - 40,
                                 _topToolBar.bounds.size.height - 45, 40, 45);
  UIImage *shareImage = [UIImage imageNamed:@"分享.png"];
  [shareButton setImage:shareImage forState:UIControlStateNormal];
  [shareButton setImage:shareImage forState:UIControlStateHighlighted];
  //按钮选中中视图
  UIImage *mtvc_centerImage = [[UIImage imageNamed:@"return_touch_down"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [shareButton setBackgroundImage:mtvc_centerImage
                         forState:UIControlStateHighlighted];
  [shareButton addTarget:self
                  action:@selector(shareUserInfo:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:shareButton];
  if (self.indicatorView) {
    CGFloat allWidth =_topToolBar.frame.size.width;
    self.indicatorView.left = allWidth - 80;
    self.topToolBar.sbv_nameLable.width = allWidth - self.topToolBar.sbv_nameLable.left - 84;
  }
}

- (void)logonSuccessShareUserInfo {
  //已登录
  NSString *selfUserID = [SimuUtil getUserID];

  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  switch (_urlType) {
    case AdvUrlModuleTypeMatchApply:
      shareAction.shareModuleType = ShareModuleTypeStockMatch;
      break;
    case AdvUrlMOduleTypeTradeEvaluating:
      shareAction.shareModuleType = ShareModuleTypeUserEvaluating;
      break;
    case AdvUrlModuleTypeMasterApply:
      shareAction.shareModuleType = ShareModuleTypeUserEvaluating;
      break;
    case AdvUrlModuleTypeSystemInfo:
      shareAction.shareModuleType = ShareModuleTypeStaticWap;
      break;
    case AdvUrlModuleTypeAccount:
      shareAction.shareModuleType = ShareModuleTypeStaticWap;
      break;
    case AdvUrlModuleTypeMatchAdv:
      shareAction.shareModuleType = ShareModuleTypeStockMatch;
      break;
    default:
      return;
  }
  shareAction.shareUserID = selfUserID;
  [shareAction
          shareTitle:self.textName
             content:[NSString
                         stringWithFormat:
                             @"#优顾炒股#【%@】%@ (分享自@优顾炒股官方)",
                             self.textName, self.textUrl]
               image:nil
      withOtherImage:nil
        withShareUrl:self.textUrl
       withOtherInfo:[NSString stringWithFormat:@"#优顾炒股#【%@】%@",
                                                self.textName, self.textUrl]];
}

- (void)shareUserInfo:(id)sender {
  [self logonSuccessShareUserInfo];
}

+(void)showUserGradeReportWithUserId:(NSString*) userid{
  //优顾交易评级报告
  NSString *textUrl = [wap_address
                       stringByAppendingFormat:@"/mobile/wap_analysis/html/"
                       @"anaysis.html?userid=%@&"
                       @"matchid=%@",
                       userid, @"1"];
  GameWebViewController *webView =
  [[GameWebViewController alloc] initWithNameTitle:@"优顾交易评级报告" andPath:textUrl];
  webView.urlType = AdvUrlMOduleTypeTradeEvaluating;
  //切换
  [AppDelegate pushViewControllerFromRight:webView];
}

@end
