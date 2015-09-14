//
//  SimuBaseVC.m
//  SimuStock
//
//  Created by Mac on 14-9-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuBaseVC.h"

@interface SimuBaseVC ()<SimTopBannerViewDelegate,SimuIndicatorDelegate>

@end

@implementation SimuBaseVC
@synthesize clientView=base_clientView;
@synthesize indicatorView=base_indicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[SimuUtil colorWithHexString:@"#f7f7f7"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        //ios7.0及以上版本
        base_topTBarHeight=45+20;
    }
    else
    {
        //ios7.0版本
        base_topTBarHeight=45;
    }
    [self creatTopToolBarView];
    [self creatIndicatorView];
    [self creatClientView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark 创建页面控件
//创建上工具栏控件
-(void)creatTopToolBarView
{
    //创建上工具栏
    base_topToolBar=[[SimTopBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, base_topTBarHeight)];
    base_topToolBar.delegate=self;
    [self.view addSubview:base_topToolBar];
    [base_topToolBar release];
    [base_topToolBar resetContentAndFlage:@"转账流水" Mode:TTBM_Mode_Leveltwo];
}
//创建联网等待菊花
-(void)creatIndicatorView
{
    if(base_indicatorView==nil)
    {
        base_indicatorView=[[SimuIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40, base_topTBarHeight-45, 40, 45)];
        base_indicatorView.delegate=self;
        [self.view addSubview:base_indicatorView];
        [base_indicatorView release];
    }
    
}
//创建客户区视图
-(void)creatClientView
{
    base_clientView=[[UIView alloc] initWithFrame:CGRectMake(0, base_topTBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-base_topTBarHeight)];
    [self.view addSubview:base_clientView];
    [base_clientView release];
}

#pragma mark
#pragma mark 协议回调函数
// SimTopBannerViewDelegate 协议
- (void)leftButtonPress {
    [self viewcontrolerHideWidthAnimation];
}
// SimuIndicatorDelegate
-(void) refreshButtonPressDown
{
    if(base_indicatorView)
    {
        [base_indicatorView startAnimating];
    }
}
#pragma mark
#pragma mark 动画函数
- (void)viewcontrolerHideWidthAnimation
{
    [UIView beginAnimations:@"animationID" context:nil];
    
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationWillStartSelector:@selector(begin)];
    [UIView setAnimationDidStopSelector:@selector(stopSelfViewContolerAnimation)];
    
    //[UIView setAnimationTransition:mode forView:view cache:YES];
    self.view.frame =
    CGRectOffset(self.view.frame, 0, self.view.bounds.size.height + 40);
    [UIView commitAnimations];
}

- (void)stopSelfViewContolerAnimation {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
