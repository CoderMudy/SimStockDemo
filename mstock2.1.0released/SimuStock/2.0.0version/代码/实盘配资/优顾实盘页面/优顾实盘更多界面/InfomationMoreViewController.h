//
//  InfomationMoreViewController.h
//  SimuStock
//
//  Created by moulin wang on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@protocol InfomationMoreSellDelegate <NSObject>

-(void)jumpToSellViewAndSendNum:(NSInteger)number;

@end

@interface InfomationMoreViewController : BaseViewController
@property(assign, nonatomic)id<InfomationMoreSellDelegate>infoDelegate;

@end
