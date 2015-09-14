//
//  MyChestsListViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChestsViewController.h"
#import "MobClick.h"
#import "MyPropsListCell.h"
#import "MyChestsTableHeaderView.h"
#import "MyChestsListWrapper.h"
#import "WeiboToolTip.h"

@implementation MyChestsTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MyPropsListCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MyPropsListCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  MyPropsListItem *item = self.dataArray.array[indexPath.row];
  [cell setData:item];
  __weak MyChestsTableAdapter *weakSelf = self;
  [cell.usingButton setOnButtonPressedHandler:^{
    MyChestsTableAdapter *strongSelf = weakSelf;
    [WeiboToolTip showMakeSureWithTitle:@"提示"
        largeContent:[NSString stringWithFormat:@"您确定要使用%@",
                                                item.mPboxName]
        lineSpacing:0
        contentTopSpacing:20
        contentBottomSpacing:20
        sureButtonTitle:nil
        cancelButtonTitle:nil
        sureblock:^{
          [strongSelf userProductWithDiamondsFromNet:item.mPboxID
                                       withMPboxType:item.mPboxType];
        }
        cancleblock:^{
            //
        }];
  }];

  return cell;
}

#pragma mark----------使用商品（钻石商城新接口）----------
- (void)userProductWithDiamondsFromNet:(NSString *)producteID
                         withMPboxType:(NSString *)mPboxType {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyChestsTableAdapter *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyChestsTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyChestsTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf
          bindMyChestUsePropsListWrapper:(MyChestsUsePropslistListWrapper *)
                                             obj];
      [strongSelf resetUserVipTypeWithMPboxType:mPboxType];
    }
  };
  [MyChestsUsePropslistListWrapper
      requestPositionDataWithGetAK:[SimuUtil getAK]
                     withGetUserID:[SimuUtil getUserID]
                   withGetUserName:
                       [CommonFunc base64StringFromText:[SimuUtil getUserName]]
                withClickedPropsID:producteID
                      withCallback:callback];
}

/**重置用户vipType*/
- (void)resetUserVipTypeWithMPboxType:(NSString *)mPboxType {
  if ([mPboxType isEqualToString:@"D040000"] ||
      [mPboxType isEqualToString:@"L160000"]) {
    [SimuUtil setUserVipType:@"1"];
  } else {
    // do nothing
  }
}

/**使用商品（钻石商城新接口）数据绑定*/
- (void)bindMyChestUsePropsListWrapper:(MyChestsUsePropslistListWrapper *)obj {
  //道具使用成功
  //道具使用成功后，更新宝箱物品
  //钻石兑换商品成功
  UIAlertView *alartView =
      [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                 message:obj.UsePropsdataArray[0]
                                delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil];
  [alartView show];
  [self.baseTableViewController refreshButtonPressDown];
}

@end

/*
 *  list
 */
@implementation MyChestsListViewController

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.showTableFooter = YES;
  [self.littleCattleView setInformation:@"暂时还没有未使用的道具"];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MyChestsMyChestlistListWrapper requestPositionDataWithCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];

  //显示金币数量
  MyChestsMyChestlistListWrapper *wrapper =
      (MyChestsMyChestlistListWrapper *)latestData;
  //剩余钻石
  NSString *diamondAStr =
      [NSString stringWithFormat:@"钻石：%@", wrapper.result];
  ((MyChestsViewController *)_superVC)
      .chestsHeader.diamondLabel.attributedText =
      [SimuUtil attributedString:diamondAStr
                           color:[Globle colorFromHexRGB:@"#d77e0a"]
                           range:NSMakeRange(3, [diamondAStr length] - 3)];

  //剩余金币
  NSString *coinsAStr = [NSString stringWithFormat:@"金币：%@", wrapper.coins];
  ((MyChestsViewController *)_superVC).chestsHeader.glodLabel.attributedText =
      [SimuUtil attributedString:coinsAStr
                           color:[Globle colorFromHexRGB:@"#d77e0a"]
                           range:NSMakeRange(3, [coinsAStr length] - 3)];

  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyChestsTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

@end

/*
 *  base
 */
@implementation MyChestsViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"商城-我的宝箱"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"商城-我的宝箱"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"我的宝箱" Mode:TTBM_Mode_Leveltwo];
  [self createChestsHeader];
  [self createTableVC];
  [self refreshButtonPressDown];
}

- (void)createChestsHeader {
  _chestsHeader =
      [[[NSBundle mainBundle] loadNibNamed:@"MyChestsTableHeaderView"
                                     owner:self
                                   options:nil] firstObject];
  _chestsHeader.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 33);
  [self.clientView addSubview:_chestsHeader];
}

- (void)createTableVC {
  __weak MyChestsViewController *weakSelf = self;
  _tableVC = [[MyChestsListViewController alloc]
      initWithFrame:CGRectMake(0, 33, WIDTH_OF_SCREEN,
                               _clientView.height - 33)];
  _tableVC.superVC = self;
  _tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [self.clientView addSubview:_tableVC.view];
  [self addChildViewController:_tableVC];
}

- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  [_tableVC refreshButtonPressDown];
}

@end
