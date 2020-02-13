//
//  JPTheme.m
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPTheme.h"
#import "JPCardDetails.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"

@implementation JPTheme

- (instancetype)init {
    if (self = [super init]) {
        // defaults
        _buttonCornerRadius = 4;
    }

    return self;
}

#pragma mark - Configuration

- (NSArray *)acceptedCardNetworks {
    if (!_acceptedCardNetworks) {
        _acceptedCardNetworks = @[ @(CardNetworkVisa), @(CardNetworkMasterCard), @(CardNetworkAMEX), @(CardNetworkMaestro) ];
    }
    return _acceptedCardNetworks;
}

#pragma mark - Strings

- (NSString *)paymentButtonTitle {
    if (!_paymentButtonTitle) {
        _paymentButtonTitle = @"pay".localized;
    }
    return _paymentButtonTitle;
}

- (NSString *)registerCardButtonTitle {
    if (!_registerCardButtonTitle) {
        _registerCardButtonTitle = @"add_card".localized;
    }
    return _registerCardButtonTitle;
}

- (NSString *)registerCardNavBarButtonTitle {
    if (!_registerCardNavBarButtonTitle) {
        _registerCardNavBarButtonTitle = @"add".localized;
    }
    return _registerCardNavBarButtonTitle;
}

- (NSString *)backButtonTitle {
    if (!_backButtonTitle) {
        _backButtonTitle = @"back".localized;
    }
    return _backButtonTitle;
}

- (NSString *)paymentTitle {
    if (!_paymentTitle) {
        _paymentTitle = @"payment".localized;
    }
    return _paymentTitle;
}

- (NSString *)registerCardTitle {
    if (!_registerCardTitle) {
        _registerCardTitle = @"add_card".localized;
    }
    return _registerCardTitle;
}

- (NSString *)refundTitle {
    if (!_refundTitle) {
        _refundTitle = @"refund".localized;
    }
    return _refundTitle;
}

- (NSString *)iDEALTitle {
    if (!_iDEALTitle) {
        _iDEALTitle = @"ideal_transaction".localized;
    }
    return _iDEALTitle;
}

- (NSString *)checkCardTitle {
    if (!_checkCardTitle) {
        _checkCardTitle = @"check_card".localized;
    }
    return _checkCardTitle;
}

- (NSString *)authenticationTitle {
    if (!_authenticationTitle) {
        _authenticationTitle = @"authentication".localized;
    }
    return _authenticationTitle;
}

- (NSString *)loadingIndicatorRegisterCardTitle {
    if (!_loadingIndicatorRegisterCardTitle) {
        _loadingIndicatorRegisterCardTitle = @"adding_card".localized;
    }
    return _loadingIndicatorRegisterCardTitle;
}

- (NSString *)loadingIndicatorProcessingTitle {
    if (!_loadingIndicatorProcessingTitle) {
        _loadingIndicatorProcessingTitle = @"processing_payment".localized;
    }
    return _loadingIndicatorProcessingTitle;
}

- (NSString *)redirecting3DSTitle {
    if (!_redirecting3DSTitle) {
        _redirecting3DSTitle = @"redirecting".localized;
    }
    return _redirecting3DSTitle;
}

- (NSString *)verifying3DSPaymentTitle {
    if (!_verifying3DSPaymentTitle) {
        _verifying3DSPaymentTitle = @"verifying_payment".localized;
    }
    return _verifying3DSPaymentTitle;
}

- (NSString *)verifying3DSRegisterCardTitle {
    if (!_verifying3DSRegisterCardTitle) {
        _verifying3DSRegisterCardTitle = @"verifying_card".localized;
    }
    return _verifying3DSRegisterCardTitle;
}

- (NSString *)securityMessageString {
    if (!_securityMessageString) {
        _securityMessageString = @"secure_server_transmission".localized;
    }
    return _securityMessageString;
}

- (NSString *)idealTransactionSuccessTitle {
    if (!_idealTransactionSuccessTitle) {
        _idealTransactionSuccessTitle = @"ideal_transaction_success".localized;
    }
    return _idealTransactionSuccessTitle;
}

- (NSString *)idealTransactionPendingTitle {
    if (!_idealTransactionPendingTitle) {
        _idealTransactionPendingTitle = @"ideal_transaction_pending".localized;
    }
    return _idealTransactionPendingTitle;
}

- (NSString *)idealTransactionPendingDelayTitle {
    if (!_idealTransactionPendingDelayTitle) {
        _idealTransactionPendingDelayTitle = @"ideal_transaction_pending_delay".localized;
    }
    return _idealTransactionPendingDelayTitle;
}

- (NSString *)idealTransactionTimeoutTitle {
    if (!_idealTransactionTimeoutTitle) {
        _idealTransactionTimeoutTitle = @"ideal_transaction_timeout".localized;
    }
    return _idealTransactionTimeoutTitle;
}

- (NSString *)idealTransactionErrorTitle {
    if (!_idealTransactionErrorTitle) {
        _idealTransactionErrorTitle = @"ideal_transaction_error".localized;
    }
    return _idealTransactionErrorTitle;
}

- (NSString *)idealTransactionFailedTitle {
    if (!_idealTransactionFailedTitle) {
        _idealTransactionFailedTitle = @"ideal_transaction_failed".localized;
    }
    return _idealTransactionFailedTitle;
}

- (NSString *)judoSelectBankTitle {
    if (!_judoSelectBankTitle) {
        _judoSelectBankTitle = @"select_ideal_bank".localized;
    }
    return _judoSelectBankTitle;
}

- (NSString *)judoSelectedBankTitle {
    if (!_judoSelectedBankTitle) {
        _judoSelectedBankTitle = @"selected_bank".localized;
    }
    return _judoSelectedBankTitle;
}

- (NSString *)judoIDEALNameInputFloatingTitle {
    if (!_judoIDEALNameInputFloatingTitle) {
        _judoIDEALNameInputFloatingTitle = @"name".localized;
    }
    return _judoIDEALNameInputFloatingTitle;
}

- (NSString *)judoIDEALNameInputPlaceholder {
    if (!_judoIDEALNameInputPlaceholder) {
        _judoIDEALNameInputPlaceholder = @"enter_name".localized;
    }
    return _judoIDEALNameInputPlaceholder;
}

#pragma mark - Sizes

- (CGFloat)inputFieldHeight {
    if (_inputFieldHeight == 0) {
        _inputFieldHeight = 68;
    }
    return _inputFieldHeight;
}

- (CGFloat)securityMessageTextSize {
    if (_securityMessageTextSize == 0) {
        _securityMessageTextSize = 12;
    }
    return _securityMessageTextSize;
}

#pragma mark - Colors
- (UIColor *)tintColor {
    if (_tintColor) {
        return _tintColor;
    }
    return [UIColor defaultTintColor];
}

- (UIColor *)judoTextColor {
    if (_judoTextColor) {
        return _judoTextColor;
    }
    UIColor *textColor = [UIColor thunder];
    if ([self.tintColor isDarkColor]) {
        return textColor;
    }
    return [textColor inverseColor];
}

- (UIColor *)judoNavigationBarTitleColor {
    if (_judoNavigationBarTitleColor) {
        return _judoNavigationBarTitleColor;
    }
    UIColor *navigationBarTintColor = [UIColor thunder];
    if ([self.tintColor isDarkColor]) {
        return navigationBarTintColor;
    }
    return [navigationBarTintColor inverseColor];
}

- (UIColor *)judoInputFieldTextColor {
    if (_judoInputFieldTextColor) {
        return _judoInputFieldTextColor;
    }
    UIColor *textColor = [UIColor darkGrayColor];
    if ([self.tintColor isDarkColor]) {
        return textColor;
    }
    return [textColor inverseColor];
}

- (UIColor *)judoPlaceholderTextColor {
    if (_judoPlaceholderTextColor) {
        return _judoPlaceholderTextColor;
    }
    UIColor *textColor = [UIColor magnesium];
    if ([self.tintColor isDarkColor]) {
        return textColor;
    }
    return [textColor inverseColor];
}

- (UIColor *)judoInputFieldBorderColor {
    return _judoInputFieldBorderColor ? _judoInputFieldBorderColor : [UIColor magnesium];
}

- (UIColor *)judoContentViewBackgroundColor {
    if (_judoContentViewBackgroundColor) {
        return _judoContentViewBackgroundColor;
    }

    UIColor *backgroundColor = [UIColor zircon];
    if ([self.tintColor isDarkColor]) {
        return backgroundColor;
    }
    return [backgroundColor inverseColor];
}

- (UIColor *)judoButtonColor {
    return _judoButtonColor ? _judoButtonColor : self.tintColor;
}

- (UIColor *)judoButtonTitleColor {
    if (_judoButtonTitleColor) {
        return _judoButtonTitleColor;
    }
    return [self.tintColor isDarkColor] ? [UIColor whiteColor] : [UIColor blackColor];
}

- (UIColor *)judoLoadingBackgroundColor {
    if (_judoLoadingBackgroundColor) {
        return _judoLoadingBackgroundColor;
    }
    UIColor *loadingBackgroundColor = [UIColor lightGray];
    if ([self.tintColor isDarkColor]) {
        return loadingBackgroundColor;
    }
    return [loadingBackgroundColor inverseColor];
}

- (UIColor *)judoErrorColor {
    return _judoErrorColor ? _judoErrorColor : [UIColor cgRed];
}

- (UIColor *)judoLoadingBlockViewColor {
    if (_judoLoadingBlockViewColor) {
        return _judoLoadingBlockViewColor;
    }
    if ([self.tintColor isDarkColor]) {
        return [UIColor whiteColor];
    }
    return [UIColor blackColor];
}

- (UIColor *)judoInputFieldBackgroundColor {
    return _judoInputFieldBackgroundColor ? _judoInputFieldBackgroundColor : _judoContentViewBackgroundColor;
}

- (UIColor *)judoActivityIndicatorColor {
    if (_judoActivityIndicatorColor) {
        return _judoActivityIndicatorColor;
    }
    return [self.tintColor isDarkColor] ? [UIColor grayColor] : [UIColor whiteColor];
}

#pragma mark - Payment Methods

- (CGFloat)buttonHeight {
    if (_buttonHeight <= 0) {
        _buttonHeight = 50;
    }
    return _buttonHeight;
}

- (CGFloat)buttonsSpacing {
    if (_buttonsSpacing <= 0) {
        _buttonsSpacing = 24;
    }
    return _buttonsSpacing;
}

- (UIFont *)buttonFont {
    if (!_buttonFont) {
        _buttonFont = [UIFont boldSystemFontOfSize:22.0];
    }
    return _buttonFont;
}

- (UIFont *)judoTextFont {
    if (!_judoTextFont) {
        _judoTextFont = [UIFont systemFontOfSize:16.0];
    }
    return _judoTextFont;
}

- (CGFloat)judoInputFieldBorderWidth {
    if (!_judoInputFieldBorderWidth) {
        _judoInputFieldBorderWidth = 0.0;
    }
    return _judoInputFieldBorderWidth;
}

#pragma mark - iDEAL Status View

- (UIColor *)iDEALStatusTitleColor {
    if (_iDEALStatusTitleColor) {
        return _iDEALStatusTitleColor;
    }
    return [self.tintColor isDarkColor] ? [UIColor blackColor] : [UIColor whiteColor];
}

- (UIFont *)iDEALStatusTitleFont {
    if (!_iDEALStatusTitleFont) {
        _iDEALStatusTitleFont = [UIFont boldSystemFontOfSize:20.0];
    }
    return _iDEALStatusTitleFont;
}

- (UIColor *)iDEALStatusSubtitleColor {
    if (_iDEALStatusSubtitleColor) {
        return _iDEALStatusSubtitleColor;
    }
    return [self.tintColor isDarkColor] ? [UIColor grayColor] : [UIColor whiteColor];
}

- (UIFont *)iDEALStatusSubtitleFont {
    if (!_iDEALStatusSubtitleFont) {
        _iDEALStatusSubtitleFont = [UIFont boldSystemFontOfSize:18.0];
    }
    return _iDEALStatusSubtitleFont;
}

- (NSString *)judoIDEALRetryButtonTitle {
    if (!_judoIDEALRetryButtonTitle) {
        _judoIDEALRetryButtonTitle = @"retry".localized;
    }
    return _judoIDEALRetryButtonTitle;
}

- (NSString *)judoIDEALCloseButtonTitle {
    if (!_judoIDEALCloseButtonTitle) {
        _judoIDEALCloseButtonTitle = @"close".localized;
    }
    return _judoIDEALCloseButtonTitle;
}

@end
