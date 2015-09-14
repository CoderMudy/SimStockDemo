//
//  simuButtonView.h
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimuButtonDelegate <NSObject>
//股市学堂等按钮点击
- (void)simuButtonPressDownDelegate:(NSInteger)index;

@end

/*
 *类说明：交易页面上方股市学堂等小按钮
 */
@interface SimuButtonView : UIView {
  //序号
  NSInteger _buttonTag;
}

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)name
              Title:(NSString *)title
                Tag:(NSInteger)tag;

@property(weak, nonatomic) id<SimuButtonDelegate> delegate;
@end
