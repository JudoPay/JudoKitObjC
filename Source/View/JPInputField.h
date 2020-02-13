//
//  JPInputField.h
//  JudoKitObjC
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPAddCardViewModel.h"
#import <UIKit/UIKit.h>

@class JPInputField;

@protocol JPInputFieldDelegate <NSObject>

/**
 * A method which triggers everytime an input change should occur
 *
 * @param inputField - a reference to the current instance of JPInputField
 * @param text - the new input string that should change
 */
- (BOOL)inputField:(JPInputField *)inputField shouldChangeText:(NSString *)text;

@end

@interface JPInputField : UIView

/**
 * An NS_ENUM which describes the type of the input field
 */
@property (nonatomic, assign) JPInputType type;

/**
 * The text of the input field
 */
@property (nonatomic, strong) NSString *text;

/**
 * The color of the input field's text
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * The font of the input field's text
 */
@property (nonatomic, strong) UIFont *font;

/**
 * The input view of the input field.
 * Defaults to a keyboard, but can be set to any other type of UIView instance.
 */
@property (nonatomic, strong) UIView *inputView;

/**
 * A property which sets the toggles the input field interaction ability
 */
@property (nonatomic, assign) BOOL enabled;

/**
 * A property that changes the keyboard type of the input field
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 * A reference to the object that adopts the JPInputFieldDelegate protocol
 */
@property (nonatomic, weak) id<JPInputFieldDelegate> delegate;

/**
 * Convenience method for setting an attributed placeholder
 *
 * @param text - the string contents of the placeholder
 * @param color - the color of the placeholder
 * @param font - the font of the placeholder
 */
- (void)placeholderWithText:(NSString *)text
                      color:(UIColor *)color
                    andFont:(UIFont *)font;

/**
 * A method that displays an inline error above the input text.
 */
- (void)displayErrorWithText:(NSString *)text;

/**
 * A method that removes the inline error above the input text
 */
- (void)clearError;

@end

@interface JPInputField (UITextFieldDelegate) <UITextFieldDelegate>
@end
