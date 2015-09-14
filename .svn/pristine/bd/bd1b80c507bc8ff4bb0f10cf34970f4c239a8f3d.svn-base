//
//  UniversityInformationViewController.m
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UniversityInformationViewController.h"
#import "BaseRequester.h"
#import "MatchCreateViewController.h"
#import "SimuMatchUsesData.h"
#import "SelectMatchTypeTipView.h"
#import "ExplanationTipView.h"
#import "MatchSelectUniversityViewController.h"
#import "BottomDividingLineView.h"
#import "SelectMatchPurposeSingle.h"
#import "SelectMatchInitialFundSingle.h"

@implementation UniversityInformationViewController

- (void)dealloc {
  [SelectMatchPurposeSingle shared].selectMatchPurposeBlock = nil;
  [SelectMatchPurposeSingle shared].isDataBinded = NO;
  [SelectMatchPurposeSingle shared].isTipShown = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.matchUniversityInfo = [[MatchCreateUniversityInfo alloc] init];
  self.matchUniversityInfo.isSenior = @"0";
  [self resetSelectMatchUsesBtn];

  __weak UniversityInformationViewController *weakSelf = self;
  [SelectMatchPurposeSingle shared].beginRefreshCallBack = ^{
    if (weakSelf && weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };
  [SelectMatchPurposeSingle shared].endRefreshCallBack = ^{
    if (weakSelf && weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };
}

/**设置选择比赛按钮内容*/
- (void)setBtnTitle:(NSString *)title {
  self.matchUniversityInfo.purpose = title;
  [self.useBtn setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                    forState:UIControlStateNormal];
  [self.useBtn setTitle:title forState:UIControlStateNormal];
}

/**开关关闭高度*/
static const CGFloat switchCloseHeight = 85.f;
/**开关打开高度*/
static const CGFloat switchOnHeight = 168.f;

- (IBAction)UniverMatchChangeSwitch:(UISwitch *)sender {
  NSLog(@"xcfsdfsdfasdfsadf");
  if (sender.on) {
    /// YES
    self.matchUniversityInfo.isSenior = @"1";
    self.univerInfoHeightBlock(@(switchOnHeight), @(switchCloseHeight));
  } else {
    self.matchUniversityInfo.isSenior = @"0";
    self.univerInfoHeightBlock(@(switchCloseHeight), @(switchOnHeight));
  }
}

/**点击说明按钮弹出高校信息提示框*/
- (IBAction)clickExplanationBtn:(UIButton *)sender {
  [self endEdit];
  [ExplanationTipView showExplanationTipView];
}

/**点击选择比赛用户弹出比赛用途提示框*/
- (void)clickToShowMatchUsesTipView {
  [self endEdit];
  [SelectMatchInitialFundSingle shared].selectMatchInitialFundBlock = nil;
  __weak UniversityInformationViewController *weakSelf = self;
  [SelectMatchPurposeSingle shared].selectMatchPurposeBlock = ^(NSString *matchPurpose) {
    UniversityInformationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf setBtnTitle:matchPurpose];
      strongSelf.matchUniversityInfo.purpose = matchPurpose;
    }
  };
  [[SelectMatchPurposeSingle shared] showSelectTip];
}

- (void)resetSelectMatchUsesBtn {
  __weak UniversityInformationViewController *weakSelf = self;
  [self.useBtn setOnButtonPressedHandler:^{
    if (weakSelf) {
      [weakSelf clickToShowMatchUsesTipView];
    }
  }];
}

/** 点击选择学校名字按钮跳*/
- (IBAction)selectUniversityBtnClick:(UIButton *)sender {
  [self endEdit];
  /// 跳转到高校选择页面
  MatchSelectUniversityViewController *searchVC = [[MatchSelectUniversityViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:searchVC];
  /// 回调返回高校名称
  __weak UniversityInformationViewController *weakSelf = self;
  searchVC.onClickUniversityName = ^(NSString *universityName) {
    UniversityInformationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if (!universityName) {
        [strongSelf.universityNameBtn setTitle:@"请选择学校名字" forState:UIControlStateNormal];
        strongSelf.matchUniversityInfo.seniorSchool = @"";
      } else {
        [strongSelf.universityNameBtn setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                                           forState:UIControlStateNormal];
        [strongSelf.universityNameBtn setTitle:universityName forState:UIControlStateNormal];
        strongSelf.matchUniversityInfo.seniorSchool = universityName;
      }
    }
  };
}

/** 高校比赛信息校验函数 */
- (BOOL)checkUnivserInfo {
  if ([self.matchUniversityInfo.isSenior isEqualToString:@"0"]) {
    return YES;
  } else if ([self.matchUniversityInfo.isSenior isEqualToString:@"1"]) {
    if (!self.matchUniversityInfo.seniorSchool || self.matchUniversityInfo.seniorSchool.length == 0) {
      [NewShowLabel setMessageContent:@"请选择高校"];
      return NO;
    } else if (!self.matchUniversityInfo.purpose || self.matchUniversityInfo.purpose.length == 0) {
      [NewShowLabel setMessageContent:@"请选择比赛用途"];
      return NO;
    }
    return YES;
  } else {
    [NewShowLabel setMessageContent:@"非法数据"];
    return NO;
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)endEdit {
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow endEditing:YES];
}

@end
