//
//  PropListTableVC.m
//  SimuStock
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PropListTableVC.h"
#import "ShoppingMallListCell.h"
#import "CacheUtil.h"
#import "event_view_log.h"

@implementation PropListTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 110;
}
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
  ProductListItem *item = self.dataArray.array[indexPath.row];
  __weak PropListTableAdapter *weakSelf = self;
  [cell.cardDetailButton setOnButtonPressedHandler:^{
    [weakSelf.owner detail:item.mDetail];
  }];
  [cell.cardBuyingButton setOnButtonPressedHandler:^{
    [weakSelf buyingWithDiamonds:item];
  }];

  [cell bindProduct:item];
  return cell;
}

- (PropListTableVC *)owner {
  return (PropListTableVC *)self.baseTableViewController;
}

//使用钻石兑换商品
- (void)buyingWithDiamonds:(ProductListItem *)item {
  [self.owner.storeUtil buyProductWithDiamonds:item];
}

@end

@implementation PropListTableVC

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  //先读取缓存
  if (!self.dataBinded) {
    ProductList *currentProductList = [CacheUtil loadProductList];
    if (currentProductList && currentProductList.dataArray.count > 0) {
      [self bindRequestObject:currentProductList
          withRequestParameters:@{
            @"saveToCache" : @NO
          } withRefreshType:RefreshTypeRefresh];
    }
  }
  [ProductList requestProductListWithCatagories:@"D020000,D030000,D010000,D040000"
                                   withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[PropListTableAdapter alloc] initWithTableViewController:self
                                                                withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (id)initWithFrame:(CGRect)frame withCommodityType:(CommodityType)commodityType {
  if (self = [super initWithFrame:frame]) {
    _commodityType = commodityType;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
  self.littleCattleView.hidden = YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if (parameters == nil && ((ProductList *)latestData).dataArray.count > 0 &&
      [latestData isKindOfClass:[ProductList class]]) {
    [CacheUtil saveProductList:(ProductList *)latestData];
  }
  NSMutableArray *array = [[NSMutableArray alloc] init];
  [latestData.getArray enumerateObjectsUsingBlock:^(ProductListItem *item, NSUInteger idx, BOOL *stop) {
    if (_commodityType == CommodityTypeFundCard && [item isFundCard]) {
      [array addObject:item];
    } else if (_commodityType == CommodityTypeProp && [item isProp]) {
      [array addObject:item];
    }
  }];

  ((ProductList *)latestData).dataArray = array;

  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

#pragma mark
#pragma mark-------------------------按钮事件----------------------------
- (void)detail:(NSString *)commondityDetail {
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  //给详情设置个起始位置
  if (detailBackgroundView == nil) {
    detailBackgroundView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.size.width, window.size.height)];
    detailBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  }
  [window addSubview:detailBackgroundView];
  detailBackgroundView.alpha = 1.0;
  //白底
  if (whiteView == nil) {
    whiteView =
        [[UIImageView alloc] initWithFrame:CGRectMake(8, 45 - window.size.height + 2, window.size.width - 16,
                                                      window.size.height - 45 - 45 - 4)];
  }

  for (UIView *obj in [whiteView subviews]) {
    [obj removeFromSuperview];
  }
  //扩展底图
  UIImage *whiteImage = [UIImage imageNamed:@"di"];
  //设置图片拉伸区域
  whiteImage = [whiteImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 154, 12, 154)
                                          resizingMode:UIImageResizingModeStretch];

  //弹动视图效果设计
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  whiteView.frame = CGRectMake(8, 20 + 45 + 5, window.size.width - 16, window.size.height - 45 - 45 - 4);
  [UIView commitAnimations];

  [whiteView setImage:whiteImage];
  whiteView.userInteractionEnabled = YES;
  [detailBackgroundView addSubview:whiteView];

  //使用说明
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, whiteView.width, 17)];
  titleLabel.textColor = [UIColor lightGrayColor];
  titleLabel.backgroundColor = [UIColor clearColor];
  // clang-format off
  titleLabel.text = @"···················· 使用说明 ····················";
  // clang-format on
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  titleLabel.font = [UIFont systemFontOfSize:17];
  [whiteView addSubview:titleLabel];

  //吊环
  UIImageView *imageView =
      [[UIImageView alloc] initWithFrame:CGRectMake((whiteView.width - 37) / 2, -64, 37, 81)];
  imageView.image = [UIImage imageNamed:@"线"];
  [whiteView addSubview:imageView];

  //取消按钮
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.frame = CGRectMake(whiteView.width - 25 - 10, 10, 25, 25);
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"关闭按下"]
                          forState:UIControlStateHighlighted];
  [whiteView addSubview:cancelButton];
  [cancelButton addTarget:self
                   action:@selector(cancel)
         forControlEvents:UIControlEventTouchUpInside];

  //详情label
  //设定内容
  CGFloat margin = (WIDTH_OF_SCREEN - 320) / 8 + 16;
  UITextView *temp_textview =
      [[UITextView alloc] initWithFrame:CGRectMake(margin, 88, whiteView.width - margin * 2, 280)];
  temp_textview.textColor = [UIColor blackColor];
  temp_textview.font = [UIFont fontWithName:FONT_ARIAL size:15.0];
  temp_textview.backgroundColor = [UIColor clearColor];
  [whiteView addSubview:temp_textview];
  temp_textview.scrollEnabled = YES; //
  temp_textview.editable = NO;
  temp_textview.scrollsToTop = YES;
  temp_textview.autoresizingMask = UIViewAutoresizingFlexibleHeight;

  //判断哪一栏
  CGSize size = [commondityDetail sizeWithFont:temp_textview.font
                             constrainedToSize:CGSizeMake(temp_textview.width, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByCharWrapping];
  temp_textview.height = size.height + 60;
  temp_textview.text = commondityDetail;
  temp_textview.textColor = [Globle colorFromHexRGB:@"454545"];
  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"143"];
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"商城-详情"];
}

- (void)cancel {
  //弹动视图效果设计
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.4];
  whiteView.frame = CGRectMake(8, 45 - self.view.bounds.size.height, WIDTH_OF_SCREEN - 16, 402);
  detailBackgroundView.alpha = 0.0;
  [detailBackgroundView removeFromSuperview];
  [UIView commitAnimations];
}

@end
