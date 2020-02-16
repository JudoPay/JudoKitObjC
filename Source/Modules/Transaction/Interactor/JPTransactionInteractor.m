//
//  JPTransactionInteractor.m
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

#import "JPTransactionInteractor.h"
#import "JPTransactionViewModel.h"
#import "JPCard.h"
#import "JPCardStorage.h"
#import "JPCardValidationService.h"
#import "JPCountry.h"
#import "JPKeychainService.h"
#import "JPSession.h"
#import "JPStoredCardDetails.h"
#import "JPTransactionService.h"
#import "NSError+Additions.h"

@interface JPTransactionInteractorImpl ()
@property (nonatomic, strong) JudoCompletionBlock completionHandler;
@property (nonatomic, strong) JPCardValidationService *cardValidationService;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@end

@implementation JPTransactionInteractorImpl

#pragma mark - Initializers

- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPTransactionService *)transactionService
                                configuration:(JPConfiguration *)configuration
                                   completion:(JudoCompletionBlock)completion {

    if (self = [super init]) {
        self.cardValidationService = cardValidationService;
        self.transactionService = transactionService;
        self.configuration = configuration;
        self.completionHandler = completion;
    }
    return self;
}

#pragma mark - Interactor Protocol Methods

- (BOOL)isAVSEnabled {
    return self.configuration.isAVSEnabled;
}

- (TransactionType)transactionType {
    return self.transactionService.transactionType;
}

- (void)handleCameraPermissionsWithCompletion:(void (^)(AVAuthorizationStatus))completion {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     completion(granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied);
                                 }];
    } else {
        completion(status);
    }
}

- (void)addCard:(JPCard *)card completionHandler:(JudoCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;
    //[self.transactionService addCard:card completionHandler:completionHandler];
}

- (void)updateKeychainWithCardModel:(JPTransactionViewModel *)viewModel andToken:(NSString *)token {

    CardNetwork cardNetwork = viewModel.cardNumberViewModel.cardNetwork;
    NSString *cardNumberString = viewModel.cardNumberViewModel.text;

    NSString *lastFour = [cardNumberString substringFromIndex:cardNumberString.length - 4];
    NSString *expiryDate = viewModel.expiryDateViewModel.text;

    JPStoredCardDetails *storedCardDetails = [JPStoredCardDetails cardDetailsWithLastFour:lastFour
                                                                               expiryDate:expiryDate
                                                                              cardNetwork:cardNetwork
                                                                                cardToken:token];

    [JPCardStorage.sharedInstance addCardDetails:storedCardDetails];
}

- (NSArray<NSString *> *)getSelectableCountryNames {
    return @[
        [JPCountry countryWithType:JPCountryTypeUK].name,
        [JPCountry countryWithType:JPCountryTypeUSA].name,
        [JPCountry countryWithType:JPCountryTypeCanada].name,
        [JPCountry countryWithType:JPCountryTypeOther].name,
    ];
}

- (JPValidationResult *)validateCardNumberInput:(NSString *)input {
    return [self.cardValidationService validateCardNumberInput:input
                                          forSupportedNetworks:self.configuration.supportedCardNetworks];
}

- (JPValidationResult *)validateCardholderNameInput:(NSString *)input {
    return [self.cardValidationService validateCarholderNameInput:input];
}

- (JPValidationResult *)validateExpiryDateInput:(NSString *)input {
    return [self.cardValidationService validateExpiryDateInput:input];
}

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input {
    return [self.cardValidationService validateSecureCodeInput:input];
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    return [self.cardValidationService validateCountryInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {
    return [self.cardValidationService validatePostalCodeInput:input];
}

@end
