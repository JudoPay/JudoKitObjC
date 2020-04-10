//
//  Constants.h
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

#ifndef JPConstants_h
#define JPConstants_h

#import <Foundation/Foundation.h>

/* Patterns */
static NSString *kDefaultPattern = @"XXXX XXXX XXXX XXXX";
static NSString *kVISAPattern = @"XXXX XXXX XXXX XXXX";
static NSString *kAMEXPattern = @"XXXX XXXXXX XXXXX";
static NSString *kDinersClubPattern = @"XXXX XXXXXX XXXX";

static NSString *const kRegexVisa = @"^4\\d{0,15}";
static NSString *const kRegexMasterCard = @"^(5[1-5]\\d{0,2}|22[2-9]\\d{0,1}|2[3-7]\\d{0,2})\\d{0,12}";
static NSString *const kRegexMaestro = @"^(?:5[0678]\\d{0,2}|6304|67\\d{0,2})\\d{0,12}";
static NSString *const kRegexAmex = @"^3[47]\\d{0,13}";
static NSString *const kRegexDiscover = @"^(?:6011|65\\d{0,2}|64[4-9]\\d?)\\d{0,12}";
static NSString *const kRegexDinersClub = @"^3(?:0([0-5]|9)|[689]\\d?)\\d{0,11}";
static NSString *const kRegexJCB = @"^(35[2-8][0-9]).*?";
static NSString *const kRegexUnionPay = @"^(62|81)\\d{0,14}";

static NSString *const kChinaUnionPayPrefix = @"62";

static NSString *const kMonthYearDateFormat = @"MM/yy";
static NSString *const kCurrencyEuro = @"EUR";
static NSString *const kFailureReasonUserAbort = @"USER_ABORT";

static NSUInteger const kSecurityCodeLengthAmex = 4;
static NSUInteger const kSecurityCodeLengthDefault = 3;

static NSString *const kSecurityCodePlaceholderhAmex = @"CID";
static NSString *const kSecurityCodePlaceholderhVisa = @"CVV2";
static NSString *const kSecurityCodePlaceholderhMasterCard = @"CVC2";
static NSString *const kSecurityCodePlaceholderhChinaUnionPay = @"CVN2";
static NSString *const kSecurityCodePlaceholderhJCB = @"CAV2";
static NSString *const kSecurityCodePlaceholderDefault = @"CVV";

static int const kJPCountryNumericCodeUK = 826;
static int const kJPCountryNumericCodeUSA = 840;
static int const kJPCountryNumericCodeCanada = 124;

static NSString *const kJudoErrorDomain = @"com.judo.error";

static int const kMaximumLengthForConsumerReference = 40;

static int const kJPMaxAMEXCardLength = 15;
static int const kJPMaxDinersClubCardLength = 14;
static int const kJPMaxDefaultCardLength = 16;

#endif /* JPConstants_h */
