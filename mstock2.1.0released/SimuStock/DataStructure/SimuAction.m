//
//  SimuAction.m
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuAction.h"

@implementation SimuAction

@synthesize actionCode=_actionCode;
@synthesize actionNetURL=_actionNetURL;
@synthesize vars=_vars;

- (id) init
{
	self = [super init];
	if (self)
	{
        self.actionCode=nil;
        self.actionNetURL=nil;
        _vars=[[NSMutableDictionary alloc] init];
    }
return self;
}
-(void)withcode:(NSString *)action_code andaction_url:(NSString *)URL
{
    if (self)
    {
        self.actionCode=action_code;
        self.actionNetURL=URL;
        _vars=[[NSMutableDictionary alloc] init];
    }


}
-(id)initWithCode:(NSString *)action_code ActionURL:(NSString *)URL
{
    
    if (self = [super init]) {
        self.actionCode=action_code;
        self.actionNetURL=URL;
        _vars=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [self.vars removeAllObjects];
    
}

@end
