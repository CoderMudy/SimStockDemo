#ifndef _TZTKHTITLEVIEW_H__
#define _TZTKHTITLEVIEW_H__

#import <UIKit/UIKit.h>

@protocol tztkhTitleViewdelegate;
@interface tztkhTitleView : UIView
{
    UIButton* _leftBtn;
    UIButton* _rightBtn;
    UILabel* _titleLab;
    BOOL    _tztHasIcon;
    UIImageView *_tztIconView;
    id<tztkhTitleViewdelegate> _tztdelegate;
}
@property (nonatomic,assign) id<tztkhTitleViewdelegate> tztdelegate;
@property (nonatomic,retain) UIButton* leftBtn;
@property (nonatomic,retain) UIButton* rightBtn;
@property (nonatomic) BOOL tztHasIcon;
@property (nonatomic,retain) UIImageView *tztIconView;
- (void)onTitleBtnLeft;
- (void)onTitleBtnRight;
- (void)setLeftHide:(BOOL)bHidden;
- (void)setRightHide:(BOOL)bHidden;
- (void)setTitle:(NSString*)title;
- (void)setLeftBtn:(NSString*)title image:(NSString*)image backimage:(NSString*)backimage;
- (void)setRightBtn:(NSString*)title image:(NSString*)image backimage:(NSString*)backimage;
@end

@protocol tztkhTitleViewdelegate <NSObject>
- (void)onTitleBtnLeft;
- (void)onTitleBtnRight;
@end
#endif