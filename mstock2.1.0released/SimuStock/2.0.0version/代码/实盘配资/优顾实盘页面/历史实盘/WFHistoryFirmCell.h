//
//  WFHistoryFirmCell.h
//  SimuStock
//
//  Created by moulin wang on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFHistoryFirmCellDelegate <NSObject>

-(void)cellDown;

@end

@interface WFHistoryFirmCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property(weak, nonatomic) id<WFHistoryFirmCellDelegate>degetale;
@end
