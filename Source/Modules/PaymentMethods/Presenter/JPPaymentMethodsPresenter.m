//
//  JPPaymentMethodsPresenter.m
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

#import "JPPaymentMethodsPresenter.h"
#import "JPAddCardViewModel.h"
#import "JPAmount.h"
#import "JPCardNetwork.h"
#import "JPPaymentMethodsInteractor.h"
#import "JPPaymentMethodsRouter.h"
#import "JPPaymentMethodsViewController.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPStoredCardDetails.h"
#import "NSString+Additions.h"

@interface JPPaymentMethodsPresenterImpl ()
@property (nonatomic, strong) JPPaymentMethodsViewModel *viewModel;
@property (nonatomic, strong) JPPaymentMethodsHeaderModel *headerModel;
@property (nonatomic, strong) JPPaymentMethodsSelectionModel *paymentSelectionModel;
@property (nonatomic, strong) JPPaymentMethodsEmptyListModel *emptyListModel;
@property (nonatomic, strong) JPPaymentMethodsCardHeaderModel *cardHeaderModel;
@property (nonatomic, strong) JPPaymentMethodsCardFooterModel *cardFooterModel;
@property (nonatomic, strong) JPPaymentMethodsCardListModel *cardListModel;
@property (nonatomic, strong) JPPaymentMethodsIDEALBankListModel *iDealBankListModel;
@property (nonatomic, strong) JPPaymentMethodsApplePayModel *applePayModel;
@property (nonatomic, strong) JPAddCardButtonViewModel *paymentButtonModel;

@property (nonatomic, assign) int previousIndex;
@end

@implementation JPPaymentMethodsPresenterImpl

#pragma mark - Protocol Conformance

- (void)viewModelNeedsUpdate {
    [self updateViewModelWithAnimationType:AnimationTypeSetup];
    [self.view configureWithViewModel:self.viewModel];
}

- (void)viewModelNeedsUpdateWithAnimationType:(AnimationType)animationType {
    [self updateViewModelWithAnimationType:animationType];
    [self.view configureWithViewModel:self.viewModel];
}

- (void)didSelectCardAtIndex:(NSInteger)index {
    [self.interactor selectCardAtIndex:index];
    if (self.headerModel.cardModel) {
        [self viewModelNeedsUpdateWithAnimationType:AnimationTypeBottomToTop];
    } else {
        [self viewModelNeedsUpdateWithAnimationType:AnimationTypeSetup];
    }
}

#pragma mark - Action Handlers

- (void)handleAddCardButtonTap {
    [self.router navigateToAddCardModule];
}

- (void)handleBackButtonTap {
    [self.router dismissViewController];
}

- (void)handlePayButtonTap {
    [self.interactor paymentTransactionWithToken:self.selectedCard.cardToken
                                   andCompletion:^(JPResponse *response, NSError *error) {
                                       if (error) {
                                           [self handlePaymentError:error];
                                           return;
                                       }
                                       [self handlePaymentResponse:response];
                                   }];
}

- (void)handlePaymentResponse:(JPResponse *)response {
    [self.router completeTransactionWithResponse:response andError:nil];
    [self.router dismissViewController];
}

- (void)handlePaymentError:(NSError *)error {
    [self.router completeTransactionWithResponse:nil andError:error];
    [self.view displayAlertWithTitle:@"card_transaction_unsuccesful_error".localized andError:error];
}

- (void)deleteCardWithIndex:(NSInteger)index {
    [self.interactor deleteCardWithIndex:index];
    self.viewModel.headerModel.cardModel = nil;
}

- (void)changeHeaderButtonTitle:(BOOL)isEditing {
    if (isEditing) {
        self.cardHeaderModel.editButtonTitle = [@"done_capitalized" localized];
    } else {
        self.cardHeaderModel.editButtonTitle = [@"edit_capitalized" localized];
    }
    [self updateViewModelWithAnimationType:AnimationTypeNone];
    [self.view configureWithViewModel:self.viewModel];
}

- (void)changePaymentMethodToIndex:(int)index {
    AnimationType animationType = (index < self.previousIndex) ? AnimationTypeRightToLeft : AnimationTypeLeftToRight;
    self.previousIndex = index;

    self.paymentSelectionModel.selectedPaymentMethod = index;
    [self updateViewModelWithAnimationType:animationType];
    [self.view configureWithViewModel:self.viewModel];
}

#pragma mark - Helper methods

- (void)updateViewModelWithAnimationType:(AnimationType)animationType {
    [self.viewModel.items removeAllObjects];
    self.viewModel.shouldDisplayHeadline = [self.interactor shouldDisplayJudoHeadline];

    [self prepareHeaderModel];
    self.viewModel.headerModel.animationType = animationType;

    [self preparePaymentMethodModels];
}

- (void)preparePaymentMethodModels {

    NSArray *paymentMethods = [self.interactor getPaymentMethods];

    if (paymentMethods.count > 1) {
        self.paymentSelectionModel.paymentMethods = paymentMethods;
        [self.viewModel.items addObject:self.paymentSelectionModel];
    }

    int selectedPaymentIndex = self.paymentSelectionModel.selectedPaymentMethod;
    JPPaymentMethod *selectedPaymentMethod = self.paymentSelectionModel.paymentMethods[selectedPaymentIndex];

    switch (selectedPaymentMethod.type) {
        case JPPaymentMethodTypeCard:
            [self prepareCardListModels];
            break;

        case JPPaymentMethodTypeIDeal:
            [self.viewModel.items addObject:self.iDealBankListModel];
            break;

        case JPPaymentMethodTypeApplePay:
            [self.viewModel.items addObject:self.applePayModel];
            break;

        default:
            break;
    }
}

- (void)prepareCardListModels {
    NSArray<JPStoredCardDetails *> *cardDetailsArray = [self.interactor getStoredCardDetails];

    if (cardDetailsArray.count == 0) {
        [self.viewModel.items addObject:self.emptyListModel];
    } else {
        [self prepareCardModelsForStoredCardDetails:cardDetailsArray];
        [self.viewModel.items addObject:self.cardHeaderModel];
        [self.viewModel.items addObject:self.cardListModel];
        [self.viewModel.items addObject:self.cardFooterModel];
    }
}

- (void)prepareHeaderModel {
    self.headerModel.amount = [self.interactor getAmount];
    self.headerModel.payButtonModel = self.paymentButtonModel;
    self.headerModel.payButtonModel.isEnabled = NO;
    NSArray *storedCardDetails = [self.interactor getStoredCardDetails];

    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        if (cardDetails.isSelected) {
            self.headerModel.cardModel = [self cardModelFromStoredCardDetails:cardDetails];
            self.headerModel.payButtonModel.isEnabled = YES;
        }
    }

    self.viewModel.headerModel = self.headerModel;
}

- (void)prepareCardModelsForStoredCardDetails:(NSArray<JPStoredCardDetails *> *)storedCardDetails {
    [self.cardListModel.cardModels removeAllObjects];
    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        JPPaymentMethodsCardModel *cardModel = [self cardModelFromStoredCardDetails:cardDetails];
        [self.cardListModel.cardModels addObject:cardModel];
    }
}

- (JPPaymentMethodsCardModel *)cardModelFromStoredCardDetails:(JPStoredCardDetails *)cardDetails {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];

    //TODO: Replace with actual card name once card editing is available
    cardModel.cardTitle = @"Card for shopping";

    cardModel.cardNetwork = cardDetails.cardNetwork;
    cardModel.cardNumberLastFour = cardDetails.cardLastFour;
    cardModel.cardExpiryDate = cardDetails.expiryDate;
    cardModel.isDefaultCard = cardDetails.isDefault;
    cardModel.isSelected = cardDetails.isSelected;

    return cardModel;
}

- (JPStoredCardDetails *)selectedCard {
    for (JPStoredCardDetails *card in [self.interactor getStoredCardDetails]) {
        if (card.isSelected) {
            return card;
        }
    }
    return nil;
}

#pragma mark - Lazy properties

- (JPPaymentMethodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [JPPaymentMethodsViewModel new];
        _viewModel.shouldDisplayHeadline = NO;
        _viewModel.items = [NSMutableArray new];
    }
    return _viewModel;
}

- (JPPaymentMethodsHeaderModel *)headerModel {
    if (!_headerModel) {
        _headerModel = [JPPaymentMethodsHeaderModel new];
        _headerModel.amount = [JPAmount amount:@"0.0" currency:@"GBP"];
    }
    return _headerModel;
}

- (JPPaymentMethodsIDEALBankListModel *)iDealBankListModel {
    if (!_iDealBankListModel) {
        _iDealBankListModel = [JPPaymentMethodsIDEALBankListModel new];
        _iDealBankListModel.identifier = @"JPPaymentMethodsCell";
    }
    return _iDealBankListModel;
}

- (JPPaymentMethodsApplePayModel *)applePayModel {
    if (!_applePayModel) {
        _applePayModel = [JPPaymentMethodsApplePayModel new];
        _applePayModel.identifier = @"JPPaymentMethodsCell";
    }
    return _applePayModel;
}

- (JPPaymentMethodsSelectionModel *)paymentSelectionModel {
    if (!_paymentSelectionModel) {
        _paymentSelectionModel = [JPPaymentMethodsSelectionModel new];
        _paymentSelectionModel.identifier = @"JPPaymentMethodsSelectionCell";
    }
    return _paymentSelectionModel;
}

- (JPPaymentMethodsEmptyListModel *)emptyListModel {
    if (!_emptyListModel) {
        _emptyListModel = [JPPaymentMethodsEmptyListModel new];
        _emptyListModel.identifier = @"JPPaymentMethodsEmptyCardListCell";
        _emptyListModel.title = @"no_connected_cards".localized;
        _emptyListModel.addCardButtonTitle = @"add_card_button".localized;
        _emptyListModel.addCardButtonIconName = @"plus-icon";

        __weak typeof(self) weakSelf = self;
        _emptyListModel.onAddCardButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _emptyListModel;
}

- (JPPaymentMethodsCardHeaderModel *)cardHeaderModel {
    if (!_cardHeaderModel) {
        _cardHeaderModel = [JPPaymentMethodsCardHeaderModel new];
        _cardHeaderModel.title = @"connected_cards".localized;
        _cardHeaderModel.editButtonTitle = @"edit_capitalized".localized;
        _cardHeaderModel.identifier = @"JPPaymentMethodsCardListHeaderCell";
    }
    return _cardHeaderModel;
}

- (JPPaymentMethodsCardFooterModel *)cardFooterModel {
    if (!_cardFooterModel) {
        _cardFooterModel = [JPPaymentMethodsCardFooterModel new];
        _cardFooterModel.addCardButtonTitle = @"add_card_button".localized;
        _cardFooterModel.addCardButtonIconName = @"plus-icon";
        _cardFooterModel.identifier = @"JPPaymentMethodsCardListFooterCell";

        __weak typeof(self) weakSelf = self;
        _cardFooterModel.onAddCardButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _cardFooterModel;
}

- (JPPaymentMethodsCardListModel *)cardListModel {
    if (!_cardListModel) {
        _cardListModel = [JPPaymentMethodsCardListModel new];
        _cardListModel.cardModels = [NSMutableArray new];
        _cardListModel.identifier = @"JPPaymentMethodsCardCell";
    }
    return _cardListModel;
}

- (JPPaymentMethodsCardModel *)cardModel {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];
    return cardModel;
}

- (JPAddCardButtonViewModel *)paymentButtonModel {
    if (!_paymentButtonModel) {
        _paymentButtonModel = [JPAddCardButtonViewModel new];
        _paymentButtonModel.title = @"pay_now_capitalized".localized;
        _paymentButtonModel.isEnabled = NO;
    }
    return _paymentButtonModel;
}

@end
