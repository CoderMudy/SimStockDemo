//
//  BaseFiveDaysVC.h
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTrendVC.h"
#import "FiveDaysView.h"
#import "BasePartTimeVC.h"

@interface BaseFiveDaysVC : BaseTrendVC

@property(nonatomic, strong) FiveDaysView *fiveDaysView;

///查看分时信息的浮窗
@property(nonatomic, strong) FloatWindowViewForPartTime *floatWindowView;

@end

@interface PortaitFiveDaysVC : BaseFiveDaysVC

@end
