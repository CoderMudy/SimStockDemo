//
//  JHSSViewDelegate.h
//  SimuStock
//
//  Created by jhss on 13-10-30.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ISSShareViewDelegate.h>

// iphone视图委托

@interface JHSSViewDelegate : NSObject <ISSShareViewDelegate,ISSViewDelegate> {
  UIView *backgroundView;
}
@end
