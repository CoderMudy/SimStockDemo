//
//  PraiseTableViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PraiseTableViewController.h"
#import "WBPrasieCell.h"
#import "HomepageViewController.h"

@implementation PraiseTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([WBPrasieCell class]);
  }
  return nibFileName;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 56.0f;
}
///点击跳转进入对应的个人主页
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  PraiseList *item = self.dataArray.array[indexPath.row];
  [HomepageViewController showWithUserId:[item.writer.userId stringValue]
                               titleName:item.writer.nickName
                                 matchId:MATCHID];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  WBPrasieCell *cell = (WBPrasieCell *)
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  //选中效果
  UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
  cell.selectedBackgroundView = backView;
  cell.selectedBackgroundView.backgroundColor =
      [Globle colorFromHexRGB:@"d9d9d9"];

  PraiseList *item = self.dataArray.array[indexPath.row];
  [cell bindPraiseList:item];
  return cell;
}

@end

@implementation PraiseTableViewController {
  NSInteger start;
}
- (id)initWithFrame:(CGRect)frame withtTalkId:(NSNumber *)talkId {
  if (self = [super initWithFrame:frame]) {
    _talkId = talkId;
  }
  return self;
}

/** 将入参封装成一个dic */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"0";
  NSString *endId = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    PraiseList *lastItem = [self.dataArray.array lastObject];
    startId = [lastItem.seq stringValue];
  }
  NSDictionary *dic = @{
    @"tweetId" : [_talkId stringValue],
    @"fromId" : startId,
    @"reqNum" : endId
  };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    PraiseList *lastItem = [self.dataArray.array lastObject];
    NSString *lastId = [lastItem.seq stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [PraiseList getPraiseListsWithTweetDic:
                  [self getRequestParamertsWithRefreshType:refreshType]
                            withCallback:callback];
}
/** 绑定数据（调用默认的绑定方法），首先判断是否有效 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    [super bindRequestObject:latestData
        withRequestParameters:parameters
              withRefreshType:refreshType];

    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 0;
    }
  }
}
/** 返回表格适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[PraiseTableAdapter alloc] initWithTableViewController:self
                                                  withDataArray:self.dataArray];
    UINib *cellNIb = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNIb
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.littleCattleView setInformation:@"快来赞一个！"];
  [self.littleCattleView
      resetFrame:CGRectMake(0, 0, self.view.size.width, 260)];

  // Do any additional setup after loading the view.
}

@end
