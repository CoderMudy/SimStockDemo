//
//  ExpertRecommendViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertRecommendViewController.h"
#import "MasterRankingViewController.h"
#import "event_view_log.h"
#import "MobClick.h"

@interface ExpertRecommendViewController () <GameAdvertisingDelegate> {
  //字典 装着列表页的信息
  NSDictionary *_mutableDictionary;
}

@end

@implementation ExpertRecommendViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  /**
   *  总盈利  == 101
   *  成功率  == 102
   *  稳健榜  == 103
   *  短线榜  == 104
   *  月盈利榜 == 105
   *  周盈利榜 == 106
   *  人气榜  == 107
   *  推荐榜  == 108
   */
  _mutableDictionary = @{
    @"101" : @[ @"3", @"（总盈利率）", @0, @"炒股牛人-今日盈利榜", @"总盈利榜" ],
    @"102" : @[ @"4", @"（成功率）", @2, @"炒股牛人-周盈利榜", @"成功率榜" ],
    @"103" : @[ @"6",
                @"（总盈利率）",
                @0,
                @"炒股牛人-稳健牛人榜单",
                @"稳健榜" ],
    @"104" : @[ @"7",
                @"（总盈利率）",
                @0,
                @"炒股牛人-短线牛人榜单",
                @"短线榜" ],
    @"105" : @[ @"5", @"（月盈利率）", @2, @"炒股牛人-月盈利榜", @"月盈利榜" ],
    @"106" : @[ @"8", @"（周盈利率）", @2, @"炒股牛人-月盈利榜", @"周盈利榜" ],
    @"107" : @[ @"2", @"（人气值）", @0, @"炒股牛人-人气榜单", @"人气榜" ],
    @"108" :
        @[ @"1", @"（推荐指数）", @0, @"炒股牛人-优顾推荐榜", @"推荐榜" ]
  };

  //加载广告
  [self creatAdvView];
  //设置Button
  [self setUpButton];
  
}

#pragma mark-- 加载广告
- (void)creatAdvView {
  self.advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeFollowManster];
  self.advViewVC.delegate = self;
  self.advViewVC.view.userInteractionEnabled = NO;
  self.advViewVC.view.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  //数据请求
  CGFloat ratioValue = WIDTH_OF_SCREEN / 375.0f;
  self.gameAdvHeight.constant = ratioValue * (CGFloat)self.gameAdvHeight.constant;
  self.advertisingView.height = self.gameAdvHeight.constant;
  self.view.height = self.advertisingView.height + 214;
  [self addChildViewController:self.advViewVC];
  [self.advViewVC requestImageAdvertiseList];
}

-(void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  self.advViewVC.view.frame = self.advertisingView.bounds;
}


- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg {
  self.notWorkLittleImageView.hidden = AdBool;
  if (AdBool) {
    //有广告
    self.advViewVC.view.userInteractionEnabled = AdBool;
    [self.advertisingView addSubview:_advViewVC.view];
    self.advertisingView.clipsToBounds = YES;
  }else{
    [self.advViewVC.view removeAllSubviews];
  }
}

#pragma mark-- 对button按键进行设置
- (void)setUpButton {
  __weak ExpertRecommendViewController *weakSelf = self;
  for (int i = 0; i < self.expertClassificationButtonArray.count; i++) {
    //取出button
    BGColorUIButton *button = self.expertClassificationButtonArray[i];
    //切园
    button.layer.cornerRadius = button.height * 0.5;
    //设置蒙版
    button.layer.masksToBounds = YES;
    //按钮防重复点击
    [button setOnButtonPressedHandler:^{
      ExpertRecommendViewController *strongSelf = weakSelf;
      if (strongSelf) {
        //按钮点击事件
        [strongSelf buttonDownUpInside:strongSelf.expertClassificationButtonArray[i]];
      }
    }];
  }
}
/** 按钮点击事件 */
- (void)buttonDownUpInside:(BGColorUIButton *)button {
  NSString *key = [NSString stringWithFormat:@"%ld", (long)button.tag];
  NSLog(@"我被点击了！ = %@", key);
  MasterRankingViewController *masterRankingVC = [[MasterRankingViewController alloc] init];
  NSArray *array = _mutableDictionary[key];
  masterRankingVC.rankingSortNumber = array[0];
  masterRankingVC.rankingSortName = array[1];
  masterRankingVC.stepNumber = [array[2] integerValue];
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:array[3]];
  //纪录日志
  [MobClick beginLogPageView:array[3]];
  masterRankingVC.rankingTitle = [array lastObject];
  [AppDelegate pushViewControllerFromRight:masterRankingVC];
}
@end
