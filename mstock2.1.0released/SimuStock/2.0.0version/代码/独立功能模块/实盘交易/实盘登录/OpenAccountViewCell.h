//
//  OpenAccountViewCell.h
//  SimuStock
//
//  Created by Mac on 15-3-4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"

@interface OpenAccountViewCell : UITableViewCell
/** 描述信息 */
@property (weak, nonatomic) IBOutlet FTCoreTextView *accountDetailTextView;

@end
