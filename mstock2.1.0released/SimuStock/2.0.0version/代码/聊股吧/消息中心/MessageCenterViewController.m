//
//  MessageCenterView.m
//  SimuStock
//
//  Created by moulin wang on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "VipSectionViewController.h"
// UI部分
//网络部分
//加密转码
#import "MessageCenterCoreDataUtil.h"
//二级界面
#import "MessageListViewController.h"
#import "MessageSystemViewController.h"        //系统消息
#import "StockPriceRemindListViewController.h" //股票提醒
#import "AdvancedVIPVC.h"
//#import "TraceMessageViewController.h"
#import "GetUserVIPType.h"
#import "MessageCenterTableViewCell.h"

@implementation MessageCenterViewController

- (id)init {
  if (self = [super init]) {
    rowIndexToMessageType = @[ @2, @1, @3, @4, @5, @6, @7 ];
    _dataMap = @{
      @0 : @{
        @"ranklist" : @"VIP专区",
        @"icon" : @"vip专区小图标",
        @"noticeKeys" : @(MessageTypeVip),
      },
      @2 : @{@"ranklist" : @"@我的", @"icon" : @"@我的", @"noticeKeys" : @(MessageTypeAtMe)},
      @3 : @{
        @"ranklist" : @"评论了我",
        @"icon" : @"评论小图标",
        @"noticeKeys" : @(MessageTypeComment)
      },
      @4 : @{
        @"ranklist" : @"关注了我",
        @"icon" : @"关注小图标",
        @"noticeKeys" : @(MessageTypeAttention)
      },
      @5 : @{@"ranklist" : @"赞了我", @"icon" : @"赞小图标", @"noticeKeys" : @(MessageTypePraise)},
      @6 : @{
        @"ranklist" : @"系统消息",
        @"icon" : @"系统通知小图标",
        @"noticeKeys" : @(MessageSystemType)
      },
      @7 : @{
        @"ranklist" : @"股票提醒",
        @"icon" : @"股价提醒小图标1",
        @"noticeKeys" : @(MessageTypeStockWarning)
      },
    };

    self.mesCenterArray = @[
      @"高级VIP专区",
      @"@我的",
      @"评论了我",
      @"关注了我",
      @"赞了我",
      @"系统消息",
      @"股票提醒"
    ];
    unReadNoticeNums = [@{} mutableCopy];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**为接受消息推送做预处理*/
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  /**读取本地缓存*/
  [self readUserDef];
}

- (void)leftButtonPress {
  [super leftButtonPress];
  [UserBpushInformationNum resetUnReadAllCount];
  ///更新未读消息
  [UserBpushInformationNum requestUnReadStaticData];
}

- (void)readUserDef {

  [unReadNoticeNums removeAllObjects];
  UserBpushInformationNum *savedCount = [UserBpushInformationNum getUnReadObject];
  for (int i = 0; i < rowIndexToMessageType.count; i++) {
    NSNumber *messageType = rowIndexToMessageType[i];
    YLBpushType bpushType = [messageType intValue];
    NSInteger value = [savedCount getCount:bpushType];
    unReadNoticeNums[@(i)] = [@(value) stringValue];
  }
  NSLog(@"unReadnoticeNums:%@", unReadNoticeNums);
  [mesCenterTableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_topToolBar resetContentAndFlage:@"消息中心" Mode:TTBM_Mode_Leveltwo];

  _indicatorView.hidden = YES;
  //数组分配数据

  //创建表格
  [self createTableView];
  //通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(roadTableView)
                                               name:MessageCenterNotification
                                             object:nil];
}
/**通知刷新方法*/
- (void)roadTableView {
  //读取本地缓存
  [self readUserDef];
}

#pragma mark------------（1）UI部分------------
/**创建表格*/
- (void)createTableView {
  //表格
  CGRect frame = self.view.frame;
  mesCenterTableView =
      [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - _topToolBar.frame.size.height)];
  mesCenterTableView.delegate = self;
  mesCenterTableView.dataSource = self;
  mesCenterTableView.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  mesCenterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:mesCenterTableView];
}
#pragma mark------------UI部分end------------

#pragma mark----------（2）表格协议部分----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_dataMap count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1) {
    return 10;
  } else
    return 48.0f;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1) {
    cell.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  } else
    cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ideCell = @"MessageCenterTableViewCell";
  MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideCell];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (cell == nil && indexPath.row != 1) {
    cell = [[[NSBundle mainBundle] loadNibNamed:ideCell owner:self options:nil] lastObject];
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    backView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
    backView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = backView;
  }

  if (indexPath.row == 0) {
    cell.topLineView.hidden = YES;
  } else {
    cell.topLineView.hidden = NO;
  }

  NSDictionary *dic = _dataMap[@(indexPath.row)];
  if (dic) {
    cell.contentLabel.text = dic[@"ranklist"];
    cell.headerImage.image = [UIImage imageNamed:dic[@"icon"]];
    /**----------小红点CoreData部分----------*/
    YLBpushType bpushType = [_dataMap[@(indexPath.row)][@"noticeKeys"] intValue];
    UserBpushInformationNum *savedCount = [UserBpushInformationNum getUnReadObject];
    NSInteger value = [savedCount getCount:bpushType];
    if (bpushType == UserfollowCount) {
      [cell setUnReadDot:value];
    } else {
      [cell setUnReadMessageNum:value];
    }

  } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blackCell"];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 10)];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
  }
  [cell.topLineView resetViewWidth:tableView.width];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //去除中间透明的cell
  if (indexPath.row == 1) {
    return;
  }
  NSDictionary *dic = _dataMap[@(indexPath.row)];
  if (dic) {
    //改变红点
    YLBpushType bpushType = [_dataMap[@(indexPath.row)][@"noticeKeys"] intValue];
    [UserBpushInformationNum clearUnReadCountWithMessageType:bpushType];
    if (indexPath.row == 0) {
      [self pushToSuperVIPVC];
    }

    //    if (indexPath.row == 2) {
    //      //追踪消息
    //      TraceMessageViewController *traceMsgView =
    //          [[TraceMessageViewController alloc] init];
    //      [AppDelegate pushViewControllerFromRight:traceMsgView];
    //    }

    if (indexPath.row <= 5 && indexPath.row >= 2) {
      NSLog(@"dddd:%ld,%ld", (long)indexPath.row, (long)_dataMap.count);
      MessageListViewController *callMeView = [[MessageListViewController alloc] initWithType:(int)bpushType];
      [AppDelegate pushViewControllerFromRight:callMeView];
    } else if (indexPath.row == 6) {
      //系统消息
      MessageSystemViewController *systemView = [[MessageSystemViewController alloc] init];
      [AppDelegate pushViewControllerFromRight:systemView];
    } else if (indexPath.row == 7) {
      StockPriceRemindListViewController *stockPriceListView =
          [[StockPriceRemindListViewController alloc] init];
      [AppDelegate pushViewControllerFromRight:stockPriceListView];
    }
    //刷新行
    [mesCenterTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
  }
}
- (void)pushToSuperVIPVC {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MessageCenterViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf bindVIPType:(GetUserVIPType *)obj];
  };
  [GetUserVIPType getUserVipTypeWithCallback:callback];
}

- (void)bindVIPType:(GetUserVIPType *)obj {
  if (obj.vipType == SVipUser) {
    VipSectionViewController *vipSectionVC = [[VipSectionViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:vipSectionVC];
  } else {
    NSString *textUrl = [wap_address stringByAppendingFormat:@"/mobile/member/"];
    [SchollWebViewController startWithTitle:@"VIP专区" withUrl:textUrl];
  }
}

#pragma mark------------UI部分end------------

#pragma mark------------（3）代理方法--（点击刷新）进入刷新状态就会调用------------
//无网络提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}
//停止菊花
- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
}
@end
