//
//  JPPaymentMethodsRouter.h
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

@class JPPaymentMethodsViewController;
@class JPTransactionService, JPConfiguration, JPSliderTransitioningDelegate;

@protocol JPPaymentMethodsRouter
/**
 * A method that opens up the Add Card view for entering new card details
 */
- (void)navigateToTransactionModule;

/**
 * A method that opens the Card Customization view for customizing the card
 */
- (void)navigateToCardCustomizationWithIndex:(NSUInteger)index;

/**
 * A method that dismisses the current view
 */
- (void)dismissViewController;

/**
 * A method that triggers the completion handler passed by the merchant with an optional response / error
 *
 * @param response - an optional instance of the JPResponse object that contains the response details
 * @param error - an optional instance of NSError that contains the error details
 */
- (void)completeTransactionWithResponse:(JPResponse *_Nullable)response
                               andError:(NSError *_Nullable)error;

@end

@interface JPPaymentMethodsRouterImpl : NSObject <JPPaymentMethodsRouter>
@property (nonatomic, weak) JPPaymentMethodsViewController *_Nullable viewController;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                           transactionService:(nonnull JPTransactionService *)transactionService
                        transitioningDelegate:(JPSliderTransitioningDelegate *_Nonnull)transitioningDelegate
                                   completion:(JudoCompletionBlock _Nonnull)completion;

@end
