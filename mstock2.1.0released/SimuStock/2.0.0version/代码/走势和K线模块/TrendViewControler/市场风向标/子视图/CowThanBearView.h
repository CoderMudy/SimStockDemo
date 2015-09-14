//
//  CowThanBearView.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CowThanBearData.h"

/* 
 *  每日牛熊比
 */
@interface CowThanBearView : UIView
{
    CowThanBearData *_cowThanBearData;
    BOOL _isToday;
}
@property (strong, nonatomic) IBOutlet UILabel *dateLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateMidLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateRightLabel;

- (void)requestCowThanBearData;

@end
