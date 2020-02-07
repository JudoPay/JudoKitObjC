//
//  JPPaymentMethodsViewController.h
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

#import "JPAddCardViewController.h"
#import "JPPaymentMethodsCardListHeaderCell.h"
#import "JPSectionView.h"
#import <UIKit/UIKit.h>

@protocol JPPaymentMethodsPresenter;
@class JPPaymentMethodsViewModel;

#pragma mark - JPPaymentMethodsView

@protocol JPPaymentMethodsView

/**
 * A method that configures the view based on a passed view model
 *
 * @param viewModel - a view model detailing the layout details
 */
- (void)configureWithViewModel:(JPPaymentMethodsViewModel *)viewModel;

/**
 * Convenience method for displaying alert controllers based on a specified error with an optional title
 *
 * @param title - an optional NSString that defines the title of the alert
 * @param error - an NSError instance describing the current error
 */
- (void)displayAlertWithTitle:(NSString *)title andError:(NSError *)error;

@end

#pragma mark - JPPaymentMethodsViewController

@interface JPPaymentMethodsViewController : UIViewController <JPPaymentMethodsView>

/**
 * A strong reference to a presenter object that adopts the JPAddCardPresenter protocol
 */
@property (nonatomic, strong) id<JPPaymentMethodsPresenter> presenter;

@end

/**
 * A JPPaymentMethodsViewController extension for implementing the table view data source methods
 */
@interface JPPaymentMethodsViewController (TableViewDataSource) <UITableViewDataSource>
@end

/**
 * A JPPaymentMethodsViewController extension for implementing the table view delegate methods
 */
@interface JPPaymentMethodsViewController (TableViewDelegate) <UITableViewDelegate>
@end

/**
 * A JPPaymentMethodsViewController extension that adopts the Add Card delegate methods
 */
@interface JPPaymentMethodsViewController (AddCardDelegate) <JPAddCardViewDelegate>
@end

/**
 * A JPPaymentMethodsViewController extension that adopts the Header View delegate methods
 */
@interface JPPaymentMethodsViewController (EditCardsDelegate) <JPPaymentMethodsCardListHeaderCellDelegate>
@end

/**
 * A JPPaymentMethodsViewController extension that adopts the JPSectionView delegate methods
 */
@interface JPPaymentMethodsViewController (JPSectionViewDelegate) <JPSectionViewDelegate>
@end
