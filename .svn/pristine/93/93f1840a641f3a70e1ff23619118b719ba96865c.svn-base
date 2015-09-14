//
//  PropListForReviewTableVC.m
//  SimuStock
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PropListForReviewTableVC.h"
#import "ShoppingMallListCell.h"
#import "CacheUtil.h"

@implementation PropListForReviewTableAdapter

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"ShoppingMallListCell";
  ShoppingMallListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
    cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [cell resetView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  //两栏分开考虑
  TrackCardInfo *item = self.dataArray.array[indexPath.row];
  __weak PropListForReviewTableAdapter *weakSelf = self;
  [cell.cardDetailButton setOnButtonPressedHandler:^{
    [weakSelf.owner detail:item.detail];
  }];
  [cell.cardBuyingButton setOnButtonPressedHandler:^{
    [weakSelf.owner.propBuyDelegate buyButtonPressDown:item.CardID];
  }];

  [cell bindTrackCardInfo:item];
  return cell;
}

- (PropListForReviewTableVC *)owner {
  return (PropListForReviewTableVC *)self.baseTableViewController;
}

@end

@implementation PropListForReviewTableVC

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  //先读取缓存
  if (!self.dataBinded) {
    PropListForReview *currentProductList = [CacheUtil loadPropListForReview];
    if (currentProductList && currentProductList.dataArray.count > 0) {
      [self bindRequestObject:currentProductList
          withRequestParameters:@{
            @"saveToCache" : @NO
          } withRefreshType:RefreshTypeRefresh];
    }
  }
  [PropListForReview requestPropListForAppleReviewWithCallback:callback];
}


/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[PropListForReviewTableAdapter alloc] initWithTableViewController:self
                                                                         withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if (parameters == nil && ((PropListForReview *)latestData).dataArray.count > 0) {
    [CacheUtil savePropListForReview:(PropListForReview *)latestData];
  }

  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
}

@end
