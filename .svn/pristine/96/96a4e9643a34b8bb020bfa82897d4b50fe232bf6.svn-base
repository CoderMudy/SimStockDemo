
//
//  simuACountVC.m
//  SimuStock
//
//  Created by Mac on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuACountVC.h"
#import "HomepageViewController.h"

@interface SimuACountVC () {
  BOOL myStockPosition;
}

@end

@implementation SimuACountVC

- (id)initWithFrame:(CGRect)frame
        withMatchId:(NSString *)marchId
         withUserID:(NSString *)userId
       withUserName:(NSString *)userName {
  if (self = [super initWithFrame:frame]) {
    self.matchId = marchId;
    self.userId = userId;
    self.userName = userName ? userName : @"暂无昵称";
    myStockPosition = [userId isEqualToString:[SimuUtil getUserID]];
    dataArray = [[DataArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];

  avatarUrl = nil;
  scvc_notselHeight = 90;
  [self creatAllController];

  //设置小牛，在创建tableView的地方重设frame
  [self.littleCattleView setInformation:@"暂无持仓"];
  [self.littleCattleView removeFromSuperview]; //先从self.view上移除

  [self.littleCattleView resetFrame:ssvc_postableview.bounds]; //位置偏上
  [ssvc_postableview addSubview:self.littleCattleView];
}

- (BOOL)dataBinded {
  return dataArray.dataBinded;
}
- (void)refreshButtonPressDown {
  [self initPageData];
}

#pragma mark
#pragma mark 创建控件
- (void)creatAllController {
  [self creatNameLable];
  [self creatAvatar];
  [self creatGainsView];
  [self creatRankView];
  [self creatTableView];
}

- (void)creatNameLable {

  //创建用户评级控件
  _userGradeView = [[UserGradeView alloc] initWithFrame:CGRectMake(50, 13, 260, 18)];
  _userGradeView.showOriginalPoster = NO;
  [self.view addSubview:_userGradeView];
}

- (void)creatAvatar {
  //用户头像
  //头像
  sttbv_headimageview =
      [[UIImageView alloc] initWithFrame:CGRectMake((51.0 - 35.0) / 2, (41.0 - 35.0) / 2, 35.0, 35.0)];
  [sttbv_headimageview setBackgroundColor:[Globle colorFromHexRGB:@"87c8f1"]];
  CALayer *layer = sttbv_headimageview.layer;
  [layer setBorderWidth:2.0f];
  [layer setBorderColor:[UIColor whiteColor].CGColor];
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:35.0 / 2];
  [self.view addSubview:sttbv_headimageview];
  [JhssImageCache setImageView:sttbv_headimageview
                       withUrl:avatarUrl
          withDefaultImageName:@"用户默认头像"];

  //设置用户头像按钮
  UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  avatarBtn.backgroundColor = [UIColor clearColor];
  avatarBtn.frame = CGRectMake((51.0 - 36.0) / 2, (41.0 - 36.0) / 2, 36.0, 36.0);
  [avatarBtn.layer setMasksToBounds:YES];
  avatarBtn.layer.cornerRadius = 36.0 / 2;
  UIImage *backImage = [UIImage imageNamed:@"比赛按钮高亮状态"];
  avatarBtn.alpha = 0.75;
  [avatarBtn setBackgroundImage:backImage forState:UIControlStateHighlighted];
  avatarBtn.tag = 1001;
  [avatarBtn addTarget:self
                action:@selector(showHomePage)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:avatarBtn];
}
//头像刷新
- (void)avatarRefresh {
  [JhssImageCache setImageView:sttbv_headimageview
                       withUrl:avatarUrl
          withDefaultImageName:@"用户默认头像"];
}

#pragma mark - 跳转至个人主页
- (void)showHomePage {
  [HomepageViewController showWithUserId:self.userId titleName:self.userName matchId:MATCHID];
}
//创建浮动盈亏
- (void)creatGainsView {
  //浮动盈亏控件
  sav_gainsView = [[SimuGainsView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 45)];
  [self.view addSubview:sav_gainsView];
}
//创建盈利利率排名
- (void)creatRankView {
  //盈利利率排名控件
  sav_rankView =
      [[[NSBundle mainBundle] loadNibNamed:@"SimuRankView" owner:self options:nil] firstObject];
  sav_rankView.frame = CGRectMake(0, 85, self.view.width, 97);
  [self.view addSubview:sav_rankView];
}
//创建表格
- (void)creatTableView {

  ssvc_postableview =
      [[UITableView alloc] initWithFrame:CGRectMake(0, sav_rankView.bottom, self.view.bounds.size.width,
                                                    self.view.bounds.size.height - sav_rankView.bottom)
                                   style:UITableViewStylePlain];
  ssvc_postableview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  ssvc_postableview.separatorStyle = UITableViewCellSeparatorStyleNone;
  ssvc_postableview.showsVerticalScrollIndicator = NO;
  ssvc_postableview.delegate = self;
  ssvc_postableview.dataSource = self;
  ssvc_postableview.bounces = NO;
  [self.view addSubview:ssvc_postableview];

  //初始化时未选中任何行
  scvc_selectedRow.row = -1;
  scvc_selectedRow.section = -1;
}

#pragma mark
#pragma mark 网络相关函数

//初始化信息
- (void)initPageData {
  [self showmyRank];
  [self getMyCounterInfo];
  [self getPosition];
  [self queryUserAccountInformationInterfacesAappointuid:self.userId matchID:self.matchId];
}
//我的排名接口
- (void)showmyRank {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuACountVC *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindRankInfo:(SimuRankPageData *)obj];
    }
  };
  [SimuRankPageData requestRankInfoWithUser:self.userId
                                withMatchId:self.matchId
                               withCallback:callback];
}
- (void)bindRankInfo:(SimuRankPageData *)rankInfo {
  [sav_rankView setPagedata:rankInfo];
}

//获得帐户信息
- (void)getMyCounterInfo {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuACountVC *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUserAccountData:(MatchUserAccountData *)obj];
    }
  };
  
  [UserAccountPageData requestAccountDataWithUserId:self.userId
                                        withMatchId:self.matchId
                                       withCallback:callback];
}

- (void)bindUserAccountData:(MatchUserAccountData *)data {
  //账户信息
  if (sav_gainsView) {
    [sav_gainsView setPagedata:data];
  }
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [self stopLoading];
  if (dataArray.dataBinded) {
    if (dataArray.array.count == 0) {
      [self.littleCattleView isCry:NO];
    } else {
      self.littleCattleView.hidden = YES; //数据已经绑定（==显示），隐藏小牛
    }
  } else {
    [self.littleCattleView isCry:YES]; //数据未绑定（==未显示），显示哭泣的无网络小牛
  }
}

- (void)stopLoading {
  if (_endRefreshCallBack) {
    _endRefreshCallBack();
  }
}

//取得持仓情况
- (void)getPosition {
  if (_beginRefreshCallBack) {
    _beginRefreshCallBack();
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuACountVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindPositionList:(SimuRankPositionPageData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  
  [SimuRankPositionPageData requestPositionDataWithUid:self.userId
                                           withMatchId:self.matchId
                                            withReqnum:@"-1"
                                            withFormid:@"0"
                                          withCallback:callback];
}

- (void)bindPositionList:(SimuRankPositionPageData *)obj {

  //设置数据已经绑定
  dataArray.dataBinded = YES;

  [dataArray.array removeAllObjects];

  //添加最新数据
  [dataArray.array addObjectsFromArray:obj.positionList];

  //获取持仓比率
  ssvc_curposition = obj.positionRate;

  dataArray.dataComplete = YES;

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [self.littleCattleView isCry:NO];
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    self.littleCattleView.hidden = YES;
  }

  //重新加载数据
  [ssvc_postableview reloadData];
}

//查询用户账户信息接口
- (void)queryUserAccountInformationInterfacesAappointuid:(NSString *)appointuid
                                                 matchID:(NSString *)matchID {

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuACountVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuACountVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindHomeUserInformationData:(HomeUserInformationData *)obj];
    }
  };
  [HomeUserInformationData requestUserInfoWithUid:appointuid withCallback:callback];
}

- (void)bindHomeUserInformationData:(HomeUserInformationData *)informationData {

  if (informationData.headPic) {
    avatarUrl = informationData.headPic;
  } else {
    avatarUrl = nil;
  }
  [self avatarRefresh];

  [_userGradeView bindUserListItem:informationData.userListItem isOriginalPoster:NO];
}

#pragma mark
#pragma mark UITableViewDataSource
//表格组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
//各个组行个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (0 == section) {
    return [dataArray.array count];
  }
  return 0;
}
//头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (0 == section) {
    return 49.0 / 2;
  }
  return 0;
}
//各个组里行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (scvc_selectedRow.section != 0) {
      return scvc_notselHeight;
    } else {
      if (indexPath.row == scvc_selectedRow.row) {
        //当前选中行高度
        return [self heightOfSelectedRow];
      } else {
        //非当前选中行高度
        return scvc_notselHeight;
      }
    }
  }
  return 90.0 / 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (0 == section) {
    //模拟帐户信息头视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 49 / 2)];
    view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
    //帐户模拟信息标签
    UILabel *moniLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 49 / 2)];
    moniLable.backgroundColor = [UIColor clearColor];
    moniLable.font = [UIFont systemFontOfSize:Font_Height_12_0];
    moniLable.text = @"当前持仓股票";
    moniLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    moniLable.textAlignment = NSTextAlignmentLeft;
    [view addSubview:moniLable];
    UILabel *ssvc_positionLable =
        [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 0, 100, 49 / 2)];
    ssvc_positionLable.backgroundColor = [UIColor clearColor];
    ssvc_positionLable.font = [UIFont systemFontOfSize:Font_Height_12_0];
    if (ssvc_curposition) {
      ssvc_positionLable.text = [NSString stringWithFormat:@"仓位：%@", ssvc_curposition];
    } else {
      ssvc_positionLable.text = @"仓位：";
    }
    ssvc_positionLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    ssvc_positionLable.textAlignment = NSTextAlignmentLeft;
    [view addSubview:ssvc_positionLable];
    return view;
  }
  return Nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    //创建持仓表格项目
    static NSString *identifier = @"PosttionTableViewCell";
    PosttionTableViewCell *cell =
        (PosttionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      cell = [[PosttionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
      PositionInfoView *infoView = [[PositionInfoView alloc] initWithUserId:self.userId
                                                                withMatchId:self.matchId
                                                                  withFrame:cell.bounds];
      if (myStockPosition) {
        [infoView createButton];
        infoView.buyStockAction = self.buyStockAction;
        infoView.sellStockAction = self.sellStockAction;
      }
      cell.positionView = infoView;
      [cell addSubview:infoView];
    }
    [self setPositionItem:cell IndexPath:indexPath];
    return cell;
  }
  return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section != 0)
    return;

  PosttionTableViewCell *cell = (PosttionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  PositionInfoView *view = cell.positionView;
  if (indexPath.section == scvc_selectedRow.section && indexPath.row == scvc_selectedRow.row) {
    [tableView beginUpdates];
    if (view)

      [view presentForPosition:scvc_notselHeight];

    scvc_selectedRow.row = -1;
    scvc_selectedRow.section = -1;
    [tableView endUpdates];
  } else {
    [tableView beginUpdates];
    if (scvc_selectedRow.row != -1 && scvc_selectedRow.section != -1) {
      PosttionTableViewCell *cell = (PosttionTableViewCell *)
          [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:scvc_selectedRow.row
                                                              inSection:scvc_selectedRow.section]];
      PositionInfoView *presentview = cell.positionView;
      if (presentview) {
        if (indexPath.section == 0) {
          [presentview presentForPosition:scvc_notselHeight]; // present
        }
      }
    }
    scvc_selectedRow.row = indexPath.row;
    scvc_selectedRow.section = indexPath.section;
    if (view) {
      //当前选中行高度
      [view present:self.heightOfSelectedRow];
    }
    [tableView endUpdates];
  }
}
- (CGFloat)heightOfSelectedRow {
  return myStockPosition ? PositionHeight : 180;
}

- (void)setPositionItem:(PosttionTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {

  CGRect rect;
  if (indexPath.section == scvc_selectedRow.section && indexPath.row == scvc_selectedRow.row) {
    rect = CGRectMake(0, 0, self.view.width, self.heightOfSelectedRow);
    cell.positionView.triangleImage.hidden = YES;
  } else {
    rect = CGRectMake(0, 0, self.view.width, scvc_notselHeight);
    cell.positionView.triangleImage.hidden = NO;
  }
  NSString *user_id = [SimuUtil getUserID];
  if (user_id) {
    if (myStockPosition) {
      [cell.positionView setPosition:dataArray.array[indexPath.row] withFrame:rect withTraceFlag:0];
    } else {
      [cell.positionView setPosition:dataArray.array[indexPath.row]
                           withFrame:rect
                       withTraceFlag:-1];
    }
  }
}

@end

@implementation SimuMacthAccountVC

- (id)initWithMatchId:(NSString *)marchId
           withUserID:(NSString *)userId
         withUserName:(NSString *)userName
            withTitle:(NSString *)titleName {
  if (self = [super init]) {
    self.matchId = marchId;
    self.userId = userId;
    self.userName = userName ? userName : @"暂无昵称";
    self.titleName = titleName;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetToolBar];
  CGRect frame = CGRectMake(0, 0, _clientView.width, _clientView.height - BOTTOM_TOOL_BAR_HEIGHT);
  self.accountVC = [[SimuACountVC alloc] initWithFrame:frame
                                           withMatchId:self.matchId
                                            withUserID:self.userId
                                          withUserName:self.userName];
  self.accountVC.buyStockAction = self.buyStockAction;
  self.accountVC.sellStockAction = self.sellStockAction;
  __weak SimuMacthAccountVC *weakSelf = self;
  self.accountVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  self.accountVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  self.indicatorView.hidden = NO;

  [self addChildViewController:_accountVC];
  [_clientView addSubview:_accountVC.view];
  if (!self.accountVC.dataBinded) {
    [self.accountVC refreshButtonPressDown];
  }
}

- (void)refreshButtonPressDown {
  [self.accountVC refreshButtonPressDown];
}

- (void)resetToolBar {
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
}

@end
