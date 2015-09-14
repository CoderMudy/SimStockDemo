//
//  InputTextFieldView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InputTextFieldView.h"
#import "ProcessInputData.h"

@interface InputTextFieldView () <UITextFieldDelegate>

@end

@implementation InputTextFieldView

+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type {
  InputTextFieldView *inputTextFieldView = [[InputTextFieldView alloc] init];
  inputTextFieldView.inputType = type;
  return inputTextFieldView;
}

+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andChangeTextBlock:(changeTextBlock)changeTextBlock {
  InputTextFieldView *inputTextFieldView =
      [InputTextFieldView inputTextFieldViewWithType:type];
  inputTextFieldView.changeTextBlock = changeTextBlock;
  return inputTextFieldView;
}

+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andEndEditingBlock:(endEditingBlock)endEditingBlock {
  InputTextFieldView *inputTextFieldView =
      [InputTextFieldView inputTextFieldViewWithType:type];
  inputTextFieldView.endEditingBlock = endEditingBlock;
  return inputTextFieldView;
}

+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andChangeTextBlock:(changeTextBlock)changeTextBlock
                        andEndEditingBlock:(endEditingBlock)endEditingBlock {
  InputTextFieldView *inputTextFieldView =
      [InputTextFieldView inputTextFieldViewWithType:type];
  inputTextFieldView.changeTextBlock = changeTextBlock;
  inputTextFieldView.endEditingBlock = endEditingBlock;
  return inputTextFieldView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setupDefaultValue];
  }
  return self;
}

- (void)setupDefaultValue {
  UITextField *inputTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(0, 0, self.width, self.height)];
  [self addSubview:inputTextField];
  self.backgroundColor = [UIColor clearColor];
  inputTextField.delegate = self;
  _inputTextField = inputTextField;
  /// 设置默认值
  self.numberOfDecimalPlaces = 0;
  self.numberOfIntegerPlaces = 0;
  self.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  inputTextField.borderStyle = UITextBorderStyleNone;
  inputTextField.keyboardType = UIKeyboardTypeNumberPad;
  inputTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
}

- (void)setNumberOfDecimalPlaces:(int)numberOfDecimalPlaces {
  _numberOfDecimalPlaces = numberOfDecimalPlaces;
  if (numberOfDecimalPlaces < 0) {
    _numberOfDecimalPlaces = 0;
  }
}

- (void)setNumberOfintegerPlaces:(int)numberOfIntegerPlaces {
  _numberOfIntegerPlaces = numberOfIntegerPlaces;
  if (numberOfIntegerPlaces < 0) {
    _numberOfIntegerPlaces = 0;
  }
}

- (void)setInputType:(InputTextFieldType)inputType {
  if (inputType == INPUTE_TYPE_INTEGER_NUMBER) {
    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
  } else if (inputType == INPUTE_TYPE_DECIMAL_NUMBER) {
    self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
  }
  _inputType = inputType;
}

- (void)checkTextField:(UITextField *)textField
       enabledComponentCharacters:(NSString *)enableCharaters
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  string = [NSString
      stringWithFormat:
          @"%@",
          [[string componentsSeparatedByCharactersInSet:
                       [[NSCharacterSet characterSetWithCharactersInString:
                                            enableCharaters] invertedSet]]
              componentsJoinedByString:@""]];
  [self changeTextField:textField
      shouldChangeCharactersInRange:range
                  replacementString:string];
}

- (void)changeTextField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  UITextRange *selectedRange = [textField selectedTextRange];
  NSInteger pos = [textField offsetFromPosition:textField.endOfDocument
                                     toPosition:selectedRange.end];
  textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];
  UITextPosition *newPos =
      [textField positionFromPosition:textField.endOfDocument offset:pos];
  textField.selectedTextRange =
      [textField textRangeFromPosition:newPos toPosition:newPos];
}

#pragma mark----- UITextField代理方法 -----

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSString *srcText = textField.text;

  /** 过滤删除键 */
  if ([string length] == 0) {
    [self changeTextField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
    [self textChangedBlockWithSrcText:srcText];
    return NO;
  }

  NSString *IntegerEnabledCharacters = @"0123456789";
  NSString *DecimalEnabledCharacters = @".0123456789";

  if (self.inputType == INPUTE_TYPE_INTEGER_NUMBER) {
    if (textField.text.length >= self.numberOfIntegerPlaces) {
      return NO;
    }
    [self checkTextField:textField
           enabledComponentCharacters:IntegerEnabledCharacters
        shouldChangeCharactersInRange:range
                    replacementString:string];
  } else if (self.inputType == INPUTE_TYPE_DECIMAL_NUMBER) {
    NSString *tempEnabledCharacters = @"";
    NSArray *textArray = [textField.text componentsSeparatedByString:@"."];
    UITextRange *selectedRange = [textField selectedTextRange];
    NSInteger pos = [textField offsetFromPosition:selectedRange.end
                                       toPosition:textField.endOfDocument];
    if (textArray.count > 1) {
      tempEnabledCharacters = IntegerEnabledCharacters;

      NSString *decimalText = textArray[1];
      NSString *integerText = textArray[0];
      if (pos <= decimalText.length &&
          decimalText.length >= self.numberOfDecimalPlaces) {
        return NO;
      } else if (pos > decimalText.length &&
                 integerText.length >= self.numberOfIntegerPlaces) {
        return NO;
      }
    } else {
      tempEnabledCharacters = DecimalEnabledCharacters;
      if (textField.text.length >= self.numberOfIntegerPlaces) {
        return NO;
      }
    }
    [self checkTextField:textField
           enabledComponentCharacters:tempEnabledCharacters
        shouldChangeCharactersInRange:range
                    replacementString:string];
  } else {
    [self changeTextField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
  }

  [self textChangedBlockWithSrcText:srcText];

  return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (self.inputType == INPUTE_TYPE_DECIMAL_NUMBER &&
      self.numberOfDecimalPlaces == 0) {
    self.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  }
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  [textField resignFirstResponder];

  NSString *srcText = textField.text;

  if (self.inputType == INPUTE_TYPE_INTEGER_NUMBER) {
    textField.text = [ProcessInputData forNumberClearZero:textField.text];
    if (self.inputTextField.text.length >= self.numberOfIntegerPlaces) {
      self.inputTextField.text = [self.inputTextField.text
          stringByReplacingCharactersInRange:NSMakeRange(
                                                 self.numberOfIntegerPlaces,
                                                 self.inputTextField.text
                                                         .length -
                                                     self.numberOfIntegerPlaces)
                                  withString:@""];
    }
  } else if (self.inputType == INPUTE_TYPE_DECIMAL_NUMBER) {
    textField.text =
        [ProcessInputData numbersAndTwoPunctuation:textField.text
                              andValidDecimalDigit:self.numberOfDecimalPlaces];
  }
  if ([textField.text isEqualToString:@"0"]) {
    textField.text = @"";
  }

  [self textChangedBlockWithSrcText:srcText];

  if (self.endEditingBlock) {
    self.endEditingBlock(textField.text);
  }

  return YES;
}

- (void)textChangedBlockWithSrcText:(NSString *)srcText {
  if (self.changeTextBlock) {
    self.changeTextBlock(self.inputTextField.text,
                         ![srcText isEqualToString:self.inputTextField.text]);
  }
}

@end
