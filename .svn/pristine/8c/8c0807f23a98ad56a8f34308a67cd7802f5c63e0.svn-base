//
//  AwardsMatchViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AwardsMatchViewController.h"
#import "AwardsRankingView.h"
#import "AddAwardsView.h"
#import "ContestAwardsView.h"
#import "SimuOpenMatchData.h"
#import "NewShowLabel.h"

/** 每行奖项的高度 == 42.0f */
static const CGFloat awardsWidth = 42.0f;

/** 第一名 和 添加奖项 的总高度 （没有其他奖项时） */
static const CGFloat rankingAddAwardsHeight = 99.0f;

/** 控件 初始化开启状态的 高度 */
static const CGFloat awardsInitalizationHeight = 186.0f;

@interface AwardsMatchViewController () {
  // frame 初始化的大小
  CGRect _viewFrame;
  /** 记录点击的次数 */
  NSInteger _clickNumber;
  /** 记录初始奖项frame */
  CGRect _awardsRankingFrame;
  /** 保存奖项的数组 */
  NSMutableArray *_contestArray;
  /** 数组 保存第二名 到 第十名 */
  NSArray *_rankingLabelArray;
}
@end

@implementation AwardsMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withFrame:(CGRect)frame {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _viewFrame = frame;
    _contestArray = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = _viewFrame;
  _clickNumber = 0;
  _rankingLabelArray = @[
    @"第二名:",
    @"第三名:",
    @"第四名:",
    @"第五名:",
    @"第六名:",
    @"第七名:",
    @"第八名:",
    @"第九名:",
    @"第十名:"
  ];
  //初始化xib
  [self hideAwardsRankingWithAddAwards];
  __weak AwardsMatchViewController *weakSelf = self;
  self.awardsSetUpView.awardsSwitchOnBlock = ^() {
    NSLog(@"开起状态");
    AwardsMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf openState];
    }
  };

  self.awardsSetUpView.awardsSwitchOffBlock = ^() {
    NSLog(@"关闭状态");
    AwardsMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf closeState];
    }
  };

  self.addAwardsView.addAwardsBlock = ^() {
    AwardsMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addAwardsrankingForAddButton];
    }
  };
  self.awardsSetUpView.startIndicatorBlock = self.matchStartIndicatorBlock;
  self.awardsSetUpView.stopIndicatorBlock = self.matchStopIndicatorBlock;
  
}
/** 隐藏添加奖项 和 奖项目录 */
- (void)hideAwardsRankingWithAddAwards {
  self.baseAwardsView.hidden = YES;
  self.baseAwardsHeight.constant = 0.0f;
}

/** 对外提供frame */
- (void)foreignProvideFrameForSelf {
  if (self.foreignProvideFrameBlock) {
    self.foreignProvideFrameBlock(self.view.frame);
  }
}

/** 开启状态 */
- (void)openState {
  CGFloat height;
  if (_clickNumber == 0) {
    self.view.height =
        CGRectGetHeight(self.view.bounds) + rankingAddAwardsHeight;
    self.baseAwardsHeight.constant = rankingAddAwardsHeight;
    self.baseAwardsView.hidden = NO;
    _awardsRankingFrame = self.awardsRankingView.frame;
    height = rankingAddAwardsHeight;
  } else {
    self.view.height = CGRectGetHeight(_viewFrame);
    self.baseAwardsHeight.constant =
        _contestArray.count * awardsWidth + rankingAddAwardsHeight;
    self.baseAwardsView.hidden = NO;
    _awardsRankingFrame =
        ((ContestAwardsView *)[_contestArray lastObject]).frame;
    height = _contestArray.count * awardsWidth + rankingAddAwardsHeight;
  }
  self.awardsSetUpView.bottomLineHorizontalSpace.constant = 20.0f;
  [self foreignProvideFrameForSelf];
}

/** 关闭状态 */
- (void)closeState {
  self.baseAwardsView.hidden = YES;
  self.baseAwardsHeight.constant = 0.0f;
  self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 88.0f);
  self.awardsSetUpView.bottomLineHorizontalSpace.constant = 0.0f;
  [self foreignProvideFrameForSelf];
}

/** 添加奖品项 */
- (void)addAwardsrankingForAddButton {
  _clickNumber++;
  if (_clickNumber > 9) {
    _clickNumber = 9;
    [NewShowLabel setMessageContent:@"最多支持奖励前十名选手"];
    return;
  }
  //先改变 最外层的frame
  self.view.frame =
      CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame),
                 CGRectGetWidth(self.view.bounds),
                 awardsInitalizationHeight + _clickNumber * awardsWidth);
  _viewFrame = self.view.frame;
  //在改变 baseView
  self.baseAwardsHeight.constant =
      rankingAddAwardsHeight + _clickNumber * awardsWidth;
  self.baseAwardsView.height = self.baseAwardsHeight.constant;
  ContestAwardsView *awardsView = [ContestAwardsView showContestAwardsView];
  __weak AwardsMatchViewController *weakSelf = self;
  awardsView.deleteButtonDownBlock = ^(ContestAwardsView *contestView) {
    AwardsMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf deleteButtonDownForContestAwardsView:contestView];
    }
  };
  [self.baseAwardsView addSubview:awardsView];
  [_contestArray addObject:awardsView];
  //改变名次
  awardsView.rankingLabel.text = _rankingLabelArray[_clickNumber - 1];
  for (int i = 0; i < _contestArray.count; i++) {
    ContestAwardsView *temp = _contestArray[i];
    temp.frame =
        CGRectMake(0, (i + 1) * awardsWidth, WIDTH_OF_SCREEN, awardsWidth);
    if (i != (_contestArray.count - 1)) {
      temp.deleteButton.hidden = YES;
    }
  }
  _awardsRankingFrame = awardsView.frame;
  [self foreignProvideFrameForSelf];
}

#pragma mark-- 删除事件
- (void)deleteButtonDownForContestAwardsView:
    (ContestAwardsView *)contestAwardsView {
  //点击删除后
  _clickNumber--;
  //删除自己
  [contestAwardsView removeFromSuperview];
  self.baseAwardsHeight.constant =
      CGRectGetHeight(self.baseAwardsView.bounds) - awardsWidth;
  self.baseAwardsView.height = self.baseAwardsHeight.constant;
  self.view.height = CGRectGetHeight(self.view.bounds) - awardsWidth;
  _viewFrame = self.view.frame;
  [_contestArray removeLastObject];
  if (_contestArray.count != 0) {
    ContestAwardsView *temp = [_contestArray lastObject];
    temp.deleteButton.hidden = NO;
    _awardsRankingFrame = temp.frame;
    for (int i = 0; i < _contestArray.count; i++) {
      ContestAwardsView *contestTemp = _contestArray[i];
      contestTemp.frame =
          CGRectMake(0, (i + 1) * awardsWidth, contestTemp.width, awardsWidth);
    }
  } else {
    _awardsRankingFrame = self.awardsRankingView.frame;
  }
  [self foreignProvideFrameForSelf];
}

- (MatchCreateAwardInfo *)matchAwardInfo {
  if (!_matchAwardInfo) {
    _matchAwardInfo = [[MatchCreateAwardInfo alloc] init];
    _matchAwardInfo.isReward = [self judgeSwitchWhetherOpen];
    if ([_matchAwardInfo.isReward isEqualToString:@"1"]) {
      //数据源
      if ([self checkDataSource]) {
        _matchAwardInfo.reward = [self dataForTextFiled];
      }
    }
  }
  return _matchAwardInfo;
}

/** 校验数据源是否正确 */
- (BOOL)checkDataSource {
  if (!self.awardsSetUpView.awardsSwitch.on) {
    return YES;
  }
  //第一名的奖项
  if (self.awardsRankingView.awardsTextField.text.length == 0) {
    [NewShowLabel setMessageContent:@"第一名的奖项未设置"];
    return NO;
  }
  //输入框
  for (int i = 0; i < _contestArray.count; i++) {
    ContestAwardsView *temp = _contestArray[i];
    if (temp.awardsTextField.text.length == 0) {
      NSString *ranking =
          [NSString stringWithFormat:@"%@的奖项未设置", _rankingLabelArray[i]];
      [NewShowLabel setMessageContent:ranking];
      return NO;
    }
  }
  return YES;
}

/** 判断 开关是否开启 */
- (NSString *)judgeSwitchWhetherOpen {
  if (self.awardsSetUpView.awardsSwitch.on) {
    return @"1";
  } else {
    return @"0";
  }
}

- (NSString *)dataForTextFiled {
  NSMutableArray *messagArray = [NSMutableArray array];
  NSString *str1 = self.awardsRankingView.awardsTextField.text;
  [messagArray addObject:str1];
  for (int i = 0; i < _contestArray.count; i++) {
    ContestAwardsView *temp = _contestArray[i];
    NSString *str = temp.awardsTextField.text;
    [messagArray addObject:str];
  }
  NSString *contest = [messagArray componentsJoinedByString:@","];
  return contest;
}

/** 收键盘 */
- (void)receiveKeyboardWithAwardsVC {
  [self.awardsRankingView rankingReceiveKeyboard];
  for (int i = 0; i < _contestArray.count; i++) {
    [((ContestAwardsView *)_contestArray[i])contestReceiveKeyboard];
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

@end
