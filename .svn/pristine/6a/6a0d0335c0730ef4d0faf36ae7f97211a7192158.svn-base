//
//  HomeAtSuperView.h
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageTableHeaderData.h"

@interface HomeAtSuperView : UIView <UIAlertViewDelegate> {

  //判断关注网络请求
  BOOL requesting;
}

/** "@Ta" 按钮*/
@property(weak, nonatomic) IBOutlet UIButton *atBtn;
/** ”追踪“ 按钮  */
@property(weak, nonatomic) IBOutlet UIButton *followBtn;
/** “+关注” 按钮 */
@property(weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *trackIndicatorView;

@property(weak, nonatomic)
    IBOutlet UIActivityIndicatorView *attentionIndicatorView;

@property(strong, nonatomic) HomePageTableHeaderData *tableInfoData;

///追踪状态
@property(nonatomic, assign) NSInteger traceFlagInt;
- (void)bindHomeAtSuperData:(HomePageTableHeaderData *)tableHeaderData;

@end
