//
//  MillionDetailsViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MillionDetailsViewController.h"

//#import "simupublic.h"

#import "StockTradeList.h"
#import "TweetListItem.h"

@implementation MillionDetailsViewController

- (id)initAappointuid:(NSString *)appointuid
            titleName:(NSString *)titleName
              matchID:(NSString *)matchID
               Object:(UIViewController *)controller {
  if (self = [super init]) {
    if (appointuid) {
      self.appointuid = appointuid;
    }
    if (titleName) {
      self.titleName = titleName;
    }
    if (matchID) {
      self.matchID = matchID;
    }
    if (controller) {
      _simuMainVC = controller;
    }
  }
  return self;
}
- (void)dealloc {
  milliontableView.delegate = nil;
  milliontableView.dataSource = nil;
  if (footerview) {
    [footerview free];
    footerview.scrollView = nil;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  dataArray = [[DataArray alloc] init];

  [self createTableView];
  //取得网络数据
  [_indicatorView startAnimating];
  //小牛视图

  //网络请求
  [self requestAappointuid:self.appointuid matchID:self.matchID fromtid:@"0" count:@"20"];
  [self.view addSubview:newLittleCattleView];
}

#pragma mark UITableView
- (void)createTableView {
  milliontableView =
      [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.clientView.bounds.size.height - 43.5)
                                   style:UITableViewStylePlain];
  milliontableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  milliontableView.delegate = self;
  milliontableView.dataSource = self;
  milliontableView.allowsSelection = YES;
  [self.clientView addSubview:milliontableView];
  milliontableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  // 上拉加载更多
  footerview = [[MJRefreshFooterView alloc] initWithFrame:self.view.bounds];
  footerview.delegate = self;
  footerview.scrollView = milliontableView;
  footerview.hidden = YES;
  [footerview singleRow];
}


//系统通知中参加何种炒股大赛
- (NSString *)participateInTheContestStocks:(NSMutableArray *)arr {
  NSString *conStr = @"";
  if (arr.count == 3) {
    for (int i = 0; i < 3; i++) {
      switch (i) {
      case 0: {
        conStr = [conStr stringByAppendingString:arr[i]];
      } break;
      case 1: {
        NSMutableDictionary *dictionary = arr[i];
        NSString *str = dictionary[@"text"];
        if (str) {
          conStr = [conStr stringByAppendingString:str];
        }
      } break;
      case 2: {
        conStr = [conStr stringByAppendingString:arr[i]];
      } break;

      default:
        break;
      }
    }
  }
  return conStr;
}




@end
