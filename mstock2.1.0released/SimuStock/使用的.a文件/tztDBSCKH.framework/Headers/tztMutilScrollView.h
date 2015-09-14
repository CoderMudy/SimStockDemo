/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        多view滚动切换基类
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import <UIKit/UIKit.h>
@protocol tztMutilScrollViewDelegate<NSObject>
@optional
//显示
-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex;
//隐藏
-(void)tztMutilPageViewDidDisappear:(NSInteger)CurrentViewIndex;
@end

@interface tztMutilScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView        *_mutilScrollView;
    UIPageControl       *_pageControl;
    
    int                 _nCurPage;
    int                 _nPageCount; //总页数
    
    BOOL                _bSet;
    NSMutableArray*     _ayViews;
    
    BOOL                _bSupportLoop;
    id<tztMutilScrollViewDelegate>                  _tztdelegate;
}
@property int nCurPage;
@property(nonatomic, retain)NSMutableArray  *pageViews;
@property(nonatomic, assign)id<tztMutilScrollViewDelegate>              tztdelegate;
@property BOOL bSupportLoop;
//zxl 20130930 滚动到当前设置的界面 （有动画效果）
- (void)scrollToIndex:(int)aIndex animated:(BOOL)animated;
//
@end
