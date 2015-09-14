//
//  HomePageUserInfoView.m
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomePageUserInfoView.h"
#import "MyInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "event_view_log.h"

#import "StockPositionViewController.h"
#import "TrancingViewController.h"
#import "MyAttentionViewController.h"
#import "MyFansViewController.h"

@implementation HomePageUserInfoView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"HomePageUserInfoView" bundle:nil] instantiateWithOwner:self
                                                                                 options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}
- (void)awakeFromNib {

  [self seettingUpUserHeaderImageView];
  [self settingUpAllButton];
  //隐藏V认证
  self.vSignView.hidden = YES;
  //改变粉丝数量
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshFansNumReduce)
                                               name:Notification_FansNum_Reduce
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshFansNumAdd)
                                               name:Notification_FansNum_Add
                                             object:nil];
}
- (void)refreshFansNumReduce {
  [self.fansButton setTitle:[@"粉丝 " stringByAppendingString:[self stringFromFansNumber:--self.fansNumber]]
                   forState:UIControlStateNormal];
}
- (void)refreshFansNumAdd {
  [self.fansButton setTitle:[@"粉丝 " stringByAppendingString:[self stringFromFansNumber:++self.fansNumber]]
                   forState:UIControlStateNormal];
}
#pragma mark 粉丝计算
- (NSString *)stringFromFansNumber:(NSInteger)fans {
  NSString *fansStr;
  //如果大于10000，则显示1位小数+万
  if (fans >= 10000) {
    fansStr = [NSString stringWithFormat:@"%ld万", (long)fans / 10000];
  } else {
    fansStr = [NSString stringWithFormat:@"%ld", (long)fans];
  }
  return fansStr;
}
///设置头像
- (void)seettingUpUserHeaderImageView {
  //设置头像背景
  self.userHeaderBGImageView.layer.borderWidth = 0.5;
  self.userHeaderBGImageView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f] CGColor];
  self.userHeaderBGImageView.layer.cornerRadius = self.userHeaderBGImageView.height / 2;
  //设置头像
  self.userHeaderImageView.backgroundColor = [Globle colorFromHexRGB:@"#87c8f1"];
  self.userHeaderImageView.layer.cornerRadius = self.userHeaderImageView.height / 2;
  self.userHeaderImageView.clipsToBounds = YES;

  //设置昵称
  self.nickNameView.hidden = YES;
  self.nickNameView.lblNickName.normalTitleColor = [Globle colorFromHexRGB:Color_White];
  self.nickNameView.lblNickName.titleLabel.font = [UIFont systemFontOfSize:Font_Height_17_0];
  self.nickNameView.userInteractionEnabled = NO;
}
///设置按钮
- (void)settingUpAllButton {
  [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
    [btn setTitleColor:[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f]
              forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  }];
  //设置
  self.verticalLine.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common alpha:0.5f];
  self.verticalLineWidth.constant = 0.5f;

  self.verticalLineMiddle.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common alpha:0.5f];
  self.verticalLineMiddleWidth.constant = 0.5f;

  self.verticalLineRight.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common alpha:0.5f];
  self.verticalLineRightWidth.constant = 0.5f;

  [self.positionButton addTarget:self
                          action:@selector(clickPositionButtonMethod)
                forControlEvents:UIControlEventTouchUpInside];
  [self.followButton addTarget:self
                        action:@selector(clickFollowButtonMethod)
              forControlEvents:UIControlEventTouchUpInside];
  [self.attentionButton addTarget:self
                           action:@selector(clickAttentionButtonMethod)
                 forControlEvents:UIControlEventTouchUpInside];
  [self.fansButton addTarget:self
                      action:@selector(clickFansButtonMethod)
            forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickPositionButtonMethod {
  [self.positionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self performBlock:^{
    [self.positionButton setTitleColor:[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f]
                              forState:UIControlStateNormal];
    __weak HomePageUserInfoView *weakSelf = self;
    //判断有没有返回数据，没有返回数据不能进行点击
    if (self.userInfoItem != nil) {
      StockPositionViewController *mfvc_personViewControler =
          [[StockPositionViewController alloc] initWithID:weakSelf.userInfoItem.userid
                                             withNickName:weakSelf.userInfoItem.nickName
                                              withHeadPic:weakSelf.userInfoItem.headPic
                                              withMatchID:@"1"
                                              withViptype:[weakSelf.userInfoItem.vipType integerValue]
                                             withUserItem:weakSelf.userInfoItem.userListItem];
      [AppDelegate pushViewControllerFromRight:mfvc_personViewControler];
    }
  } withDelaySeconds:0.2f];
}
/** 追踪按钮 */
- (void)clickFollowButtonMethod {
  [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  __weak HomePageUserInfoView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.followButton setTitleColor:[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f]
                                forState:UIControlStateNormal];
    //判断有没有返回数据，没有返回数据不能进行点击
    if (self.userInfoItem != nil) {
      //追踪页，根据传入userid和当前用户id进行比较，决定是我的追踪还是ta得追踪
      TrancingViewController *myTracingVC = [[TrancingViewController alloc] init];
      myTracingVC.userID = weakSelf.userInfoItem.userid;
      [AppDelegate pushViewControllerFromRight:myTracingVC];
    }
  } withDelaySeconds:0.2f];
}
- (void)clickAttentionButtonMethod {
  [self.attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  __weak HomePageUserInfoView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.attentionButton setTitleColor:[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f]
                                   forState:UIControlStateNormal];
    //判断有没有返回数据，没有返回数据不能进行点击
    if (self.userInfoItem != nil) {
      MyAttentionViewController *showViewController = [[MyAttentionViewController alloc] init];
      showViewController.userID = weakSelf.userInfoItem.userid;
      [AppDelegate pushViewControllerFromRight:showViewController];
    }
  } withDelaySeconds:0.2f];
}
- (void)clickFansButtonMethod {
  [self.fansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  __weak HomePageUserInfoView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.fansButton setTitleColor:[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f]
                              forState:UIControlStateNormal];
    //判断有没有返回数据，没有返回数据不能进行点击
    if (self.userInfoItem != nil) {
      MyFansViewController *showViewController = [[MyFansViewController alloc] init];
      showViewController.userID = weakSelf.userInfoItem.userid;
      [AppDelegate pushViewControllerFromRight:showViewController];
    }
  } withDelaySeconds:0.2f];
}
/** 判断是否是用户自己 */
- (void)judgeWhetherItIsTheirOwn:(BOOL)isOneself {
  if (isOneself) {
    self.headerButton.userInteractionEnabled = YES;
    self.headerButton.backgroundColor = [UIColor clearColor];
    [self.headerButton.layer setMasksToBounds:YES];
    self.headerButton.layer.cornerRadius = self.headerButton.height / 2;
    UIImage *backImage = [UIImage imageNamed:@"比赛按钮高亮状态"];
    self.headerButton.alpha = 0.75;
    [self.headerButton setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [self.headerButton addTarget:self
                          action:@selector(clickPersonalHeaderPic)
                forControlEvents:UIControlEventTouchUpInside];
  } else {
    self.headerButton.userInteractionEnabled = NO;
  }
}
- (void)clickPersonalHeaderPic {
  __weak HomePageUserInfoView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.headerButton setBackgroundImage:nil forState:UIControlStateNormal];
    //个人信息
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"146"];
    [AppDelegate pushViewControllerFromRight:[[MyInfoViewController alloc] init]];
  } withDelaySeconds:0.2f];
}

- (void)bindUserInfoData:(HomePageTableHeaderData *)informationDic {
  self.userInfoItem = informationDic.userInfoData;
  //粉丝数
  self.fansNumber = [[self valueJudgmentsOnTheAir:informationDic.userInfoData.fansNum] intValue];

  [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:informationDic.userInfoData.headPic]
                           placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
  if ([informationDic.userInfoData.userid isEqualToString:[SimuUtil getUserID]]) {
    [self judgeWhetherItIsTheirOwn:YES];
  } else {
    [self judgeWhetherItIsTheirOwn:NO];
  }

  // V字认证和机构认证
  NSString *vType = informationDic.userInfoData.vType;
  if ([vType isEqualToString:@"1"] || [vType isEqualToString:@"2"]) {
    self.vSignView.hidden = NO;
    if (self.vSignView) {
      self.vSignView.layer.cornerRadius = 9;
      self.vSignView.clipsToBounds = YES;
      self.vSignView.backgroundColor = [Globle colorFromHexRGB:@"EC4C41"];
      self.vSignView.text = @"V";
      self.vSignView.textColor = [UIColor whiteColor];
      self.vSignView.textAlignment = NSTextAlignmentCenter;
      self.vSignView.font = [UIFont boldSystemFontOfSize:Font_Height_14_0];
    }
    self.signatureLabel.textColor = [Globle colorFromHexRGB:@"EC4C41"];
  } else {
    self.signatureLabel.textColor = [Globle colorFromHexRGB:COLOR_SIGNATURE];
    self.vSignView.hidden = YES;
  }

  //昵称
  [self showNickname];
  //按钮赋值
  [self.positionButton setTitle:[@"持仓 " stringByAppendingString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.positionNum]]
                       forState:UIControlStateNormal];
  [self.followButton setTitle:[@"追踪 " stringByAppendingString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.traceNum]]
                     forState:UIControlStateNormal];
  [self.attentionButton setTitle:[@"关注 " stringByAppendingString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.followNum]]
                        forState:UIControlStateNormal];
  [self.fansButton setTitle:[@"粉丝 " stringByAppendingString:[self stringFromFansNumber:self.fansNumber]]
                   forState:UIControlStateNormal];
  //个人签名
  NSString *signature = informationDic.userInfoData.certifySignature;
  if (signature.length == 0) {
    signature = informationDic.userInfoData.signature;
  } else {
    signature = [@"优顾认证：" stringByAppendingString:signature];
  }
  if (!signature || signature.length == 0) {
    signature = @"签名还在酝酿中...";
    informationDic.userInfoData.signature = signature;
  }
  self.signatureLabel.text = signature;
}
- (void)showNickname {
  NSInteger viptype = [self.userInfoItem.vipType integerValue];
  self.nickNameView.width = WIDTH_OF_SCREEN;
  [self.nickNameView bindUserListItem:self.userInfoItem.userListItem isOriginalPoster:NO];
  BOOL isVip = (viptype == VipUser || viptype == SVipUser);
  self.nickNameView.lblNickName.normalTitleColor =
      [Globle colorFromHexRGB:isVip ? Color_YELLOW_VIP : Color_White];
  self.nickNameView.hidden = NO;
  self.userNameLeft.constant = (WIDTH_OF_SCREEN - self.nickNameView.contentWidth) / 2.f;
}
#pragma mark 对空做判断
- (NSString *)valueJudgmentsOnTheAir:(NSString *)str {
  if (!str || [str isEqualToString:@""]) {
    return @"0";
  }
  return str;
}

- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
