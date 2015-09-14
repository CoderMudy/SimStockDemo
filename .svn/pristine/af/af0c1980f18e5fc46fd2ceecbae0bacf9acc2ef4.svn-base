//
//  WFHistoryFirmOfferViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFHistoryFirmOfferViewController.h"
#import "WFHistoryFirmTableViewController.h"

@interface WFHistoryFirmOfferViewController () {
  WFHistoryFirmTableViewController *historyFirmOfferVC;
}
@end

@implementation WFHistoryFirmOfferViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //显示历史实盘并且隐藏刷新按钮
  [_topToolBar resetContentAndFlage:@"历史实盘" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  
  [self creatTableVierHistoryFirmOfferView];
}

//创建tableview
- (void)creatTableVierHistoryFirmOfferView {
  CGRect frameTabelView = CGRectMake(0, 0, self.clientView.bounds.size.width,
                                     self.clientView.bounds.size.height);
  historyFirmOfferVC = [[WFHistoryFirmTableViewController alloc]
      initWithNibName:@"WFHistoryFirmTableViewController"
               bundle:nil];
  historyFirmOfferVC.tableView.frame = frameTabelView;
  historyFirmOfferVC.tableView.separatorStyle =
      UITableViewCellSeparatorStyleNone;
  historyFirmOfferVC.tableView.backgroundColor = [UIColor clearColor];
  historyFirmOfferVC.tableView.backgroundView = nil;
  [self addChildViewController:historyFirmOfferVC];
  [self.clientView addSubview:historyFirmOfferVC.view];
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
