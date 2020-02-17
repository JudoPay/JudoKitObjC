//
//  JPPaymentMethodsRouter.m
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

#import "JPPaymentMethodsRouter.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionViewController.h"
#import "JPPaymentMethodsViewController.h"

#import "JPConfiguration.h"
#import "JPTransaction.h"
#import "JPSliderTransitioningDelegate.h"

@interface JPPaymentMethodsRouterImpl ()

@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) JudoCompletionBlock completionHandler;
@property (nonatomic, strong) JPSliderTransitioningDelegate *transitioningDelegate;

@end

@implementation JPPaymentMethodsRouterImpl

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                   transactionService:(JPTransactionService *)transactionService
                transitioningDelegate:(JPSliderTransitioningDelegate *)transitioningDelegate
                           completion:(JudoCompletionBlock)completion {
    if (self = [super init]) {
        self.configuration = configuration;
        self.transactionService = transactionService;
        self.transitioningDelegate = transitioningDelegate;
        self.completionHandler = completion;
    }
    return self;
}

#pragma mark - Protocol Conformance

- (void)navigateToTransactionModule {

    JPTransactionViewController *controller;
    controller = [JPTransactionBuilderImpl buildModuleWithTransactionService:self.transactionService
                                                               configuration:self.configuration
                                                                  completion:self.completionHandler];

    controller.delegate = self.viewController;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;
    [self.viewController presentViewController:controller animated:YES completion:nil];
}

- (void)dismissViewController {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeTransactionWithResponse:(JPResponse *)response
                               andError:(NSError *)error {
    self.completionHandler(response, error);
}

@end
