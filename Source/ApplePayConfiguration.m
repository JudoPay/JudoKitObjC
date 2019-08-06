//
//  AppDelegate.h
//  JudoKitObjCExample
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

#import "ApplePayConfiguration.h"
#import "ExampleAppCredentials.h"

@implementation ApplePayConfiguration

#pragma mark - Initializers

- (instancetype)init {
    
    if (self = [super init]) {
        [self setupDefaults];
    }
    
    return self;
}

- (instancetype)initWithJudoId:(NSString *)judoId
                     reference:(NSString *)reference
                    merchantId:(NSString *)merchantId
                      currency:(NSString *)currency
                   countryCode:(NSString *)countryCode
           paymentSummaryItems:(NSArray<PKPaymentSummaryItem *> *)paymentSummaryItems {
    
    self = [self init];
    
    self.judoId = judoId;
    self.reference = reference;
    self.merchantId = merchantId;
    self.currency = currency;
    self.countryCode = countryCode;
    self.paymentSummaryItems = paymentSummaryItems;
    
    return self;
}

#pragma mark - Instance methods

- (PKPaymentRequest *)generatePaymentRequest {
    
    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];
    paymentRequest.merchantIdentifier = self.merchantId;
    
    paymentRequest.countryCode = self.countryCode;
    paymentRequest.currencyCode = self.currency;
    
    paymentRequest.supportedNetworks = self.pkPaymentNetworks;
    paymentRequest.merchantCapabilities = self.merchantCapabilities;
    
    paymentRequest.paymentSummaryItems = self.paymentSummaryItems;
    
    return paymentRequest;
}

#pragma mark - Helper methods

- (void)setupDefaults {
    self.judoId = judoId;
    self.merchantId = merchantId;
    self.merchantCapabilities = PKMerchantCapability3DS;
    self.shippingType = PKShippingTypeShipping;
    self.returnedContactInfo = BillingContacts | BillingAddress;
    self.supportedCardNetworks = @[@(CardNetworkVisa), @(CardNetworkMaestro), @(CardNetworkAMEX)];
    
    // Adds Maestro to the list of available card networks if iOS 12 or above
    if (@available(iOS 12.0, *)) {
        self.supportedCardNetworks = [self.supportedCardNetworks arrayByAddingObject:@(CardNetworkMaestro)];
    }
}

- (nullable PKPaymentNetwork)pkPaymentNetworkForCardNetwork: (CardNetwork)cardNetwork {
    
    switch (cardNetwork) {
        case CardNetworkVisa:
            return PKPaymentNetworkVisa;
            
        case CardNetworkMasterCard:
            return PKPaymentNetworkMasterCard;
            
        case CardNetworkAMEX:
            return PKPaymentNetworkAmex;
            
        case CardNetworkMaestro:
            if (@available(iOS 12.0, *)) {
                return PKPaymentNetworkMaestro;
            } else {
                return nil;
            }
            
        default:
            return nil;
    }
}

- (NSArray<PKPaymentNetwork> *)pkPaymentNetworks {
    
    NSMutableArray<PKPaymentNetwork> *pkPaymentNetworks = [[NSMutableArray alloc] init];
    
    for (NSNumber *cardNetwork in self.supportedCardNetworks) {
        PKPaymentNetwork network = [self pkPaymentNetworkForCardNetwork: cardNetwork.intValue];
        if (network) [pkPaymentNetworks addObject: network];
    }
    
    return pkPaymentNetworks;
}

@end
