//
//  MyChestsTableHeaderView.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  我的宝箱表头，显示宝箱和金币数
 */
@interface MyChestsTableHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *diamondLabel;
@property (strong, nonatomic) IBOutlet UILabel *glodLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grayLineHeight;

@end
