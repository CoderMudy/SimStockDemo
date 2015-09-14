//
//  TraceMessageViewController.h
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "TraceMessageTableViewController.h"

@interface TraceMessageViewController
    : BaseViewController <SimuIndicatorDelegate> {
  TraceMessageTableViewController *_traceMessageVC;
}
@end
