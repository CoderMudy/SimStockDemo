//
//  animationView.h
//  SimuStock
//
//  Created by moulin wang on 14-7-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol animationViewDelegate <NSObject>
//可实现
@optional
- (void)logInMethod;
@end
@interface animationView : UIView {
  UIImageView *fishImageView;
}
@property(nonatomic, weak) id<animationViewDelegate> delegate;
@end
