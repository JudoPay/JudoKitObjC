//
//  JPAddCardView.m
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

#import "JPAddCardView.h"
#import "RoundedCornerView.h"
#import "UIFont+Custom.h"
#import "UIColor+Hex.h"
#import "NSString+Localize.h"
#import "UIView+Constraints.h"
#import "UIView+Layout.h"
#import "UIImage+Icons.h"
#import "UIStackView+Additions.h"

@interface JPAddCardView ()

@property (nonatomic, strong) RoundedCornerView *bottomSlider;
@property (nonatomic, strong) UITextField *cardholderNameTextField;
@property (nonatomic, strong) UITextField *expirationDateTextField;
@property (nonatomic, strong) UITextField *lastDigitsTextField;
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic, strong) UIImageView *lockImageView;

@end

@implementation JPAddCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.backgroundView];
    [self addSubview:self.bottomSlider];
    [self.bottomSlider addSubview:self.mainStackView];
}

- (void)setupConstraints {
    [self.backgroundView pinToView:self withPadding:0.0];
    [self setupBottomSliderConstraints];
    [self setupMainStackViewConstraints];
    [self setupContentsConstraints];
}

- (void)setupBottomSliderConstraints {
    [self.bottomSlider pinToAnchors:AnchorTypeLeading|AnchorTypeTrailing
                            forView:self];
    self.bottomSliderConstraint = [self.bottomSlider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    self.bottomSliderConstraint.active = YES;
}

- (void)setupMainStackViewConstraints {
    
    [self.mainStackView pinToAnchors:AnchorTypeTop
                             forView:self.bottomSlider
                         withPadding:20.0];
    
    [self.mainStackView pinToAnchors:AnchorTypeLeading | AnchorTypeTrailing
                             forView:self.bottomSlider
                         withPadding:24.0];
    
    [self.mainStackView pinToAnchors:AnchorTypeBottom
                             forView:self.bottomSlider
                         withPadding:32.0];
}

- (void)setupContentsConstraints {
    NSArray *constraints = @[
        [self.bottomSlider.heightAnchor constraintEqualToConstant:354.0],
        [self.scanCardButton.heightAnchor constraintEqualToConstant:36.0],
        [self.cardInputTextField.heightAnchor constraintEqualToConstant:44.0],
        [self.cardholderNameTextField.heightAnchor constraintEqualToConstant:44.0],
        [self.expirationDateTextField.heightAnchor constraintEqualToConstant:44.0],
        [self.lastDigitsTextField.heightAnchor constraintEqualToConstant:44.0],
        [self.addCardButton.heightAnchor constraintEqualToConstant:46.0],
        [self.lockImageView.widthAnchor constraintEqualToConstant:17.0],
    ];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Lazily instantiated properties

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundView;
}

- (UIView *)bottomSlider {
    if (!_bottomSlider) {
        UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
        _bottomSlider = [[RoundedCornerView alloc] initWithRadius:10.0 forCorners:corners];
        _bottomSlider.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomSlider.backgroundColor = UIColor.whiteColor;
    }
    return _bottomSlider;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        _cancelButton.titleLabel.font = [UIFont SFProDisplaySemiboldWithSize:14.0];
        [_cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)scanCardButton {
    if (!_scanCardButton) {
        _scanCardButton = [UIButton new];
        _scanCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_scanCardButton setTitle:@"SCAN CARD" forState:UIControlStateNormal];
        [_scanCardButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _scanCardButton.titleLabel.font = [UIFont SFProDisplaySemiboldWithSize:14.0];
        
        [_scanCardButton setImage:[UIImage imageWithIconName:@"scan-card"]
                         forState:UIControlStateNormal];
        _scanCardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_scanCardButton setBorderWithColor:UIColor.blackColor width:1.0f andCornerRadius:4.0f];
        
        _scanCardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
        _scanCardButton.contentEdgeInsets = UIEdgeInsetsMake(5, -20, 5, 5);
        
    }
    return _scanCardButton;
}

- (UITextField *)cardInputTextField {
    if (!_cardInputTextField) {
        _cardInputTextField = [UITextField new];
        _cardInputTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _cardInputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _cardInputTextField.layer.cornerRadius = 6.0f;
        _cardInputTextField.backgroundColor = [UIColor colorFromHex:0xE5E5E5];
        _cardInputTextField.placeholder = @"Card Number";
    }
    return _cardInputTextField;
}

- (UITextField *)cardholderNameTextField {
    if (!_cardholderNameTextField) {
        _cardholderNameTextField = [UITextField new];
        _cardholderNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _cardholderNameTextField.layer.cornerRadius = 6.0f;
        _cardholderNameTextField.backgroundColor = [UIColor colorFromHex:0xE5E5E5];
        _cardholderNameTextField.placeholder = @"Cardholder Name";
    }
    return _cardholderNameTextField;
}

- (UITextField *)expirationDateTextField {
    if (!_expirationDateTextField) {
        _expirationDateTextField = [UITextField new];
        _expirationDateTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _expirationDateTextField.layer.cornerRadius = 6.0f;
        _expirationDateTextField.backgroundColor = [UIColor colorFromHex:0xE5E5E5];
        _expirationDateTextField.placeholder = @"MM/YY";
    }
    return _expirationDateTextField;
}

- (UITextField *)lastDigitsTextField {
    if (!_lastDigitsTextField) {
        _lastDigitsTextField = [UITextField new];
        _lastDigitsTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _lastDigitsTextField.layer.cornerRadius = 6.0f;
        _lastDigitsTextField.backgroundColor = [UIColor colorFromHex:0xE5E5E5];
        _lastDigitsTextField.placeholder = @"CVV";
    }
    return _lastDigitsTextField;
}

- (UIButton *)addCardButton {
    if (!_addCardButton) {
        _addCardButton = [UIButton new];
        _addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addCardButton.titleLabel.font = [UIFont SFProDisplaySemiboldWithSize:16.0f];
        _addCardButton.layer.cornerRadius = 4.0f;
        [_addCardButton setTitle:@"ADD CARD" forState:UIControlStateNormal];
        _addCardButton.backgroundColor = [UIColor colorFromHex:0x262626];
    }
    return _addCardButton;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [UIImageView new];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _lockImageView.image = [UIImage imageWithIconName:@"lock-icon"];;
    }
    return _lockImageView;
}

- (UILabel *)securityMessageLabel {
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"secure_server_transmission".localized;
    label.numberOfLines = 0;
    label.font = [UIFont SFProTextRegularWithSize:10.0];
    label.textColor = [UIColor colorFromHex:0x999999];
    return label;
}

- (UIStackView *)mainStackView {
    if (!_mainStackView) {
        _mainStackView = [UIStackView verticalStackViewWithSpacing:16.0];
        
        [_mainStackView addArrangedSubview:self.topButtonStackView];
        [_mainStackView addArrangedSubview:self.inputFieldsStackView];
        [_mainStackView addArrangedSubview:self.buttonStackView];
        
    }
    return _mainStackView;
}

- (UIStackView *)topButtonStackView {
    UIStackView *stackView = [UIStackView new];
    
    [stackView addArrangedSubview:self.cancelButton];
    [stackView addArrangedSubview:[UIView new]];
    [stackView addArrangedSubview:self.scanCardButton];
    
    return stackView;
}

- (UIStackView *)additionalInputFieldsStackView {
    UIStackView *stackView = [UIStackView horizontalStackViewWithSpacing:8.0];
    stackView.distribution = UIStackViewDistributionFillEqually;

    [stackView addArrangedSubview:self.expirationDateTextField];
    [stackView addArrangedSubview:self.lastDigitsTextField];
    
    return stackView;
}

- (UIStackView *)inputFieldsStackView {
    UIStackView *stackView = [UIStackView verticalStackViewWithSpacing:8.0];
    
    [stackView addArrangedSubview:self.cardInputTextField];
    [stackView addArrangedSubview:self.cardholderNameTextField];
    [stackView addArrangedSubview:self.additionalInputFieldsStackView];
    
    return stackView;
}

- (UIStackView *)securityMessageStackView {
    UIStackView *stackView = [UIStackView horizontalStackViewWithSpacing:8.0];
    [stackView addArrangedSubview:self.lockImageView];
    [stackView addArrangedSubview:self.securityMessageLabel];
    return stackView;
}

- (UIStackView *)buttonStackView {
    UIStackView *stackView = [UIStackView verticalStackViewWithSpacing:16.0];
    [stackView addArrangedSubview:self.addCardButton];
    [stackView addArrangedSubview:self.securityMessageStackView];
    return stackView;
}

@end