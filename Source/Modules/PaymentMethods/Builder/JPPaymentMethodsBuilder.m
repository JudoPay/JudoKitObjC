//
//  JPPaymentMethodsBuilder.m
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

#import "JPPaymentMethodsBuilder.h"

#import "JPAmount.h"
#import "JPCardStorage.h"
#import "JPReference.h"
#import "JudoKit.h"

#import "JPPaymentMethodsInteractor.h"
#import "JPPaymentMethodsPresenter.h"
#import "JPPaymentMethodsRouter.h"
#import "JPPaymentMethodsViewController.h"

@implementation JPPaymentMethodsBuilderImpl

- (JPPaymentMethodsViewController *)buildModuleWithJudoID:(NSString *)judoId
                                                  session:(JudoKit *)session
                                    transitioningDelegate:(SliderTransitioningDelegate *)transitioningDelegate
                                                   amount:(JPAmount *)amount
                                        consumerReference:(NSString *)consumerReference
                                        completionHandler:(JudoCompletionBlock)completion {

    JPPaymentMethodsViewController *viewController = [JPPaymentMethodsViewController new];
    JPPaymentMethodsPresenterImpl *presenter = [JPPaymentMethodsPresenterImpl new];

    JPReference *reference = [JPReference consumerReference:consumerReference];

    JPTransaction *addCardTransaction = [session transactionForType:TransactionTypeSaveCard
                                                             judoId:judoId
                                                             amount:amount
                                                          reference:reference];

    JPPaymentMethodsRouterImpl *router;
    router = [[JPPaymentMethodsRouterImpl alloc] initWithTransaction:addCardTransaction
                                               transitioningDelegate:transitioningDelegate
                                                               theme:session.theme
                                                          completion:completion];

    JPTransaction *paymentTransaction = [session transactionForType:TransactionTypePayment
                                                             judoId:judoId
                                                             amount:amount
                                                          reference:reference];

    JPPaymentMethodsInteractorImpl *interactor;
    interactor = [[JPPaymentMethodsInteractorImpl alloc] initWithTransaction:paymentTransaction
                                                           consumerReference:consumerReference
                                                                       theme:session.theme
                                                                   andAmount:amount];

    presenter.view = viewController;
    presenter.interactor = interactor;
    presenter.router = router;
    router.viewController = viewController;
    viewController.presenter = presenter;

    return viewController;
}

@end
