//
//  JPCardCustomizationIsDefaultCell.m
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

#import "JPCardCustomizationIsDefaultCell.h"
#import "JPCardCustomizationViewModel.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIImage+Additions.h"
#import "UIStackView+Additions.h"

@interface JPCardCustomizationIsDefaultCell ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *checkmarkImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JPCardCustomizationIsDefaultCell

#pragma mark - Constants

const float kStackViewSpacing = 4.0f;
const float kStackViewVerticalPadding = 0.0f;
const float kStackViewHorizontalPadding = 24.0f;
const float kStackViewHeight = 23.0f;
const float kCheckmarkImageWidth = 23.0f;

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - View Model Configuration

- (void)configureWithViewModel:(JPCardCustomizationViewModel *)viewModel {
    if ([viewModel isKindOfClass:JPCardCustomizationIsDefaultModel.class]) {
        JPCardCustomizationIsDefaultModel *isDefaultModel;
        isDefaultModel = (JPCardCustomizationIsDefaultModel *)viewModel;

        NSString *iconName = isDefaultModel.isDefault ? @"radio-on" : @"radio-off";
        self.imageView.image = [UIImage imageWithIconName:iconName];
    }
}

#pragma mark - Layout setup

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.stackView addArrangedSubview:self.checkmarkImageView];
    [self.stackView addArrangedSubview:self.titleLabel];
    [self addSubview:self.stackView];
    [self setupConstraints];
}

- (void)setupConstraints {
    NSArray *constraints = @[
        [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor
                                                 constant:kStackViewVerticalPadding],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                    constant:-kStackViewVerticalPadding],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor
                                                     constant:kStackViewHorizontalPadding],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor
                                                      constant:-kStackViewHorizontalPadding],
        [self.stackView.heightAnchor constraintEqualToConstant:kStackViewHeight],
        [self.checkmarkImageView.widthAnchor constraintEqualToConstant:kCheckmarkImageWidth],
    ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Lazy properties

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView horizontalStackViewWithSpacing:kStackViewSpacing];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

- (UIImageView *)checkmarkImageView {
    if (!_checkmarkImageView) {
        _checkmarkImageView = [UIImageView new];
        _checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _checkmarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _checkmarkImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = @"save_as_default".localized;
        _titleLabel.textColor = UIColor.jpBlackColor;
        _titleLabel.font = UIFont.body;
    }
    return _titleLabel;
}

@end
