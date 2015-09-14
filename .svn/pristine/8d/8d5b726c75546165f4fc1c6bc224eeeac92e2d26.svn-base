//
//  OpenMembershipViewController.m
//  SimuStock
//
//  Created by tanxuming on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OpenMembershipViewController.h"
#import "NetShoppingMallBaseViewController.h"
#import "UIImage+ColorTransformToImage.h"

@implementation OpenMembershipViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIImage *inviteFriendImage =
      [UIImage imageFromView:self.openMembershipBtn
          withBackgroundColor:[Globle colorFromHexRGB:@"#086dae"]];
  [self.openMembershipBtn setBackgroundImage:inviteFriendImage
                                    forState:UIControlStateHighlighted];
  [self.openMembershipBtn setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateHighlighted];
}

- (IBAction)buttonClick:(UIButton *)sender {
  NetShoppingMallBaseViewController *iSimuStockViewController =
      [[NetShoppingMallBaseViewController alloc]
          initWithPageType:Mall_Buy_Props];
  [AppDelegate pushViewControllerFromRight:iSimuStockViewController];
}

@end
