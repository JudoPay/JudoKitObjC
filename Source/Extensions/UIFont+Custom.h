//
//  UIFont+Custom.h
//  JudoKitObjC
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import <UIKit/UIKit.h>

@interface UIFont (Custom)

+ (void)loadCustomFonts;

# pragma mark - SF Pro Display Font Family

+ (UIFont *)SFProDisplayBlackWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayBlackItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayBoldWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayBoldItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayHeavyWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayHeavyItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayLightWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayLightItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayMediumWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayMediumItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayRegularWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayRegularItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplaySemiboldWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplaySemiboldItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayThinWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayThinItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProDisplayUltralightWithSize:(CGFloat)size;
+ (UIFont *)SFProDisplayUltralightItalicWithSize:(CGFloat)size;

# pragma mark - SF Pro Text Font Family

+ (UIFont *)SFProTextBoldWithSize:(CGFloat)size;
+ (UIFont *)SFProTextBoldItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProTextHeavyWithSize:(CGFloat)size;
+ (UIFont *)SFProTextHeavyItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProTextLightWithSize:(CGFloat)size;
+ (UIFont *)SFProTextLightItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProTextMediumWithSize:(CGFloat)size;
+ (UIFont *)SFProTextMediumItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProTextRegularWithSize:(CGFloat)size;
+ (UIFont *)SFProTextRegularItalicWithSize:(CGFloat)size;

+ (UIFont *)SFProTextSemiboldWithSize:(CGFloat)size;
+ (UIFont *)SFProTextSemiboldItalicWithSize:(CGFloat)size;

@end