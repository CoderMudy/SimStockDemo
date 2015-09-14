//
//  MyGoldSubViewController.h
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**我的金币页面表头VC*/
@interface MyGoldTopVC : UIViewController {
}
@property(strong, nonatomic) IBOutlet UILabel *balanceNumLab;
@property(strong, nonatomic) IBOutlet UILabel *goldNumLab;
@property(weak, nonatomic) IBOutlet UIImageView *arrow1ImaView;
@property(weak, nonatomic) IBOutlet UIImageView *arrow2ImageView;
@property(weak, nonatomic) IBOutlet UIImageView *arrow3ImageView;
@property(weak, nonatomic) IBOutlet UIImageView *arrow4ImageView;
@property(weak, nonatomic) IBOutlet UIImageView *arrow5ImageView;

@property (strong, nonatomic) IBOutlet UILabel *xxxxx;
@end
