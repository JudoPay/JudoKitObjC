//
//  JPAddCardBuilder.m
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

#import "JPAddCardBuilder.h"
#import "JPAddCardViewController.h"
#import "JPAddCardPresenter.h"
#import "JPAddCardInteractor.h"
#import "JPAddCardRouter.h"

#import "JPTheme.h"
#import "JPReference.h"
#import "JPCardDetails.h"
#import "JPCardValidationService.h"
#import "JPTransactionService.h"

@implementation JPAddCardBuilderImpl

- (JPAddCardViewController *)buildModuleWithTransaction:(JPTransaction *)transaction
                                                  theme:(JPTheme *)theme
                                             completion:(JudoCompletionBlock)completion {
    
    JPTransactionService *transactionService;
    transactionService = [[JPTransactionService alloc] initWithAVSEnabled:theme.avsEnabled
                                                              transaction:transaction];
    
    JPCardValidationService *cardValidationService = [JPCardValidationService new];
    
    JPAddCardInteractorImpl *interactor;
    interactor = [[JPAddCardInteractorImpl alloc] initWithCardValidationService:cardValidationService
                                                             transactionService:transactionService
                                                                     completion:completion];
    
    JPAddCardViewController *viewController = [JPAddCardViewController new];
    JPAddCardPresenterImpl *presenter = [JPAddCardPresenterImpl new];
    JPAddCardRouterImpl *router = [JPAddCardRouterImpl new];
    
    presenter.view = viewController;
    presenter.interactor = interactor;
    presenter.router = router;
    
    router.viewController = viewController;
    
    viewController.presenter = presenter;
    
    return viewController;
}

@end
