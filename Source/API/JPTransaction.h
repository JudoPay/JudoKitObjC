//
//  JPTransaction.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <PassKit/PassKit.h>

@class JPAmount;
@class JPReference;
@class JPCard;
@class JPPaymentToken;

@interface JPTransaction : NSObject

@property (nonatomic, strong, readonly) NSString *transactionPath;

@property (nonatomic, strong) NSString *judoID;
@property (nonatomic, strong) JPReference *reference;
@property (nonatomic, strong) JPAmount *amount;

@property (nonatomic, strong) JPCard *card;
@property (nonatomic, strong) JPPaymentToken *paymentToken;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDictionary *deviceSignal;

@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *emailAddress;

@property (nonatomic, strong, readonly) PKPayment *pkPayment;

- (void)setPkPayment:(PKPayment *)pkPayment error:(NSError **)error;

- (NSError *)validateTransaction;

@end
