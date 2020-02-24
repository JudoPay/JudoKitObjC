//
//  JPCardCustomizationPresenter.h
//  JudoKitObjC
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

@protocol JPCardCustomizationView, JPCardCustomizationRouter, JPCardCustomizationInteractor;

@protocol JPCardCustomizationPresenter

/**
 * A method that is used to update the Card customization view model, which in turn updates the UI
 */
- (void)prepareViewModel;

/**
 * A method that is used to handle the Back button tap action and trigger the pop navigation
 */
- (void)handleBackButtonTap;

@end

@interface JPCardCustomizationPresenterImpl : NSObject <JPCardCustomizationPresenter>

/**
 * A weak reference to the view that adops the  JPCardCustomizationView protocol
 */
@property (nonatomic, weak) id<JPCardCustomizationView> view;

/**
 * A strong reference to the router that adops the  JPCardCustomizationRouter protocol
 */
@property (nonatomic, strong) id<JPCardCustomizationRouter> router;

/**
 * A strong reference to the interactor that adops the  JPCardCustomizationInteractor protocol
 */
@property (nonatomic, strong) id<JPCardCustomizationInteractor> interactor;

@end
