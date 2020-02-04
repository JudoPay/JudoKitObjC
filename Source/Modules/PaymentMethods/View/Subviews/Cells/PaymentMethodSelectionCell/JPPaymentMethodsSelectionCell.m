//
//  JPPaymentMethodsSelectionCell.m
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

#import "JPPaymentMethodsSelectionCell.h"
#import "JPSectionView.h"
#import "UIImage+Icons.h"
#import "UIView+Additions.h"

@interface JPPaymentMethodsSelectionCell ()

@property (nonatomic, strong) JPSectionView *sectionView;

@end

@implementation JPPaymentMethodsSelectionCell

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLayout];
    }
    return self;
}

#pragma mark - Layout setup

- (void)setupLayout {

    self.backgroundColor = UIColor.whiteColor;

    self.sectionView = [JPSectionView new];
    [self addSubview:self.sectionView];

    self.sectionView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.sectionView.topAnchor constraintEqualToAnchor:self.topAnchor
                                                   constant:25.0f],
        [self.sectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                      constant:-25.0f],
        [self.sectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.sectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.sectionView.heightAnchor constraintEqualToConstant:64]
    ]];
}

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPPaymentMethodsModel *)viewModel {

    //TODO: Remove hard-coded values with real configuration

    [self.sectionView removeSections];

    UIImage *cardsImage = [UIImage imageWithIconName:@"cards-pay-icon"];
    UIImage *idealImage = [UIImage imageWithIconName:@"ideal-pay-icon"];
    UIImage *appleImage = [UIImage imageWithIconName:@"apple-pay-icon"];
    UIImage *amazonImage = [UIImage imageWithIconName:@"amazon-pay-icon"];

    [self.sectionView addSectionWithImage:cardsImage andTitle:@"Cards"];
    [self.sectionView addSectionWithImage:idealImage andTitle:@"iDeal"];
    [self.sectionView addSectionWithImage:appleImage andTitle:nil];
    [self.sectionView addSectionWithImage:amazonImage andTitle:@"Amazon Pay"];
}

@end
