//
//  YLTextField.h
//  SimuStock
//
//  Created by Mac on 15/2/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLTextFieldDelegate <NSObject>

@required

@optional
///获取第一相应时，回调
- (void)YLbecomeFirstResponderAPI;

///取消第一相应时，回调
- (void)YLresignFirstResponderAPI;

@end

@interface YLTextField : UITextField

@property(nonatomic, assign) id<YLTextFieldDelegate> YLdelegate;
@end
