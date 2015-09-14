//
//  BankInforCell.h
//  SimuStock
//
//  Created by moulin wang on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankInforCell : UITableViewCell
//线
@property (strong, nonatomic) IBOutlet UIView *lineView;
//内容
@property (weak, nonatomic) IBOutlet UILabel *myLable;

@end
