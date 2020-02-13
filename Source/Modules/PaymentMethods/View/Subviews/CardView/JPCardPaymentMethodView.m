//
//  JPCardView.m
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

#import "JPCardPaymentMethodView.h"
#import "Functions.h"
#import "JPPaymentMethodsViewModel.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIImage+Additions.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@interface JPCardPaymentMethodView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *expiryDateLabel;
@property (nonatomic, strong) UILabel *cardNumberLabel;

@end

@implementation JPCardPaymentMethodView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - View Model Configuration

- (void)configureWithViewModel:(JPPaymentMethodsHeaderModel *)viewModel {

    self.titleLabel.text = viewModel.cardModel.cardTitle;
    self.expiryDateLabel.text = viewModel.cardModel.cardExpiryDate;

    JPCardNetwork *network = [JPCardNetwork cardNetworkWithType:viewModel.cardModel.cardNetwork];
    NSString *substringPattern = [network.numberPattern substringToIndex:network.numberPattern.length - 4];
    NSString *stylizedPattern = [substringPattern stringByReplacingOccurrencesOfString:@"X" withString:@"•"];

    self.cardNumberLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                           stylizedPattern,
                                                           viewModel.cardModel.cardNumberLastFour];

    self.logoImageView.image = [UIImage imageForCardNetwork:viewModel.cardModel.cardNetwork];
}

#pragma mark - Layout Setup

- (void)setupViews {

    UIStackView *bottomStackView = [UIStackView horizontalStackViewWithSpacing:0];
    [bottomStackView addArrangedSubview:self.cardNumberLabel];
    [bottomStackView addArrangedSubview:self.expiryDateLabel];

    UIStackView *cardTitleStackView = [UIStackView verticalStackViewWithSpacing:24 * getWidthAspectRatio()];
    [cardTitleStackView addArrangedSubview:self.titleLabel];
    [cardTitleStackView addArrangedSubview:bottomStackView];

    UIStackView *logoStackView = [UIStackView horizontalStackViewWithSpacing:0.0];
    [logoStackView addArrangedSubview:self.logoImageView];
    [logoStackView addArrangedSubview:[UIView new]];

    UIStackView *mainStackView = [UIStackView verticalStackViewWithSpacing:0.0];
    [mainStackView addArrangedSubview:logoStackView];
    [mainStackView addArrangedSubview:[UIView new]];
    [mainStackView addArrangedSubview:cardTitleStackView];

    [self.logoImageView.widthAnchor constraintEqualToConstant:50.0 * getWidthAspectRatio()].active = YES;
    [self.logoImageView.heightAnchor constraintEqualToConstant:30.0 * getWidthAspectRatio()].active = YES;

    [self addSubview:mainStackView];
    [mainStackView pinToView:self withPadding:28.0 * getWidthAspectRatio()];
    [self applyGradients];
}

#pragma mark - Lazy Properties

- (void)applyGradients {
    [self layoutIfNeeded];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 400, 250);
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(1, 1);
    UIColor *colorOne = [UIColor colorWithRed:34.0 / 255.0 green:211 / 255.0 blue:198 / 255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:145 / 255.0 green:72.0 / 255.0 blue:203 / 255.0 alpha:1.0];
    gradient.colors = @[ (id)colorOne.CGColor, (id)colorTwo.CGColor ];
    [self.layer insertSublayer:gradient atIndex:0];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = UIFont.title;
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UILabel *)cardNumberLabel {
    if (!_cardNumberLabel) {
        _cardNumberLabel = [UILabel new];
        _cardNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _cardNumberLabel.font = UIFont.bodyBold;
        _cardNumberLabel.textColor = UIColor.jpLightGrayColor;
    }
    return _cardNumberLabel;
}

- (UILabel *)expiryDateLabel {
    if (!_expiryDateLabel) {
        _expiryDateLabel = [UILabel new];
        _expiryDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _expiryDateLabel.textAlignment = NSTextAlignmentRight;
        _expiryDateLabel.font = UIFont.bodyBold;
        _expiryDateLabel.textColor = UIColor.jpLightGrayColor;
    }
    return _expiryDateLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

@end
