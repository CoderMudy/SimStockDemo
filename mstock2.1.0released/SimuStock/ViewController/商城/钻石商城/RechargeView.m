//
//  RechargeView.m
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RechargeView.h"
#import "Globle.h"

@implementation RechargeView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    rcv_dataArray = [[NSMutableArray alloc] init];
    [self creatTableView];
  }
  return self;
}
- (void)dealloc {
  rcv_tableview.delegate = nil;
  rcv_tableview.dataSource = nil;
}

- (void)creatTableView {
  rcv_tableview = [[UITableView alloc] initWithFrame:self.bounds];
  [self addSubview:rcv_tableview];
  rcv_tableview.delegate = self;
  rcv_tableview.dataSource = self;
  rcv_tableview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  rcv_tableview.separatorStyle = UITableViewCellAccessoryNone;
  rcv_tableview.allowsSelection = NO;
}

#pragma mark
#pragma mark 对外接口
- (void)resetpagedata:(NSMutableArray *)array {

  if (array == nil)
    return;
  [rcv_dataArray removeAllObjects];
  [rcv_dataArray addObjectsFromArray:array];
  [rcv_tableview reloadData];
}

#pragma mark
#pragma mark UITableViewDelegate 协议
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52.5;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
#pragma mark
#pragma mark UITableViewDataSource 协议
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (rcv_dataArray)
    return [rcv_dataArray count];
  else
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"DiamondRechargeCell";
  DiamondRechargeCell *cell =
      (DiamondRechargeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"DiamondRechargeCell" owner:self options:nil] firstObject];
    cell.delegate = self;
    cell.bounds = CGRectMake(0, 0, self.bounds.size.width, 52.5);
  }
  if (rcv_dataArray) {
    TrackCardInfo *Item = rcv_dataArray[indexPath.row];
    [cell setCellData:Item];
  }

  return cell;
}

#pragma mark
#pragma mark RechargeCellDelegate

- (void)buyButtonPressDown:(NSString *)productid {
  if (productid == nil)
    return;
  if ([productid length] == 0)
    return;

  if (_delegate) {
    [_delegate buyButtonPressDown:productid];
  }
}

@end
