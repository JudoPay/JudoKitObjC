//
//  JPAddCardInteractor.m
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

#import "JPAddCardInteractor.h"
#import "JPCard.h"
#import "JPCardValidationService.h"
#import "JPCountry.h"
#import "JPSession.h"
#import "JPTransactionService.h"
#import "NSError+Judo.h"

@interface JPAddCardInteractorImpl ()
@property (nonatomic, strong) JudoCompletionBlock completionHandler;
@property (nonatomic, strong) JPCardValidationService *cardValidationService;
@property (nonatomic, strong) JPTransactionService *transactionService;
@end

@implementation JPAddCardInteractorImpl

//------------------------------------------------------------------------------------
# pragma mark - Initializers
//------------------------------------------------------------------------------------

- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPTransactionService *)transactionService
                                   completion:(JudoCompletionBlock)completion {

    if (self = [super init]) {
        self.cardValidationService = cardValidationService;
        self.transactionService = transactionService;
        self.completionHandler = completion;
    }
    return self;
}

//------------------------------------------------------------------------------------
# pragma mark - Interactor Protocol Methods
//------------------------------------------------------------------------------------

- (BOOL)isAVSEnabled {
    return self.transactionService.avsEnabled;
}

- (void)addCard:(JPCard *)card completionHandler:(JudoCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;
    [self.transactionService addCard:card completionHandler:completionHandler];
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
    return [self.cardValidationService validateCardNumberInput:input];
}

@end
