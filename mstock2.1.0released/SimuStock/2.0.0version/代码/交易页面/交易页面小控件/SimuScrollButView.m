//
//  simuScrollButView.m
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuScrollButView.h"

#import "SelfStockViewController.h"
#import "StockSchoolViewController.h"
#import "StockSchoolListViewController.h"
#import "simuRealTradeVC.h"

//#import "StockWarningController.h"

//测试确认支付、账户、资金明细、账户充值、优顾账户
//实盘开户界面
#import "BrokerageAccountListVC.h"

@implementation SimuScrollButView

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self creatControlViews];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self creatControlViews];
  }
  return self;
}
- (void)creatControlViews {
  //创建滚动视图
  _scrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, 7, self.bounds.size.width, 115 / 2)];
  _scrollView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.delaysContentTouches = NO;
  [self addSubview:_scrollView];

  //创建按钮
  _imageNameArray = @[
    @"自选股.png",
    @"实盘开户",
    @"实盘交易.png",
    @"股市学堂.png",
    @"证券词典.png"
  ];
  _titleArray =
      @[ @"自选股",
         @"实盘开户",
         @"实盘交易",
         @"股市学堂",
         @"证券词典" ];
  float m_simagewidth = 115.f / 2.f;
  float m_Interval = 7;
  float m_width = (m_simagewidth + m_Interval);
  for (int i = 0; i < [_imageNameArray count]; i++) {
    NSString *imagename = _imageNameArray[i];
    NSString *titlename = _titleArray[i];
    SimuButtonView *buttonView = [[SimuButtonView alloc]
        initWithFrame:CGRectMake(i * m_width + 7, 0, m_simagewidth,
                                 m_simagewidth)
            imageName:imagename
                Title:titlename
                  Tag:i];
    buttonView.delegate = self;
    [_scrollView addSubview:buttonView];
  }
  [_scrollView
      setContentSize:CGSizeMake(m_width * [_titleArray count] + m_Interval,
                                self.bounds.size.height)];
}

- (void)simuButtonPressDownDelegate:(NSInteger)index {
  if (index == 0) {
    //自选股
    [AppDelegate
        pushViewControllerFromRight:[[SelfStockViewController alloc] init]];
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
    //证券词典
    StockSchoolListViewController *stockSchoolListVC =
        [[StockSchoolListViewController alloc] init];
    stockSchoolListVC.titleName = @"证券词典";
    stockSchoolListVC.moduleId = @"6";
    [AppDelegate pushViewControllerFromRight:stockSchoolListVC];
  }
}

@end
