//
//  JPCardInputField.m
//  InputFieldTest
//
//  Created by Mihai Petrenco on 12/10/19.
//  Copyright © 2019 Mihai Petrenco. All rights reserved.
//

#import "JPCardNumberField.h"
#import "UIColor+Judo.h"
#import "UIFont+Additions.h"
#import "UIImage+Icons.h"

@interface JPCardNumberField ()
@property (nonatomic, strong) UIImageView *cardLogoImageView;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation JPCardNumberField

@dynamic stackView;

//------------------------------------------------------------------------------------
# pragma mark - Initializers
//------------------------------------------------------------------------------------

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupCardNumberViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCardNumberViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupCardNumberViews];
    }
    return self;
}

//------------------------------------------------------------------------------------
# pragma mark - View Model Configuration
//------------------------------------------------------------------------------------

- (void)configureWithViewModel:(JPAddCardNumberInputViewModel *)viewModel {
    
    self.type = viewModel.type;
    
    UIFont *placeholderFont = (viewModel.errorText) ? UIFont.smallTextFont : UIFont.defaultTextFont;
    [self setCardNetwork:viewModel.cardNetwork];
    
    [self placeholderWithText:viewModel.placeholder
                        color:UIColor.jpPlaceholderColor
                      andFont:placeholderFont];
    
    self.text = viewModel.text;
    
    if (viewModel.errorText) {
        [self displayErrorWithText:viewModel.errorText];
        return;
    }
    
    [self clearError];
}

//------------------------------------------------------------------------------------
# pragma mark - Public Methods
//------------------------------------------------------------------------------------

- (void)setCardNetwork:(CardNetwork)cardNetwork {
    
    UIImage *cardIcon = [self iconForCardNetwork:cardNetwork];
    
    if (cardIcon) self.cardLogoImageView.image = cardIcon;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cardLogoImageView.alpha = (cardIcon) ? 1.0 : 0.0;
    } completion:^(BOOL finished) {
        if (!cardIcon) self.cardLogoImageView.image = cardIcon;
    }];
}

- (UIImage *)iconForCardNetwork:(CardNetwork)cardNetwork {
    switch (cardNetwork) {
        case CardNetworkAMEX:
            return [UIImage imageWithIconName:@"card-amex"];
        case CardNetworkDinersClub:
            return [UIImage imageWithIconName:@"card-diners"];
        case CardNetworkDiscover:
            return [UIImage imageWithIconName:@"card-discover"];
        case CardNetworkJCB:
            return [UIImage imageWithIconName:@"card-jcb"];
        case CardNetworkMaestro:
            return [UIImage imageWithIconName:@"card-maestro"];
        case CardNetworkMasterCard:
            return [UIImage imageWithIconName:@"card-mastercard"];
        case CardNetworkChinaUnionPay:
            return [UIImage imageWithIconName:@"card-unionpay"];
        case CardNetworkVisa:
            return [UIImage imageWithIconName:@"card-visa"];
        default:
            return nil;
    }
}

//------------------------------------------------------------------------------------
#pragma mark - Layout Setup
//------------------------------------------------------------------------------------

- (void)setupCardNumberViews {
    [self.cardLogoImageView.widthAnchor constraintEqualToConstant:50.0].active = YES;
    [self.stackView addArrangedSubview:self.cardLogoImageView];
}

//------------------------------------------------------------------------------------
#pragma mark - Lazy Properties
//------------------------------------------------------------------------------------

- (UIImageView *)cardLogoImageView {
    if (!_cardLogoImageView) {
        _cardLogoImageView = [UIImageView new];
        _cardLogoImageView.alpha = 0.0;
        _cardLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _cardLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cardLogoImageView;
}

@end
