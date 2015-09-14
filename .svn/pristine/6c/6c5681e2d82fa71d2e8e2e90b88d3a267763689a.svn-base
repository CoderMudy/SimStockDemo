//
//  MatchCreateSuccessViewController.m
//  SimuStock
//
//  Created by jhss on 14-8-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MatchCreateSuccessViewController.h"
#import "UILabel+CmpetitionLabel.h"
#import "SimuUtil.h"
#import "MakingShareAction.h"
#import "MakingScreenShot.h"
#import "MatchCreateViewController.h"
#import "UIButton+Block.h"
#import "HomepageViewController.h"

@implementation MatchCreateSuccessViewController
@synthesize matchCreator = _matchCreator;
@synthesize matchImageUrl = _matchImageUrl;
@synthesize matchInviteCode = _matchInviteCode;
@synthesize matchName = _matchName;
@synthesize matchCreatorNickName = _matchCreatorNickName;
@synthesize matchDescr = _matchDescr;
@synthesize matchTime = _matchTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _indicatorView.hidden = YES;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //导航条

  [_topToolBar resetContentAndFlage:_matchName Mode:TTBM_Mode_Leveltwo];

  //创建分享页
  [self createTopViewWithState:_matchDescr
                 withMatchTime:_matchTime
                withInviteCode:_matchInviteCode
                  withImageUrl:_matchImageUrl];
  [self createCenterView:_matchInviteCode];
}
- (void)createTopViewWithState:(NSString *)matchState
                 withMatchTime:(NSString *)matchTime
                withInviteCode:(NSString *)matchInviteCode
                  withImageUrl:(NSString *)imageUrl {

  comDetailsView = [[UIView alloc] init];
  comDetailsView.frame =
      CGRectMake(0, topToolBarHeight, self.view.bounds.size.width, (142.0 + 72.0) / 2 + 1.0);
  comDetailsView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:comDetailsView];

  urlImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 142.0 / 2)];
  urlImgView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [JhssImageCache setImageView:urlImgView withUrl:imageUrl withDefaultImageName:@"banner.png"];

  [comDetailsView addSubview:urlImgView];

  //比赛说明名称
  UILabel *expLab = [[UILabel alloc] init];
  [expLab label:expLab
      labelText:@"比赛说明："
      textColor:[Globle colorFromHexRGB:@"#472026"]
          frame:CGRectMake(21.0 / 2, 23.0 / 2, 120, 22.0 / 2)
           font:[UIFont systemFontOfSize:Font_Height_10_0]
           wrap:NO];
  [comDetailsView addSubview:expLab];

  //比赛说明
  CGSize fsize = CGSizeMake(160.0 - (21.0 + 30.0) / 2, 2000);
  UIFont *font = [UIFont systemFontOfSize:Font_Height_10_0];
  CGSize labelsize = [matchState sizeWithFont:font
                            constrainedToSize:fsize
                                lineBreakMode:NSLineBreakByCharWrapping];
  UILabel *expContentLab = [[UILabel alloc] init];
  [expContentLab label:expContentLab
             labelText:matchState
             textColor:[Globle colorFromHexRGB:@"#472026"]
                 frame:CGRectMake(21.0 / 2, (23.0 + 6.0 + 20.0) / 2, 160.0 - (21.0 + 30.0) / 2, labelsize.height)
                  font:[UIFont systemFontOfSize:Font_Height_10_0]
                  wrap:YES];
  expContentLab.textAlignment = NSTextAlignmentLeft;
  [comDetailsView addSubview:expContentLab];

  //比赛时间名称：
  UILabel *nameTimeLab = [[UILabel alloc] init];
  [nameTimeLab label:nameTimeLab
           labelText:@"比赛时间："
           textColor:[Globle colorFromHexRGB:@"#472026"]
               frame:CGRectMake(comDetailsView.bounds.size.width - 43.0 / 2 - 50, 60.0 / 2, 50, 22.0 / 2)
                font:[UIFont systemFontOfSize:Font_Height_10_0]
                wrap:NO];
  nameTimeLab.textColor = [UIColor whiteColor];
  nameTimeLab.textAlignment = NSTextAlignmentLeft;
  [comDetailsView addSubview:nameTimeLab];
  //比赛时间内容
  matchTime = [matchTime stringByReplacingOccurrencesOfString:@" " withString:@""];
  UILabel *timeLab = [[UILabel alloc] init];
  [timeLab label:timeLab
       labelText:matchTime
       textColor:[Globle colorFromHexRGB:@"#472026"]
           frame:CGRectMake(comDetailsView.bounds.size.width - 43.0 / 2 - 50, 60.0 / 2 + 26.0 / 2, 70, 24)
            font:[UIFont systemFontOfSize:Font_Height_10_0]
            wrap:YES];
  timeLab.numberOfLines = 0;
  timeLab.textColor = [UIColor whiteColor];
  timeLab.textAlignment = NSTextAlignmentLeft;
  [comDetailsView addSubview:timeLab];

  //创建人名称：
  UILabel *founderNameLab = [[UILabel alloc] init];
  [founderNameLab label:founderNameLab
              labelText:@"创建人："
              textColor:[Globle colorFromHexRGB:Color_Text_Common]
                  frame:CGRectMake(23.0 / 2, 142.0 / 2 + (72.0 - 24.0) / 4, 50, 26.0 / 2)
                   font:[UIFont systemFontOfSize:Font_Height_12_0]
                   wrap:NO];
  [comDetailsView addSubview:founderNameLab];

  //创建人
  UIButton *founderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  founderBtn.frame = CGRectMake((23.0 + 90.0) / 2, 142.0 / 2 + (72.0 - 40.0) / 4, 200.0, 40.0 / 2);
  [founderBtn setTitle:_matchCreatorNickName forState:UIControlStateNormal];
  [founderBtn setTitleColor:[Globle colorFromHexRGB:@"#FE8519"] forState:UIControlStateNormal];
  [founderBtn setTitleColor:[Globle colorFromHexRGB:@"#D77205"] forState:UIControlStateHighlighted];
  founderBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  founderBtn.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  founderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  CGSize founderBtnSize = [SimuUtil labelContentSizeWithContent:_matchCreatorNickName
                                                       withFont:Font_Height_12_0
                                                       withSize:CGSizeMake(200, 9999)];
  founderBtn.width = founderBtnSize.width;
  founderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  founderBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  [founderBtn setOnButtonPressedHandler:^{
    [HomepageViewController showWithUserId:[SimuUtil getUserID]
                                 titleName:[SimuUtil getUserNickName]
                                   matchId:@"1"];
  }];
  [comDetailsView addSubview:founderBtn];

  //分割线
  UIView *upGrayLine =
      [[UIView alloc] initWithFrame:CGRectMake(5, comDetailsView.frame.size.height - 1, self.view.frame.size.width, 0.5)];
  upGrayLine.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
  [comDetailsView addSubview:upGrayLine];
  UIView *downWhiteLine =
      [[UIView alloc] initWithFrame:CGRectMake(5, comDetailsView.frame.size.height - 0.5, self.view.frame.size.width, 0.5)];
  downWhiteLine.backgroundColor = [UIColor whiteColor];
  [comDetailsView addSubview:downWhiteLine];
}
- (void)createCenterView:(NSString *)inviteCode {
  //比赛名称
  UILabel *matchNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(40, startY + 190, self.view.frame.size.width - 80, 36)];
  matchNameLabel.backgroundColor = [UIColor clearColor];
  matchNameLabel.font = [UIFont systemFontOfSize:15];
  matchNameLabel.textAlignment = NSTextAlignmentCenter;
  matchNameLabel.numberOfLines = 0;
  matchNameLabel.text = [NSString stringWithFormat:@"比赛创建成功，请等待审核"];
  matchNameLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  [self.view addSubview:matchNameLabel];
  //有无邀请码
  if (inviteCode && [inviteCode length] > 0) {
    matchNameLabel.text = [NSString
        stringWithFormat:@"比赛创建成功，请等待审核\n本次比赛的验证码是"];
    //邀请码 50,228
    UIView *inviteCodeView =
        [[UIView alloc] initWithFrame:CGRectMake(50, startY + 228 + 5, self.view.frame.size.width - 100, 40)];
    CALayer *inviteLayer = inviteCodeView.layer;
    [inviteLayer setBorderWidth:0.5];
    [inviteLayer setBorderColor:[Globle colorFromHexRGB:@"939393"].CGColor];
    inviteCodeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inviteCodeView];
    // 4个label
    CGFloat inviteCodeLabelWidth = inviteCodeView.width / 4.0f;
    for (int st = 0; st < 4; st++) {
      NSString *currentStr = [inviteCode substringWithRange:NSMakeRange(st, 1)];
      NSLog(@"currentStr = %@", currentStr);
      UILabel *inviteCodeLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(st * inviteCodeLabelWidth, 0, inviteCodeLabelWidth, 40)];
      inviteCodeLabel.backgroundColor = [UIColor clearColor];
      inviteCodeLabel.text = currentStr;
      inviteCodeLabel.textAlignment = NSTextAlignmentCenter;
      inviteCodeLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
      [inviteCodeView addSubview:inviteCodeLabel];
    }
    //分割线
    for (int i = 0; i < 3; i++) {
      UILabel *cuttingLine =
          [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * inviteCodeLabelWidth, 0, 0.5, 40)];
      cuttingLine.backgroundColor = [Globle colorFromHexRGB:@"939393"];
      [inviteCodeView addSubview:cuttingLine];
    }
  }
  //分享按钮
  BGColorUIButton *shareButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  shareButton.frame = CGRectMake(55, startY + 285, self.view.frame.size.width - 110, 38);
  [shareButton buttonWithTitle:@"分享给小伙伴"
            andNormaltextcolor:Color_White
      andHightlightedTextColor:Color_White];
  [shareButton setNormalBGColor:[Globle colorFromHexRGB:@"31bce9"]];
  [shareButton setHighlightBGColor:[Globle colorFromHexRGB:@"086dae"]];
  shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
  CALayer *shareLayer = shareButton.layer;
  [shareLayer setMasksToBounds:YES];
  [shareLayer setCornerRadius:19.0];
  [shareButton addTarget:self
                  action:@selector(shareInviteCodeToFriends)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:shareButton];
}
/**
 *分享给小伙伴
 */
- (void)shareInviteCodeToFriends {
  //截屏
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *shareImage = [makingScreenShot makingScreenShotWithFrame:self.view.frame
                                                           withView:self.view
                                                           withType:MakingScreenShotType_HomePage];
  if (shareImage) {
    NSString *selfUserID = [SimuUtil getUserID];
    NSString *shareUrl = @"http://www.youguu.com/opms/fragment/html/fragment.html";
    MakingShareAction *shareAction = [[MakingShareAction alloc] init];
    shareAction.shareModuleType = ShareModuleTypeStockMatchCreate;
    shareAction.shareUserID = selfUserID;
    [shareAction
            shareTitle:@"分享自"
               content:[NSString stringWithFormat:@"#优顾炒股#我刚刚创建了\"%@"
                                                  @"\"炒股比赛，江湖谁是老大，比比才"
                                                  @"知道！%@ (分享自@优顾炒股官方)",
                                                  _matchName, shareUrl]
                 image:shareImage
        withOtherImage:nil
          withShareUrl:shareUrl
         withOtherInfo:[NSString
                           stringWithFormat:@"我刚刚创建了\"%@" @"\"炒股比赛，江湖谁是老大，" @"比比才知道！", _matchName]];
  }
}
#pragma mark
#pragma mark---------切换、返回------
//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  //邀请码重置下
  [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"inviteTimeInternal"];
  [[NSUserDefaults standardUserDefaults] synchronize];

  if (self.leftBackBlock) {
    self.leftBackBlock();
  } else {
    [super leftButtonPress];
  }
}

@end
