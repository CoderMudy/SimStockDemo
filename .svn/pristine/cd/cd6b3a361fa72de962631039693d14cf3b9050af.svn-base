//
//  InviteFriendViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "AppDelegate.h"
#import "SimuUtil.h"
#import "MobClick.h"
#import "InviteFriendTableViewCell.h"
#import "NewShowLabel.h"
#import "HomepageViewController.h"
#import "MPNotificationView.h"
#import "InvieFriendListWarpper.h"
#import "MyAttentionInfo.h"
#import "CacheUtil.h"

@interface InviteFriendViewController () <
    UITableViewDataSource, UITableViewDelegate,
    InviteFriendTableViewCellDelegate, ISSShareViewDelegate> {
  //表格
  UITableView *friendTableView;
  //存放数据
  NSMutableArray *friendDataArr;
  AppDelegate *_appDelegate;
}

@end

@implementation InviteFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
- (void)dealloc {
  friendTableView.delegate = nil;
  friendTableView.dataSource = nil;
}
//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"邀请好友"];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"邀请好友"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //数据类
  dataArray = [[DataArray alloc] init];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  friendDataArr = [[NSMutableArray alloc] init];
  [self navigationTopToolView];
  //表格
  [self createTableView];
  [self resetIndicatorView];
  [self inviteFriendsListRequestBeenSuccessfully];
}
//导航视图
- (void)navigationTopToolView {
  NSString *flage = @"邀请好友";
  [_topToolBar resetContentAndFlage:flage Mode:TTBM_Mode_Leveltwo];
}
#pragma mark UITableView
- (void)createTableView {
  friendTableView = [[UITableView alloc] initWithFrame:self.clientView.bounds
                                                 style:UITableViewStylePlain];
  friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  friendTableView.showsVerticalScrollIndicator = NO;
  friendTableView.delegate = self;
  friendTableView.dataSource = self;
  friendTableView.scrollEnabled = NO;
  [self.clientView addSubview:friendTableView];
}
#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  }
  return [friendDataArr count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 49.0 / 2;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 388.0 / 2;
  } else if (indexPath.section == 1) {
    return 121.0 / 2;
  }
  return 0;
}
- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UIView *btview = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width,
                               49.0 / 2)];
  btview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  UILabel *label = [[UILabel alloc]
      initWithFrame:CGRectMake(31.0 / 2, 0.0, 180.0, 49.0 / 2)];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:24.0 / 2];
  if (section == 0) {
    label.text = @"可通过以下方式邀请好友";
  } else if (section == 1) {
    label.text = @"已成功邀请的好友列表";
    //邀请好友数
    NSString *numStr =
        [NSString stringWithFormat:@"共%lu位", (long)([friendDataArr count])];
    NSInteger numInt = numStr.length;
    NSMutableAttributedString *Attribut =
        [[NSMutableAttributedString alloc] initWithString:numStr];
    [Attribut addAttribute:NSForegroundColorAttributeName
                     value:[Globle colorFromHexRGB:@"#e70a11"]
                     range:NSMakeRange(1, numInt - 2)];
    [Attribut addAttribute:NSForegroundColorAttributeName
                     value:[Globle colorFromHexRGB:Color_Text_Common]
                     range:NSMakeRange(0, 1)];
    [Attribut addAttribute:NSForegroundColorAttributeName
                     value:[Globle colorFromHexRGB:Color_Text_Common]
                     range:NSMakeRange(numInt - 1, 1)];
    UILabel *numLab = [[UILabel alloc]
        initWithFrame:CGRectMake(tableView.bounds.size.width - 100.0 - 31.0 / 2,
                                 0.0, 100.0, 49.0 / 2)];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.font = [UIFont systemFontOfSize:Font_Height_12_0];
    numLab.attributedText = Attribut;
    [btview addSubview:numLab];
  }
  [btview addSubview:label];
  return btview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"cell";
  InviteFriendTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:Cell];
  if (cell == nil) {
    cell = [[InviteFriendTableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:Cell];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    if (indexPath.section == 1) {
      UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
      backView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
      cell.selectedBackgroundView = backView;
    } else {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  }
  cell.shareView.hidden = YES;
  cell.whiteView.hidden = YES;
  cell.concernBut.hidden = YES;
  cell.nameLab.hidden = YES;
  cell.topLineView.hidden = YES;
  cell.bottomLineView.hidden = YES;
  cell.userHeadBtn.hidden = YES;
  if (indexPath.section == 0) {
    cell.shareView.hidden = NO;
  } else {
    cell.whiteView.hidden = NO;
    cell.concernBut.hidden = NO;
    cell.nameLab.hidden = NO;
    cell.userHeadBtn.hidden = NO;
    cell.topLineView.hidden = NO;
    cell.bottomLineView.hidden = NO;
    cell.rowInt = indexPath.row;
    if ([friendDataArr count] > indexPath.row) {
      SuccessfullyInvitedList *invitedData = friendDataArr[indexPath.row];
      NSString *str = invitedData.nickName;
      CGSize labelsize =
          [str sizeWithFont:[UIFont systemFontOfSize:Font_Height_14_0]
              constrainedToSize:CGSizeMake(150.0, 100.0)
                  lineBreakMode:NSLineBreakByCharWrapping];
      cell.nameLab.frame =
          CGRectMake(130.0 / 2, (119.0 - 60.0) / 4, labelsize.width + 10, 30.0);
      cell.nameLab.text = invitedData.nickName;

      cell.userID = invitedData.userId;
      cell.updateAttentionStatus = ^(BOOL isAttention) {
        if (isAttention) {
          invitedData.flag = YES;
        } else {
          invitedData.flag = NO;
        }
      };
      if (invitedData.flag == YES) {
        [cell.concernBut setTitle:@"取消" forState:UIControlStateNormal];
        [cell.btnIcon setImage:[UIImage imageNamed:@"灰心小图标"]];
        [cell.concernBut.layer
            setBorderColor:[Globle colorFromHexRGB:@"b4b4b4"].CGColor];
        [cell.concernBut setTitleColor:[Globle colorFromHexRGB:@"939393"]
                              forState:UIControlStateNormal];
      } else {
        [cell.concernBut setTitle:@"关注" forState:UIControlStateNormal];
        [cell.btnIcon setImage:[UIImage imageNamed:@"红心小图标"]];
        [cell.concernBut.layer
            setBorderColor:[Globle colorFromHexRGB:@"fc7679"].CGColor];
        [cell.concernBut setTitleColor:[Globle colorFromHexRGB:@"454545"]
                              forState:UIControlStateNormal];
      }
      [JhssImageCache setImageView:cell.userHeadImageView
                           withUrl:invitedData.headPic
              withDefaultImageName:@"用户默认头像"];
    }
  }
  cell.delegate = self;
  return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self shareButtonInviteFriendCallbackMethod:4410 row:indexPath.row];
  }
}
#pragma mark------------------InviteFriendTableViewCellDelegate------------------
- (void)shareButtonInviteFriendCallbackMethod:(NSInteger)tag {
  MyInfomationItem *info = [CacheUtil myInfomation];
  NSString *inviteCode = info && info.mInviteCode ? info.mInviteCode : @"";
  if ([inviteCode isEqualToString:@""]) {
    return;
  }
  NSString *shareUrl =
      [NSString stringWithFormat:@"%@%@", shareWeb_address, inviteCode];
  switch (tag) {
  case 4400: //微信好友
  {
    [self shareTencentWeiboAndSinaWeibo:4400
                              imagePath:@"icon"
                                content:@"发" @"现"
                                @"一个好玩的炒股应用，快来一起"
                                @"体验下" @"吧！"
                                  title:@"优顾炒股"
                                    url:shareUrl];
  } break;
  case 4401: //微信朋友圈
  {
    [self shareTencentWeiboAndSinaWeibo:4401
                              imagePath:@"icon"
                                content:@"发" @"现"
                                @"一个好玩的炒股应用，快来一起"
                                @"体验下" @"吧！"
                                  title:nil
                                    url:shareUrl];
  } break;
  case 4402: // QQ好友
  {
    [self shareTencentWeiboAndSinaWeibo:4402
                              imagePath:@"icon"
                                content:@"发" @"现"
                                @"一个好玩的炒股应用，快来一起"
                                @"体验下" @"吧！"
                                  title:@"优顾炒股"
                                    url:shareUrl];
  } break;
  case 4403: // QQ空间
  {
    [self shareTencentWeiboAndSinaWeibo:4403
                              imagePath:@"icon"
                                content:@"发" @"现"
                                @"一个好玩的炒股应用，快来一起"
                                @"体验下吧"
                                  title:@"优顾炒股"
                                    url:shareUrl];
  } break;
  case 4404: //新浪微博
  {

    NSString *content = [NSString
        stringWithFormat:
            @"#优顾炒股#"
            @"发现一个好玩的炒股应用，快来一起体验下吧"
            @"！注册时输入邀请码%@，会有惊喜给你哦！%@ "
            @"(分享自@优顾炒股官方)",
            inviteCode, shareUrl];
    [self shareTencentWeiboAndSinaWeibo:4404
                              imagePath:nil
                                content:content
                                  title:nil
                                    url:shareUrl];
  } break;
  case 4405: //腾讯微博
  {
    NSString *content = [NSString
        stringWithFormat:@"#优顾炒股#" @"发"
                         @"现一个好玩的炒股应用，快来一起体"
                         @"验下吧！注册时输"
                         @"入邀请码%@，会有惊喜给你哦！%@ "
                         @"(分享自@youguu-com)",
                         inviteCode, shareUrl];
    [self shareTencentWeiboAndSinaWeibo:4405
                              imagePath:nil
                                content:content
                                  title:nil
                                    url:shareUrl];
  } break;
  case 4406: //短信
  {
    [self shareTencentWeiboAndSinaWeibo:4406
                              imagePath:@""
                                content:
                                    [NSString
                                        stringWithFormat:
                                            @"发"
                                            @"现一个好玩的炒股应用，"
                                            @"快来一起体验下吧！ %@",
                                            shareUrl]
                                  title:nil
                                    url:shareUrl];
  } break;
  default:
    break;
  }
}
//分享腾讯微博和新浪微博
- (void)shareTencentWeiboAndSinaWeibo:(NSInteger)tagInt
                            imagePath:(NSString *)imagePathStr
                              content:(NSString *)content
                                title:(NSString *)title
                                  url:(NSString *)url {
  ShareType typeTencent;
  SSPublishContentMediaType publishContentMediaType;
  if (tagInt == 4400) {
    typeTencent = ShareTypeWeixiSession;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else if (tagInt == 4401) {
    typeTencent = ShareTypeWeixiTimeline;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else if (tagInt == 4402) {
    typeTencent = ShareTypeQQ;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else if (tagInt == 4403) {
    typeTencent = ShareTypeQQSpace;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else if (tagInt == 4404) {
    typeTencent = ShareTypeSinaWeibo;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else if (tagInt == 4405) {
    typeTencent = ShareTypeTencentWeibo;
    publishContentMediaType = SSPublishContentMediaTypeNews;
  } else {
    typeTencent = ShareTypeSMS;
    publishContentMediaType = SSPublishContentMediaTypeText;
  }

  //初始化对象
  _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  //创建分享内容
  UIImage *imagePath = [UIImage imageNamed:imagePathStr];
  id<ISSContent> publishContent =
      [ShareSDK content:content
          defaultContent:@""
                   image:[ShareSDK pngImageWithImage:imagePath]
                   title:title
                     url:url
             description:nil
               mediaType:publishContentMediaType];
  //分享到qq空间
  [publishContent
      addQQSpaceUnitWithTitle:@"优顾炒股"
                          url:INHERIT_VALUE
                         site:nil
                      fromUrl:nil
                      comment:INHERIT_VALUE
                      summary:@"发" @"现" @"一"
                      @"个好玩的炒股应用，快来一起体验下"
                      @"吧！"
                        image:[ShareSDK jpegImageWithImage:
                                            [UIImage imageNamed:@"shareIcon"]
                                                   quality:1.0]
                         type:nil
                      playUrl:nil
                         nswb:nil];
  //定义微信朋友圈信息
  [publishContent
      addWeixinTimelineUnitWithType:@(SSPublishContentMediaTypeNews)
                            content:@"发" @"现"
                            @"一个好玩的炒股应用，快来一起体验"
                            @"下吧！"
                              title:@"发" @"现" @"一"
                              @"个好玩的炒股应用，快来一起"
                              @"体验" @"下吧！"
                                url:url
                         thumbImage:[ShareSDK jpegImageWithImage:
                                                  [UIImage imageNamed:@"icon"]
                                                         quality:1.0]
                              image:[ShareSDK jpegImageWithImage:
                                                  [UIImage imageNamed:@"icon"]
                                                         quality:1.0]
                       musicFileUrl:nil
                            extInfo:nil
                           fileData:nil
                       emoticonData:nil];
  //创建弹出菜单容器
  id<ISSContainer> container = [ShareSDK container];
  [container setIPadContainerWithView:nil
                          arrowDirect:UIPopoverArrowDirectionUp];

  id<ISSAuthOptions> authOptions =
      [ShareSDK authOptionsWithAutoAuth:YES
                          allowCallback:YES
                          authViewStyle:SSAuthViewStyleFullScreenPopup
                           viewDelegate:nil
                authManagerViewDelegate:_appDelegate.jhssViewDelegate];
  //隐藏sharesdk标识
  [authOptions setPowerByHidden:YES];
  //显示分享菜单
  [ShareSDK
      showShareViewWithType:typeTencent
                  container:container
                    content:publishContent
              statusBarTips:NO
                authOptions:authOptions
               shareOptions:
                   [ShareSDK defaultShareOptionsWithTitle:nil
                                          oneKeyShareList:nil
                                       cameraButtonHidden:NO
                                      mentionButtonHidden:NO
                                        topicButtonHidden:NO
                                           qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                   wxTimelineButtonHidden:NO
                                     showKeyboardOnAppear:NO
                                        shareViewDelegate:_appDelegate
                                                              .jhssViewDelegate
                                      friendsViewDelegate:_appDelegate
                                                              .jhssViewDelegate
                                    picViewerViewDelegate:nil]
                     result:^(ShareType type, SSResponseState state,
                              id<ISSPlatformShareInfo> statusInfo,
                              id<ICMErrorInfo> error, BOOL end) {

                       if (state == SSPublishContentStateSuccess) {
                         NSLog(NSLocalizedString(@"TEXT_SHARE_SUC",
                                                 @"发表成功"));
                         switch (type) {
                         case ShareTypeSinaWeibo: {
                           //新浪微博
                           [MPNotificationView
                               notifyWithText:@"新浪微博分享成功"
                                  andDuration:1.5];
                         } break;
                         case ShareTypeTencentWeibo: {
                           //腾讯微博
                           [MPNotificationView
                               notifyWithText:@"腾讯微博分享成功"
                                  andDuration:1.5];
                         } break;
                         case ShareTypeWeixiSession: {
                           //微信好友
                           [MPNotificationView
                               notifyWithText:@"微信好友分享成功"
                                  andDuration:1.5];
                         } break;
                         case ShareTypeWeixiTimeline: {
                           //朋友圈
                           [MPNotificationView
                               notifyWithText:@"朋友圈分享成功"
                                  andDuration:1.5];
                         } break;
                         case ShareTypeQQSpace: {
                           // qq空间
                           [MPNotificationView notifyWithText:@"QQ空间分享成功"
                                                  andDuration:1.5];
                         } break;
                         case ShareTypeQQ: {
                           // qq
                           [MPNotificationView notifyWithText:@"QQ分享成功"
                                                  andDuration:1.5];
                         } break;
                         default:
                           break;
                         }
                       } else if (state == SSPublishContentStateFail) {
                         NSLog(NSLocalizedString(@"TEXT_SHARE_FAI",
                                                 @"发" @"布失败!" @"error "
                                                 @"code == " @"%d, " @"error "
                                                 @"code == " @"%@"),
                               [error errorCode], [error errorDescription]);
                         switch (type) {
                         case ShareTypeSinaWeibo:
                           [MPNotificationView
                               notifyWithText:@"新浪微博分享失败"
                                  andDuration:1.5];
                           break;
                         case ShareTypeTencentWeibo:
                           [MPNotificationView
                               notifyWithText:@"腾讯微博分享失败"
                                  andDuration:1.5];
                           break;
                         case ShareTypeWeixiSession:
                           [MPNotificationView
                               notifyWithText:@"微信好友分享失败"
                                  andDuration:1.5];
                           break;
                         case ShareTypeWeixiTimeline:
                           [MPNotificationView
                               notifyWithText:@"朋友圈分享失败"
                                  andDuration:1.5];
                           break;
                         case ShareTypeQQ:
                           [MPNotificationView notifyWithText:@"QQ分享失败"
                                                  andDuration:1.5];
                           break;
                         case ShareTypeQQSpace:
                           [MPNotificationView notifyWithText:@"QQ空间分享失败"
                                                  andDuration:1.5];
                           break;
                         default:
                           break;
                         }
                         if ([error errorCode] == -24002) {
                           [NewShowLabel setMessageContent:@"未"
                                         @"安装QQ或QQ版本"
                                         @"过低，分享失" @"败"];
                         } else if ([error errorCode] == -22003) {
                           [NewShowLabel setMessageContent:@"未"
                                         @"安装微信或微信"
                                         @"版本过低，无法" @"分享"];
                         } else if ([error errorCode] == 20003) {
                           //账号被封
                           [NewShowLabel setMessageContent:@"您"
                                         @"的帐号存在异常"
                                         @"，暂时无法访问" @"。"];
                         } else
                           [NewShowLabel
                               setMessageContent:[error errorDescription]];
                         //界面导航栏还原
                       } else if (state == SSPublishContentStateBegan) {
                         NSLog(@"开始");
                       } else if (state == SSPublishContentStateCancel) {
                       }
                     }];
}
- (void)shareButtonInviteFriendCallbackMethod:(NSInteger)tag
                                          row:(NSInteger)row {
  if ([friendDataArr count] <= row) {
    return;
  }
  SuccessfullyInvitedList *invitedData = friendDataArr[row];
  if (!invitedData.userId) {
    return;
  }
  [HomepageViewController showWithUserId:invitedData.userId
                               titleName:invitedData.nickName
                                 matchId:@"1"];
  return;
}

#pragma mark------网络请求------
//已成功邀请好友列表请求
- (void)inviteFriendsListRequestBeenSuccessfully {
  @synchronized(self) {
    [self getInviteFriendsListRequestBeenSuccessfully];
  }
}
#pragma mark------------（1）接口修改------------
//已成功邀请好友列表请求
- (void)getInviteFriendsListRequestBeenSuccessfully {
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak InviteFriendViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    InviteFriendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    InviteFriendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindInvieFriendListWarpperData:(InvieFriendListWarpper *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  [InvieFriendListWarpper requestPositionDataWithCallback:callback];
}
/**数据绑定部分*/
- (void)bindInvieFriendListWarpperData:(InvieFriendListWarpper *)obj {
  for (SuccessfullyInvitedList *invitedData in obj.InvieFriendDataArray) {
    [friendDataArr addObject:invitedData];
  }
  [self refreshAttentionData];
}
/** 本地刷新关注数据状态 */
- (void)refreshAttentionData {
  NSArray *array = [[NSMutableArray alloc]
      initWithArray:[[MyAttentionInfo sharedInstance] getAttentionArray]];

  for (SuccessfullyInvitedList *currentItem in friendDataArr) {
    BOOL attentionStatus = 0;
    for (MyAttentionInfoItem *savedItem in array) {
      //遍历
      if ([currentItem.userId integerValue] ==
          [savedItem.userListItem.userId integerValue]) {
        attentionStatus = 1;
      }
    }
    if (attentionStatus == 1) {
      currentItem.flag = YES;
    } else {
      currentItem.flag = NO;
    }
  }
  //刷新关注信息
  if ([friendDataArr count] > 0) {
    [friendTableView reloadData];
    friendTableView.scrollEnabled = YES;
  }
}
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}
- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
}
#pragma mark----------end----------

#pragma mark 无网络
- (void)showMessage:(NSString *)message {
  [NewShowLabel setMessageContent:message];
}
//创建联网指示器
- (void)resetIndicatorView {
  [_indicatorView setButonIsVisible:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
