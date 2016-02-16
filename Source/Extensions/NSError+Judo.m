//
//  NSError+Judo.m
//  JudoKitObjC
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

#import "NSError+Judo.h"

@implementation NSError (Judo)

+ (NSError *)judoRequestFailedError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoJSONSerializationError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoJudoIdMissingError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoAmountMissingError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoPaymentMethodMissingError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoReferenceMissingError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoDuplicateTransactionError {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judoErrorFromErrorCode:(NSInteger)code {
    // TODO:
    return [[NSError alloc] init];
}

+ (NSError *)judo3DSRequestWithPayload:(NSDictionary *)payload {
    // TODO:
    return [[NSError alloc] init];
}

@end
