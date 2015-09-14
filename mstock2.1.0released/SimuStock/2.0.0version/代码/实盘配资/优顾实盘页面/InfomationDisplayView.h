//
//  InfomationDisplayView.h
//  SimuStock
//
//  Created by moulin wang on 15/4/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetStockFirmPositionData.h"

//协议按钮点击事件
@protocol InfomationDisplayButtonDelegate <NSObject>
- (void)marginButtonDownEvent;

@end

@interface InfomationDisplayView : UIView

@property(weak, nonatomic)
    id<InfomationDisplayButtonDelegate> infomationDisplayDelegate;

@property(strong, nonatomic) WFFirmHeadInfoData *infomationDisplayData;

//数据绑定
- (void)theBindingDataWithInfomationDisplay:
        (WFFirmHeadInfoData *)infomationDisplay;

//静态加载xib
+(InfomationDisplayView *)theReturnOfTheir;

@end
