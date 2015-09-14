//
//  MyGoldViewController.h
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MyGoldVC.h"
/**我的金币页面总VC*/
@interface MyGoldClientVC : BaseViewController <SimuIndicatorDelegate> {
  MyGoldVC *myGoldVC;
}

@end
