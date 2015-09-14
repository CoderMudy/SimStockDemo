//
//  simuScrollButViewCell.h
//  SimuStock
//
//  Created by Mac on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@interface SimuScrollButViewCell : UITableViewCell

@property(strong, nonatomic) IBOutletCollection(BGColorUIButton)
    NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UIView *View3;
@property (weak, nonatomic) IBOutlet UIView *View4;
@property (weak, nonatomic) IBOutlet UIView *View5;

@property(weak, nonatomic) IBOutlet UIScrollView *Main_scrollView;

@end
