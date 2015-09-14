//
//  simuScrollButViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuScrollButViewCell.h"
#import "SelfStockViewController.h"
#import "simuRealTradeVC.h"
#import "AccountsViewController.h"
#import "StockSchoolViewController.h"
#import "StockChannelNewsViewController.h"

#import "BrokerageAccountListVC.h"



@implementation SimuScrollButViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  _Main_scrollView.contentSize =
      CGSizeMake(self.width + 1, _Main_scrollView.height);
  [_buttons enumerateObjectsUsingBlock:^(BGColorUIButton *button,
                                         NSUInteger idx, BOOL *stop) {
    button.normalBGColor = [UIColor clearColor];
    button.highlightBGColor = [Globle colorFromHexRGB:@"e3e3e3"];
  }];
}

- (IBAction)simuButtonPressDownDelegate:(UIButton *)sender {
  NSInteger index = sender.tag;
  if (index == 0) {
    //自选股
    SelfStockViewController *showViewController =
        [[SelfStockViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:showViewController];

  } else if (index == 1) {
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          if (isLogined) {
            //实盘开户
            [AppDelegate
                pushViewControllerFromRight:[[BrokerageAccountListVC alloc]
                                                initWithOnLoginCallbalck:nil]];
          }
        }];
  } else if (index == 2) {
    //实盘交易
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          if (isLogined) {
            if ([SimuUser getUserFirmLogonSuccessStatus]) {
              //判断信息是否齐全
              if (![[RealTradeUrls
                          singleInstance] autoLoadRealTradeUrlFactory]) {
                return;
              }
              //直接登录
              //实盘主页
              [AppDelegate
                  pushViewControllerFromRight:[[simuRealTradeVC alloc] init]];
              //重新记录时间
              [SimuUser setUserFirmLogonSuccessTime:
                            [NSDate timeIntervalSinceReferenceDate]];
            } else {
              //进登录页
              [AppDelegate pushViewControllerFromRight:
                               [[AccountsViewController alloc]
                                   initWithPageTitle:@"交易登录"
                                     withCompanyName:nil
                                     onLoginCallBack:nil]];
            }
          }
        }];
  } else if (index == 3) {
    //股市学堂
    StockSchoolViewController *shoolViewController =
        [[StockSchoolViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:shoolViewController];
  } else if (index == 4) {
    StockChannelNewsViewController *showViewController =
        [[StockChannelNewsViewController alloc] init];
    [AppDelegate pushViewControllerFromRight:showViewController];
    return;

    //    //证券词典
    //    StockSchoolListViewController *stockSchoolListVC =
    //        [[StockSchoolListViewController alloc] init];
    //    stockSchoolListVC.titleName = @"证券词典";
    //    stockSchoolListVC.moduleId = @"6";
    //    [AppDelegate pushViewControllerFromRight:stockSchoolListVC];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
