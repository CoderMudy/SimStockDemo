//
//  StockNewsListTableViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockNewsListTableViewController.h"
#import "NewsChannelList.h"
#import "ChannelNewsItemTableViewCell.h"
#import "StockInformationWebViewController.h"

@implementation StockNewsListTableAdapter

- (NSString*)nibName {
  static NSString* nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([ChannelNewsItemTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForRowAtIndexPath:(NSIndexPath*)indexPath {
  return 51.0f;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  ChannelNewsItemTableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [cell bindNewsInChannelItem:self.dataArray.array[indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  ChannelNewsItemTableViewCell* cell = (ChannelNewsItemTableViewCell*)
      [tableView cellForRowAtIndexPath:indexPath];
  //注销cell单击事件
  cell.selected = NO;
  //取消选中项
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]
                           animated:YES];
  if ([self.dataArray.array count] <= indexPath.row)
    return;

  NewsInChannelItem* hero = self.dataArray.array[indexPath.row];
  StockNewsListTableViewController* owner =
      (StockNewsListTableViewController*)self.baseTableViewController;
  StockInformationWebViewController* webVc =
      [[StockInformationWebViewController alloc] init];
  webVc.textUrl = hero.url;
  webVc.textName = owner.channalName;
  webVc.infoTitle = hero.title;
  [AppDelegate pushViewControllerFromRight:webVc];
}

@end

@implementation StockNewsListTableViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray*)existDataList
                          withCallBack:(HttpRequestCallBack*)callback {
  [NewsListInChannel requestNewsListWithInputParmeters:
                         [self getRequestParamertsWithRefreshType:refreshType]
                                          withCallBack:callback];
}

- (NSDictionary*)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString* fromId = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    NewsInChannelItem* item = [self.dataArray.array lastObject];
    fromId = [@(item.id2) stringValue];
  }

  return @{ @"fromId" : fromId, @"limit" : @"20", @"cid" : _channalId };
};

- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable>*)latestData
                withRequestParameters:(NSDictionary*)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NewsInChannelItem* item = [self.dataArray.array lastObject];
    NSString* fromId = [@(item.id2) stringValue];
    if (![fromId isEqualToString:parameters[@"fromId"]]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter*)getBaseTableAdaperWithDataList:(DataArray*)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockNewsListTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib* cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (id)initWithFrame:(CGRect)frame
      withChannelID:(NSString*)channalId
    withChannelName:(NSString*)channalName {
  if (self = [super initWithFrame:frame]) {
    self.channalId = channalId;
    self.channalName = channalName;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
  ///菊花
  [self creatWithotherViews];
}

///判断网络请求结束以后,判断当前界面是否有数据
-(void)IsWhetherHaveData:(DataArray *)array
{ ///父类继承，重写用,(不是一定要继承的）
  _nwv_fullbaseView.hidden=YES;

}

//创建视图
- (void)creatWithotherViews {
  _nwv_fullbaseView = [[UIView alloc]initWithFrame:self.view.bounds];
  [self.view addSubview:_nwv_fullbaseView];
  [self.view bringSubviewToFront:_nwv_fullbaseView];
  _nwv_fullbaseView.clipsToBounds=YES;
  _nwv_fullbaseView.layer.masksToBounds=YES;
  //创建旋转图片背景
  UIView *backgroundView =
  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 69, 69)];
  backgroundView.backgroundColor = [UIColor blackColor];
  backgroundView.center = _nwv_fullbaseView.center;
  backgroundView.alpha = 0.7;
  CALayer *layer = backgroundView.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:10.0];
  [_nwv_fullbaseView addSubview:backgroundView];
  
  //活动指示器
  indicator = [[UIActivityIndicatorView alloc]
               initWithFrame:CGRectMake(15, 15, 40, 40)];
  indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  indicator.center = _nwv_fullbaseView.center;
  [_nwv_fullbaseView addSubview:indicator];
  [indicator startAnimating];
}


@end
