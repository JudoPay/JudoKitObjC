//
//  JPAddCardBuilder.h
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

#import "JPCardDetails.h"
#import "JPSession.h"
#import <Foundation/Foundation.h>

@class JPAddCardViewController;
@class JPTheme, JPTransaction;

@protocol JPAddCardBuilder
/**
 *  Method that returns a configured JPAddCardViewController based on properties provided
 *
 *  @param transaction - a JPTransaction object that describes the transaction details
 *  @param theme - a JPTheme object that primarily defines the style of Add Card view
 *  @param cardNetworks - the supported card networks to be accepted
 *  @param completion - a response / error completion block that is returned after a transaction is sent
 *
 *  @return a pre-configured JPAddCardViewController instance
 */
- (JPAddCardViewController *)buildModuleWithTransaction:(JPTransaction *)transaction
                                                  theme:(JPTheme *)theme
                                  supportedCardNetworks:(CardNetwork)cardNetworks
                                             completion:(JudoCompletionBlock)completion;
@end

@interface JPAddCardBuilderImpl : NSObject <JPAddCardBuilder>

@end
