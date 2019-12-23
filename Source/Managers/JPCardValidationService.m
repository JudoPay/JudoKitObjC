//
//  JPCardValidationService.m
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

#import "JPCardValidationService.h"
#import "BillingCountry.h"
#import "JPCardNetwork.h"
#import "JPValidationResult.h"
#import "NSError+Judo.h"
#import "NSString+Card.h"
#import "NSString+Localize.h"

@interface JPCardValidationService ()

@property (nonatomic, strong) JPValidationResult *lastCardNumberValidationResult;
@property (nonatomic, strong) JPValidationResult *lastExpiryDateValidationResult;
@property (nonatomic, strong) JPValidationResult *lastSecureCodeValidationResult;
@property (nonatomic, strong) JPValidationResult *lastPostalCodeValidationResult;
@property (nonatomic, strong) NSString *selectedBillingCountry;
@end

@implementation JPCardValidationService

#pragma mark - Public Methods

- (JPValidationResult *)validateCardNumberInput:(NSString *)input {

    NSError *error;
    NSString *presentationString = [input cardPresentationStringWithAcceptedNetworks:self.acceptedCardNetworks
                                                                               error:&error];

    NSString *trimmedString = [input stringByReplacingOccurrencesOfString:@" "
                                                               withString:@""];

    if (input.cardNetwork == CardNetworkAMEX || input.cardNetwork == CardNetworkUATP) {
        if (trimmedString.length > 15) {
            return self.lastCardNumberValidationResult;
        }
    }

    if (trimmedString.length > 16) {
        return self.lastCardNumberValidationResult;
    }

    if ([input isCardNumberValid]) {
        self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:YES
                                                                          inputAllowed:YES
                                                                          errorMessage:nil
                                                                        formattedInput:presentationString];

        self.lastCardNumberValidationResult.cardNetwork = input.cardNetwork;
        return self.lastCardNumberValidationResult;
    }

    if (input.cardNetwork == CardNetworkAMEX || input.cardNetwork == CardNetworkUATP) {
        if (trimmedString.length == 15) {
            error = NSError.judoInvalidCardNumberError;
        }
    }

    if (trimmedString.length == 16) {
        error = NSError.judoInvalidCardNumberError;
    }

    self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:(presentationString != nil)
                                                                      errorMessage:error.localizedDescription
                                                                    formattedInput:presentationString];

    self.lastCardNumberValidationResult.cardNetwork = input.cardNetwork;
    return self.lastCardNumberValidationResult;
}

- (JPValidationResult *)validateCarholderNameInput:(NSString *)input {
    return [JPValidationResult validationWithResult:input.length > 3
                                       inputAllowed:YES
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validateExpiryDateInput:(NSString *)input {

    if (input.length == 0) {
        return [self validateNoExpiryDigitInput:input];
    }

    if (input.length == 1) {
        return [self validateFirstExpiryDigitInput:input];
    }

    if (input.length == 2) {
        return [self validateSecondExpiryDigitInput:input];
    }

    if (input.length == 3) {
        return [self validateThirdExpiryDigitInput:input];
    }

    if (input.length == 4) {
        return [self validateFourthExpiryDigitInput:input];
    }

    if (input.length == 5) {
        return [self validateFifthExpiryDigitInput:input];
    }

    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:NO
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input {

    JPCardNetwork *cardNetwork = [JPCardNetwork cardNetworkWithType:self.lastCardNumberValidationResult.cardNetwork];

    if (input.length > cardNetwork.securityCodeLength) {
        return self.lastSecureCodeValidationResult;
    }

    self.lastSecureCodeValidationResult = [JPValidationResult validationWithResult:input.length == cardNetwork.securityCodeLength
                                                                      inputAllowed:input.length <= cardNetwork.securityCodeLength
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastSecureCodeValidationResult;
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    self.selectedBillingCountry = input;
    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:YES
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {

    if ([self.selectedBillingCountry isEqualToString:@"country_usa".localized]) {
        return [self validateUSAPostalCodeInput:input];
    }

    if ([self.selectedBillingCountry isEqualToString:@"country_uk".localized]) {
        return [self validateUKPostalCodeInput:input];
    }

    if ([self.selectedBillingCountry isEqualToString:@"country_canada".localized]) {
        return [self validateCanadaPostalCodeInput:input];
    }

    if ([self.selectedBillingCountry isEqualToString:@"country_other".localized]) {
        return [self validateOtherPostalCodeInput:input];
    }

    return [JPValidationResult validationWithResult:NO
                                       inputAllowed:NO
                                       errorMessage:nil
                                     formattedInput:input];
}

#pragma mark - Getters

- (NSArray *)acceptedCardNetworks {
    return @[
        @(CardNetworkVisa),
        @(CardNetworkAMEX),
        @(CardNetworkMasterCard),
        @(CardNetworkMaestro),
        @(CardNetworkDiscover),
        @(CardNetworkJCB),
        @(CardNetworkDinersClub),
        @(CardNetworkChinaUnionPay),
    ];
}

#pragma mark - Expiry Date Validation Methods

- (JPValidationResult *)validateNoExpiryDigitInput:(NSString *)input {
    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFirstExpiryDigitInput:(NSString *)input {

    BOOL isValidInput = ([input isEqualToString:@"0"] || [input isEqualToString:@"1"]);

    NSString *errorMessage = isValidInput ? nil : @"invalid_expiry_date_value".localized;

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:isValidInput
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateSecondExpiryDigitInput:(NSString *)input {

    if (input.length < self.lastExpiryDateValidationResult.formattedInput.length) {
        NSString *formattedInput = [input substringToIndex:input.length - 1];
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:nil
                                                                        formattedInput:formattedInput];
        return self.lastExpiryDateValidationResult;
    }

    BOOL isValidInput = (input.intValue > 0 && input.intValue <= 12);

    NSString *formattedInput = [NSString stringWithFormat:@"%@/", input];
    NSString *errorMessage = isValidInput ? nil : @"invalid_expiry_date_value".localized;
    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:isValidInput
                                                                      errorMessage:errorMessage
                                                                    formattedInput:isValidInput ? formattedInput : input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateThirdExpiryDigitInput:(NSString *)input {
    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFourthExpiryDigitInput:(NSString *)input {
    NSString *lastDigitString = [input substringFromIndex:input.length - 1];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    int yearFirstDigit = [yearString substringToIndex:1].intValue;

    BOOL isValid = lastDigitString.intValue >= yearFirstDigit && lastDigitString.intValue < yearFirstDigit + 2;
    NSString *errorMessage = isValid ? nil : @"invalid_expiry_date_value".localized;

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:isValid
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFifthExpiryDigitInput:(NSString *)input {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/yy"];
    NSString *currentDate = [formatter stringFromDate:NSDate.date];

    NSArray<NSString *> *currentDateComponents = [currentDate componentsSeparatedByString:@"/"];
    NSArray<NSString *> *inputDateComponents = [input componentsSeparatedByString:@"/"];

    int currentMonth = currentDateComponents[0].intValue;
    int currentYear = currentDateComponents[1].intValue;

    int inputMonth = inputDateComponents[0].intValue;
    int inputYear = inputDateComponents[1].intValue;

    if (inputYear < currentYear) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:NO
                                                                          errorMessage:@"check_expiry_date".localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    if (inputYear == currentYear && inputMonth < currentMonth) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:NO
                                                                          errorMessage:@"check_expiry_date".localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:YES
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateUKPostalCodeInput:(NSString *)input {

    if (input.length > 8) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *UKRegexString = @"(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX‌​]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY]))))\\s?[0-9][A-Z-[C‌​IKMOV]]{2})";

    NSRegularExpression *ukRegex = [NSRegularExpression regularExpressionWithPattern:UKRegexString
                                                                             options:NSRegularExpressionAnchorsMatchLines
                                                                               error:nil];
    BOOL isValid = [ukRegex numberOfMatchesInString:input.uppercaseString
                                            options:NSMatchingWithoutAnchoringBounds
                                              range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == 8 && !isValid) ? @"invalid_postcode".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length < 9
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateUSAPostalCodeInput:(NSString *)input {

    if (input.length > 5) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *USARegexString = @"(^\\d{5}$)|(^\\d{5}-\\d{4}$)";

    NSRegularExpression *usaRegex = [NSRegularExpression regularExpressionWithPattern:USARegexString
                                                                              options:NSRegularExpressionAnchorsMatchLines
                                                                                error:nil];

    BOOL isValid = [usaRegex numberOfMatchesInString:input.uppercaseString
                                             options:NSMatchingWithoutAnchoringBounds
                                               range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == 5 && !isValid) ? @"invalid_zip_code".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length < 6
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateCanadaPostalCodeInput:(NSString *)input {

    if (input.length > 6) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *canadaRegexString = @"[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]";
    NSRegularExpression *canadaRegex = [NSRegularExpression regularExpressionWithPattern:canadaRegexString
                                                                                 options:NSRegularExpressionAnchorsMatchLines
                                                                                   error:nil];

    BOOL isValid = [canadaRegex numberOfMatchesInString:input.uppercaseString
                                                options:NSMatchingWithoutAnchoringBounds
                                                  range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == 6 && !isValid) ? @"invalid_postcode".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length < 7
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];

    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateOtherPostalCodeInput:(NSString *)input {
    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:YES
                                                                      inputAllowed:input.length < 9
                                                                      errorMessage:nil
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

@end
