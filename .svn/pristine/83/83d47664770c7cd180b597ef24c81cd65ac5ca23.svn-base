//
//  realTradeComboxView.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "realTradeComboxView.h"
#import "simuUtil.h"

@implementation Commbox
@synthesize tv, tableArray, textField;

- (id)initWithFrame:(CGRect)frame {

  /*if (frame.size.height<200) {
        frameHeight = 200;
    }else*/ {
    frameHeight = frame.size.height;
  }
  tabheight = frameHeight - 16;

  frame.size.height = 16.0f;

  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    // textField.delegate = self;
    self.backgroundColor = [UIColor clearColor];
  }

  if (self) {
    showList = NO; //默认不显示下拉框

    tv = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 21, frame.size.width, 0)];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = [UIColor whiteColor];
    tv.hidden = YES;
    [self addSubview:tv];

    textField = [[UITextField alloc]
        initWithFrame:CGRectMake(14, 5, frame.size.width, 17)];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:Font_Height_16_0];
    // textField.userInteractionEnabled = NO;
    textField.borderStyle = UITextBorderStyleNone; //设置文本框的边框风格
    //[textField addTarget:self action:@selector(dropdown)
    //forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:textField];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(14, 0, frame.size.width, 21);
    [button addTarget:self
                  action:@selector(dropdown)
        forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    //弹出标志
    UIImage *image = [UIImage imageNamed:@"combox_down.png"];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(
        self.bounds.size.width - imageView.image.size.width - 5,
        5 + (16 - image.size.height), image.size.width, image.size.height);
    //[self addSubview:imageView];
    [self insertSubview:imageView atIndex:0];
  }
  return self;
}

- (void)reset:(NSArray *)array {
  if (array == nil)
    return;
  frameHeight = 30 * [array count] + 16;
  tabheight = frameHeight - 16;
  self.tableArray = array;
  [self.tv reloadData];
}

#pragma mark
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)uiTextField {
  return NO;
}
- (BOOL)textField:(UITextField *)uiTextField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:
                    (NSString *)string // return NO to not change text
{
  return NO;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
////    [[NSNotificationCenter defaultCenter] addObserver:self
/// selector:@selector(keyBoBoardHidden:) name:UIKeyboardWillShowNotification
/// object:nil];
//    return YES;
//}
//
//- (void)keyBoBoardHidden:(NSNotification *)Notification{
//    //[self.textField resignFirstResponder];
//    return;
//}

- (void)visibleShow {
  if (showList) { //如果下拉框已显示，什么都不做
    showList = NO;
    tv.hidden = YES;

    CGRect sf = self.frame;
    sf.size.height = 16;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    imageView.image = [UIImage imageNamed:@"combox_down.png"];
  }
}
- (void)dropdown {
  [textField resignFirstResponder];
  if (tableArray == nil || [tableArray count] == 0)
    return;
  if (self.comboxTouch) {
    self.comboxTouch(self);
  }
  if (showList) { //如果下拉框已显示，什么都不做
    showList = NO;
    tv.hidden = YES;

    CGRect sf = self.frame;
    sf.size.height = 16;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    imageView.image = [UIImage imageNamed:@"combox_down.png"];
    return;
  } else { //如果下拉框尚未显示，则进行显示
    imageView.image = [UIImage imageNamed:@"combox_up.png"];
    CGRect sf = self.frame;
    sf.size.height = frameHeight;

    //把dropdownList放到前面，防止下拉框被别的控件遮住
    [self.superview bringSubviewToFront:self];
    tv.hidden = NO;
    showList = YES; //显示下拉框

    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    frame.size.height = tabheight;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = sf;
    tv.frame = frame;
    [UIView commitAnimations];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    UIView *lineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 30 - 1, self.bounds.size.width, 0.5)];
    lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [cell addSubview:lineView];
    UIView *backview =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width,
                                                 cell.bounds.size.height)];
    backview.backgroundColor = [Globle colorFromHexRGB:@"d9ecf2"];
    // cell.selectedBackgroundView=backview;
  }

  cell.textLabel.text = tableArray[[indexPath row]];
  cell.textLabel.font = [UIFont systemFontOfSize:15.f];
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  textField.text = tableArray[[indexPath row]];
  showList = NO;
  tv.hidden = YES;
  if (self.selectedCallBack) {
    self.selectedCallBack(indexPath.row);
  }

  CGRect sf = self.frame;
  sf.size.height = 16;
  self.frame = sf;
  CGRect frame = tv.frame;
  frame.size.height = 0;
  tv.frame = frame;
  imageView.image = [UIImage imageNamed:@"combox_down.png"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end