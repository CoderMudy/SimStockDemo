//
//  VipPrefectureViewController.m
//  SimuStock
//
//  Created by jhss on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "VipPrefectureViewController.h"
#import "VIPPrefectureTableViewCell.h"
#import "UIImage+ColorTransformToImage.h"
#import "SchollWebViewController.h"

@implementation VipPrefectureTableAdapter
- (id)initWithTableViewController:(BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList {
  self = [super initWithTableViewController:baseTableViewController withDataArray:dataList];
  if (self) {
    _dataMap = @{
      @0 : @{@"ranklist" : @"点击高级VIP会员标识"},
      @1 : @{@"ranklist" : @"精选牛人交易", @"vipType" : @"lrjy"},
      @2 : @{@"ranklist" : @"精选股市资讯", @"vipType" : @"gszx"},
      @3 : @{@"ranklist" : @"尊贵紫色王冠", @"vipType" : @"zszg"},
      @5 : @{@"ranklist" : @"点亮VIP会员标识"},
      @6 : @{@"ranklist" : @"专属会员标识", @"vipType" : @"zshy"},
      @7 : @{@"ranklist" : @"止盈止损功能", @"vipType" : @"zyzs"},
      @8 : @{@"ranklist" : @"上限提升服务", @"vipType" : @"sxts"},
    };
  }
  return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_dataMap count] + 2; //加上分界线
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 4) {
    return 10;
  } else
    return 51;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 4 || indexPath.row == 9) {
    cell.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  } else
    cell.backgroundColor = [Globle colorFromHexRGB:@"f7f7f7"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //去除中间透明的cell
  if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 0 || indexPath.row == 9) {
    return;
  } else {
    NSDictionary *dic = _dataMap[@(indexPath.row)];
    if (dic && dic[@"vipType"] && dic[@"ranklist"]) {
      NSString *textUrl = [wap_address
          stringByAppendingFormat:@"/mobile/memberCenter/html/" @"%@.html", dic[@"vipType"]];
      [SchollWebViewController startWithTitle:dic[@"ranklist"] withUrl:textUrl];
    }
  }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"VIPPrefectureTableViewCell";
  VIPPrefectureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil && indexPath.row != 4) {
    cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
    if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 9) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
      //取消选中效果
      UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
      backView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
      backView.layer.masksToBounds = YES;
      cell.selectedBackgroundView = backView;
    }
  } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blackCell"];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 10)];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
  }

  NSInteger row = indexPath.row;
  if (row == 0 || row == 5) {
    if (row == 5) {
      cell.memeberBtn.backgroundColor = [Globle colorFromHexRGB:@"#eb9500"];
      cell.serviceLabel.text = @"享受会员服务";
      UIImage *inviteFriendImage = [UIImage imageFromView:cell.memeberBtn
                                      withBackgroundColor:[Globle colorFromHexRGB:@"#d59805"]];
      [cell.memeberBtn setBackgroundImage:inviteFriendImage forState:UIControlStateHighlighted];
      [[SimuUtil getUserVipType] isEqualToString:@"1"] ? (cell.memeberBtn.hidden = YES)
                                                       : (cell.memeberBtn.hidden = NO);
    } else {
      cell.memeberBtn.backgroundColor = [Globle colorFromHexRGB:@"#a85af7"];
      UIImage *inviteFriendImage = [UIImage imageFromView:cell.memeberBtn
                                      withBackgroundColor:[Globle colorFromHexRGB:@"#7f45ba"]];
      [cell.memeberBtn setBackgroundImage:inviteFriendImage forState:UIControlStateHighlighted];
      cell.memeberBtn.hidden = NO;
    }
    cell.topSeparator.hidden = NO;
    cell.serviceLabel.hidden = NO;
    cell.arrowImageView.hidden = YES;
    cell.vipPrefectureName.hidden = YES;
    cell.clickVIPPrefectureName.hidden = NO;
  } else if (row == 9) {
    cell.vipPrefectureName.hidden = YES;
    cell.arrowImageView.hidden = YES;
    cell.userRemindCellLabel.hidden = NO;
  }
  NSDictionary *dic = _dataMap[@(row)];
  if (dic) {

    (indexPath.row == 0 || indexPath.row == 5)
        ? (cell.clickVIPPrefectureName.text = dic[@"ranklist"])
        : (cell.vipPrefectureName.text = dic[@"ranklist"]);
  }
  ([[SimuUtil getUserVipType] isEqualToString:@"1"] && row == 5)
      ? (cell.clickVIPPrefectureName.text = @"已点亮VIP会员标识")
      : (cell.clickVIPPrefectureName.text = @"点亮VIP会员标识");
  return cell;
}

@end

@implementation VipPrefectureViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
  [self refreshCurrentPage];
}

//创建比赛成功delegate，刷新列表
- (void)refreshCurrentPage {
  //顶部广告栏
  [self topBillboard];
}
#pragma mark - 顶部广告栏
- (void)topBillboard {
  advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeAdvanceVIP];
  advViewVC.delegate = self;
  advViewVC.view.userInteractionEnabled = YES;
  [self addChildViewController:advViewVC];
  advViewVC.view.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  [advViewVC requestImageAdvertiseList];
}

#pragma mark
#pragma mark------GameAdvertisingDelegate-------

//判断有没有广告页
- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg {
  if (AdBool) {
    CGFloat factor = WIDTH_OF_SCREEN / 320;
    advViewVC.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, vipAdvHeight * factor);
    advViewVC.view.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = advViewVC.view;
    advViewVC.view.userInteractionEnabled = YES;
    self.tableView.tableHeaderView.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  } else {
    [advViewVC.view removeFromSuperview];
    self.tableView.tableHeaderView = nil;
  }
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestWithRefreshType:(RefreshType)refreshType
                 withDataArray:(DataArray *)existDataList
                  withCallBack:(HttpRequestCallBack *)callback {
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[VipPrefectureTableAdapter alloc] initWithTableViewController:self
                                                                     withDataArray:self.dataArray];
  }
  return _tableAdapter;
}
@end
