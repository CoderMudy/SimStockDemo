//
//  StockPriceRemindListViewController.m
//  SimuStock
//
//  Created by jhss on 15-4-19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceRemindListViewController.h"
///将预警推送保存在coredata数据库中

@implementation StockPriceRemindListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  [self createTraceMessageVC];
}

///创建顶部topBar
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"股票提醒" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  [self createClearBtn];
}

- (void)createTraceMessageVC {
  if (!_stockPriceRemindVC) {
    CGRect frame =
        CGRectMake(0, 0, self.clientView.bounds.size.width, CGRectGetHeight(self.clientView.bounds));
    _stockPriceRemindVC = [[StockPriceRemindTableVC alloc] initWithFrame:frame];
  }
  __weak StockPriceRemindListViewController *weakSelf = self;
  _stockPriceRemindVC.clearBtnDisplay = ^() {
    [weakSelf displayClearBtn];
  };
  _stockPriceRemindVC.clearBtnHidden = ^() {
    [weakSelf hiddenClearBtn];
  };
  [self.clientView addSubview:_stockPriceRemindVC.view];
  [self addChildViewController:_stockPriceRemindVC];
}

- (void)displayClearBtn {
  _clearBtn.hidden = NO;
}
- (void)hiddenClearBtn {
  _clearBtn.hidden = YES;
}

///创建清空按钮
- (void)createClearBtn {
  _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _clearBtn.frame = CGRectMake(self.view.bounds.size.width - 60, _topToolBar.bounds.size.height - 45, 60, 45);
  _clearBtn.backgroundColor = [UIColor clearColor];
  [_clearBtn.titleLabel setFont:[UIFont systemFontOfSize:Font_Height_16_0]];
  [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
  [_clearBtn setTitle:@"清空" forState:UIControlStateHighlighted];

  [_clearBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"] forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *rightImage =
      [[UIImage imageNamed:@"return_touch_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [_clearBtn setBackgroundImage:rightImage forState:UIControlStateHighlighted];

  [_clearBtn addTarget:self
                action:@selector(deleteButtonPress:)
      forControlEvents:UIControlEventTouchUpInside];
  _clearBtn.hidden = YES;
  [self.view addSubview:_clearBtn];
}
- (void)deleteButtonPress:(UIButton *)btn {
  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                 message:@"确定要清空所有股票提醒消息吗？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                       otherButtonTitles:@"确定", nil];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [_stockPriceRemindVC clearStockAlarmData];
  }
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
