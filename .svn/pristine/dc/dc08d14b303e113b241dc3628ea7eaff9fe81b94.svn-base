//
//  InfomationMoreViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InfomationMoreViewController.h"
#import "MoreCell.h"
#import "AppDelegate.h"
#import "RealTradeTodayDealQueryVC.h"
#import "RealTradeHistoryDealQueryVC.h"
#import "FSPositionsViewController.h"
#import "CutomerServiceButton.h"

@interface InfomationMoreViewController () <
    UITableViewDataSource, UITableViewDelegate, PostitonDataDelegate> {
  UITableView *myTableView;
  //图片数组
  NSArray *image_array;
  //标题数组
  NSArray *title_array;
}

@property(nonatomic, strong) PositionData *positionDataInfomation;

@end

@implementation InfomationMoreViewController

- (void)sendToFinfomationMoreVC:(PositionData *)postitonData {
  self.positionDataInfomation = postitonData;
}

static NSString *cellName = @"NameCell";
- (void)viewDidLoad {

  [super viewDidLoad];
  [self.topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  image_array = @[ @"当日成交小图标.png", @"历史成交小图标.png" ];
  title_array = @[ @"当日成交", @"历史成交" ];

  CGRect frame = CGRectMake(9, 10, self.view.frame.size.width - 18,
                            self.view.frame.size.height - 80);
  myTableView =
      [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
  myTableView.dataSource = self;
  myTableView.delegate = self;
  myTableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  myTableView.backgroundView = nil;
  myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  myTableView.bounces = NO;
  [self.clientView addSubview:myTableView];

  [myTableView registerNib:[UINib nibWithNibName:@"MoreCell" bundle:Nil]
      forCellReuseIdentifier:cellName];

  //创建客服电话
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
}
//分多少区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName
                                                   forIndexPath:indexPath];
  cell.backgroundColor = [UIColor clearColor];
  cell.backgroundView = nil;
  UIImage *rowBackImage = nil;
  UIImage *selectedImage = nil;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      rowBackImage = [UIImage imageNamed:@"列表01.png"];
      selectedImage = [UIImage imageNamed:@"select_up.png"];
      cell.titleLable.text = title_array[0];
      cell.titleImageView.image = [UIImage imageNamed:image_array[0]];

    } else if (indexPath.row == 1) {
      rowBackImage = [UIImage imageNamed:@"列表_03.png"];
      selectedImage = [UIImage imageNamed:@"select_down.png"];
      cell.titleLable.text = title_array[1];
      cell.titleImageView.image = [UIImage imageNamed:image_array[1]];
    }
  }
  rowBackImage =
      [rowBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 6, 5)];
  selectedImage =
      [selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
  UIImageView *rowBackImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 47)];
  UIImageView *selectedBackImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 47)];
  rowBackImageView.image = rowBackImage;
  selectedBackImageView.image = selectedImage;
  cell.backgroundView = rowBackImageView;
  cell.selectedBackgroundView = selectedBackImageView;
//  float lineFloat = 0;
//  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//    lineFloat = 23.5;
//  } else {
//    lineFloat = 36;
//  }
  //线
  if (indexPath.row == 0) {
    UIView *_downView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 47 - 1, cell.bounds.size.width, 0.5)];
    _downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
    [cell.contentView addSubview:_downView];
    //下白
    UIView *_upView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 47 - 0.5, cell.bounds.size.width, 0.5)];
    _upView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:_upView];
  }
  return cell;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 47;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 3;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return 3;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      //跳转到 当日成交页面
      [self creatTodayDealVC];
    } else {
      //跳转到 历史成交页面
      [self creatHisDealVC];
    }
  }
  [tableView reloadData];
}

- (void)statrViewController:(UIViewController *)viewController {
  [AppDelegate pushViewControllerFromRight:viewController];
}

//创建今日成交页面
- (void)creatTodayDealVC {
  [self
      statrViewController:[[RealTradeTodayDealQueryVC alloc] initWithBool:NO]];
}
//创建历史成交页面
- (void)creatHisDealVC {
  [self statrViewController:[[RealTradeHistoryDealQueryVC alloc]
                                initWithCapital:NO]];
}

@end
