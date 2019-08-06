//
//  JudoKit.m
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

#import "JudoKit.h"

#import <DeviceDNA/DeviceDNA.h>

#import "JPSession.h"
#import "JPPayment.h"
#import "JPPreAuth.h"
#import "JPRefund.h"
#import "JPReceipt.h"
#import "JPReference.h"
#import "JPRegisterCard.h"
#import "JPSaveCard.h"
#import "JPVoid.h"
#import "JPCollection.h"
#import "JPTransactionData.h"
#import "JudoPayViewController.h"
#import "JPInputField.h"
#import "CardInputField.h"
#import "DateInputField.h"
#import "FloatingTextField.h"
#import "JudoPaymentMethodsViewModel.h"
#import "JPTheme.h"
#import "JPTransactionEnricher.h"
#import "ApplePayConfiguration.h"

@interface JPSession ()
@property(nonatomic, strong, readwrite) NSString *authorizationHeader;
@end

@interface JudoKit ()
@property(nonatomic, strong, readwrite) JPSession *apiSession;
@property(nonatomic, strong) JPTransactionEnricher *enricher;
@property(nonatomic, strong) NSString *deviceIdentifier;
@end

@implementation JudoKit

/**
 A method that checks if the device it is currently running on is jailbroken or not
 
 - returns: true if device is jailbroken
 */
- (BOOL)isCurrentDeviceJailbroken {
    return [NSFileManager.defaultManager fileExistsAtPath:@"/private/var/lib/apt/"];
}

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret {
    return [self initWithToken:token secret:secret allowJailbrokenDevices:YES];
}

- (instancetype)initWithToken:(NSString *)token
                       secret:(NSString *)secret
       allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {
    
    self = [super init];
    
    if (self) {
        // Check if device is jailbroken and SDK was set to restrict access.
        // self is returned here without setting the token and secret.
        // When the transaction is attempted it will fail citing unset credentials.
        if (!jailbrokenDevicesAllowed && [self isCurrentDeviceJailbroken]) {
            return self;
        }
        
        NSString *plainString = [NSString stringWithFormat:@"%@:%@", token, secret];
        NSData *plainData = [plainString dataUsingEncoding:NSISOLatin1StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        
        self.enricher = [[JPTransactionEnricher alloc] initWithToken:token secret:secret];
        self.apiSession = [JPSession new];
        [self.apiSession setAuthorizationHeader:[NSString stringWithFormat:@"Basic %@", base64String]];
    }
    
    return self;
}

- (void)sendWithCompletion:(nonnull JPTransaction *)transaction
                completion:(nonnull JudoCompletionBlock)completion {
    
    [transaction sendWithCompletion:completion];
}

- (void)invokePayment:(nonnull NSString *)judoId
               amount:(nonnull JPAmount *)amount
    consumerReference:(nonnull NSString *)reference
       paymentMethods:(PaymentMethods)methods
          cardDetails:(nullable JPCardDetails *)cardDetails
           completion:(nonnull void (^)(JPResponse *_Nullable, NSError *_Nullable))completion {
    
    JudoPaymentMethodsViewModel *viewModel =
    [[JudoPaymentMethodsViewModel alloc] initWithJudoId:judoId
                                                 amount:amount
                                      consumerReference:[[JPReference alloc] initWithConsumerReference:reference]
                                         paymentMethods:methods
                                            cardDetails:cardDetails];
    
    JudoPaymentMethodsViewController *viewController = [[JudoPaymentMethodsViewController alloc] initWithTheme:self.theme
                                                                                                     viewModel:viewModel
                                                                                                currentSession:self
                                                                                                 andCompletion:completion];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.topMostViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)invokePayment:(NSString *)judoId
               amount:(JPAmount *)amount
    consumerReference:(NSString *)reference
          cardDetails:(JPCardDetails *)cardDetails
           completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypePayment
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokePayment:(NSString *)judoId
               amount:(JPAmount *)amount
            reference:(JPReference *)reference
          cardDetails:(JPCardDetails *)cardDetails
           completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:reference
                                     transaction:TransactionTypePayment
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokePreAuth:(NSString *)judoId
               amount:(JPAmount *)amount
    consumerReference:(NSString *)reference
          cardDetails:(JPCardDetails *)cardDetails
           completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypePreAuth
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeRegisterCard:(NSString *)judoId
         consumerReference:(NSString *)reference
               cardDetails:(JPCardDetails *)cardDetails
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:nil
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypeRegisterCard
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeSaveCard:(NSString *)judoId
     consumerReference:(NSString *)reference
           cardDetails:(JPCardDetails *)cardDetails
            completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:nil
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypeSaveCard
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeTokenPayment:(NSString *)judoId
                    amount:(JPAmount *)amount
         consumerReference:(NSString *)reference
               cardDetails:(JPCardDetails *)cardDetails
              paymentToken:(JPPaymentToken *)paymentToken
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypePayment
                                     cardDetails:cardDetails
                                    paymentToken:paymentToken
                                      completion:completion];
}

- (void)invokeTokenPreAuth:(NSString *)judoId
                    amount:(JPAmount *)amount
         consumerReference:(NSString *)reference
               cardDetails:(JPCardDetails *)cardDetails
              paymentToken:(JPPaymentToken *)paymentToken
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:[[JPReference alloc] initWithConsumerReference:reference]
                                     transaction:TransactionTypePreAuth
                                     cardDetails:cardDetails
                                    paymentToken:paymentToken
                                      completion:completion];
}

- (void)invokePreAuth:(NSString *)judoId
               amount:(JPAmount *)amount
            reference:(JPReference *)reference
          cardDetails:(JPCardDetails *)cardDetails
           completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:reference
                                     transaction:TransactionTypePreAuth
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeRegisterCard:(NSString *)judoId
                 reference:(JPReference *)reference
               cardDetails:(JPCardDetails *)cardDetails
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:nil
                                       reference:reference
                                     transaction:TransactionTypeRegisterCard
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeSaveCard:(NSString *)judoId
             reference:(JPReference *)reference
           cardDetails:(JPCardDetails *)cardDetails
            completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:nil
                                       reference:reference
                                     transaction:TransactionTypeSaveCard
                                     cardDetails:cardDetails
                                    paymentToken:nil
                                      completion:completion];
}

- (void)invokeTokenPayment:(NSString *)judoId
                    amount:(JPAmount *)amount
                 reference:(JPReference *)reference
               cardDetails:(JPCardDetails *)cardDetails
              paymentToken:(JPPaymentToken *)paymentToken
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:reference
                                     transaction:TransactionTypePayment
                                     cardDetails:cardDetails
                                    paymentToken:paymentToken
                                      completion:completion];
}

- (void)invokeTokenPreAuth:(NSString *)judoId
                    amount:(JPAmount *)amount
                 reference:(JPReference *)reference
               cardDetails:(JPCardDetails *)cardDetails
              paymentToken:(JPPaymentToken *)paymentToken
                completion:(void (^)(JPResponse *, NSError *))completion {
    [self presentPaymentViewControllerWithJudoId:judoId
                                          amount:amount
                                       reference:reference
                                     transaction:TransactionTypePreAuth
                                     cardDetails:cardDetails
                                    paymentToken:paymentToken
                                      completion:completion];
}

- (void)presentPaymentViewControllerWithJudoId:(NSString *)judoId
                                        amount:(JPAmount *)amount
                                     reference:(JPReference *)reference
                                   transaction:(TransactionType)type
                                   cardDetails:(JPCardDetails *)cardDetails
                                  paymentToken:(JPPaymentToken *)paymentToken
                                    completion:(JudoCompletionBlock)completion {
    
    JudoPayViewController *viewController = [[JudoPayViewController alloc] initWithJudoId:judoId
                                                                                   amount:amount
                                                                                reference:reference
                                                                              transaction:type
                                                                           currentSession:self
                                                                              cardDetails:cardDetails
                                                                               completion:completion];
    viewController.paymentToken = paymentToken;
    viewController.theme = self.theme;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.activeViewController = viewController;
    [self.topMostViewController presentViewController:navigationController animated:YES completion:nil];
}

- (JPTransaction *)transactionForTypeClass:(Class)type
                                    judoId:(NSString *)judoId
                                    amount:(nullable JPAmount *)amount
                                 reference:(nonnull JPReference *)reference {
    JPTransaction *transaction = [type new];
    transaction.judoId = judoId;
    transaction.amount = amount;
    transaction.reference = reference;
    transaction.apiSession = self.apiSession;
    transaction.enricher = self.enricher;
    
    return transaction;
}

- (JPTransaction *)transactionForType:(TransactionType)type
                               judoId:(NSString *)judoId
                               amount:(JPAmount *)amount
                            reference:(JPReference *)reference {
    Class transactionTypeClass;
    
    switch (type) {
        case TransactionTypePayment:
            transactionTypeClass = JPPayment.class;
            break;
            
        case TransactionTypePreAuth:
            transactionTypeClass = JPPreAuth.class;
            break;
            
        case TransactionTypeRegisterCard:
            transactionTypeClass = JPRegisterCard.class;
            break;
            
        case TransactionTypeSaveCard:
            transactionTypeClass = JPSaveCard.class;
            break;
            
        default:
            return nil;
    }
    
    return [self transactionForTypeClass:transactionTypeClass judoId:judoId
                                  amount:amount
                               reference:reference];
}

- (JPPayment *)paymentWithJudoId:(NSString *)judoId
                          amount:(JPAmount *)amount
                       reference:(JPReference *)reference {
    
    return (JPPayment *) [self transactionForTypeClass:JPPayment.class judoId:judoId
                                                amount:amount
                                             reference:reference];
}

- (JPPreAuth *)preAuthWithJudoId:(NSString *)judoId
                          amount:(JPAmount *)amount
                       reference:(JPReference *)reference {
    
    return (JPPreAuth *) [self transactionForTypeClass:JPPreAuth.class
                                                judoId:judoId amount:amount
                                             reference:reference];
}

- (JPRegisterCard *)registerCardWithJudoId:(NSString *)judoId
                                 reference:(JPReference *)reference {
    
    return (JPRegisterCard *) [self transactionForTypeClass:JPRegisterCard.class
                                                     judoId:judoId
                                                     amount:nil
                                                  reference:reference];
}

- (JPSaveCard *)saveCardWithJudoId:(NSString *)judoId
                         reference:(JPReference *)reference {
    
    return (JPSaveCard *) [self transactionForTypeClass:JPSaveCard.class
                                                 judoId:judoId
                                                 amount:nil
                                              reference:reference];
}

- (JPTransactionProcess *)transactionProcessForType:(Class)type
                                          receiptId:(NSString *)receiptId
                                             amount:(JPAmount *)amount {
    
    JPTransactionProcess *transactionProc = [[type alloc] initWithReceiptId:receiptId
                                                                     amount:amount];
    transactionProc.apiSession = self.apiSession;
    return transactionProc;
}

- (JPCollection *)collectionWithReceiptId:(NSString *)receiptId
                                   amount:(JPAmount *)amount {
    
    return (JPCollection *) [self transactionProcessForType:JPCollection.class
                                                  receiptId:receiptId
                                                     amount:amount];
}

- (JPVoid *)voidWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount {
    
    return (JPVoid *) [self transactionProcessForType:JPVoid.class
                                            receiptId:receiptId
                                               amount:amount];
}

- (JPRefund *)refundWithReceiptId:(NSString *)receiptId
                           amount:(JPAmount *)amount {
    
    return (JPRefund *) [self transactionProcessForType:JPRefund.class
                                              receiptId:receiptId
                                                 amount:amount];
}

- (JPReceipt *)receipt:(NSString *)receiptId {
    JPReceipt *receipt = [[JPReceipt alloc] initWithReceiptId:receiptId];
    receipt.apiSession = self.apiSession;
    return receipt;
}

- (void)list:(Class)type paginated:(JPPagination *)pagination completion:(JudoCompletionBlock)completion {
    JPTransaction *transaction = [type new];
    transaction.apiSession = self.apiSession;
    [transaction listWithPagination:pagination completion:completion];
}

#pragma mark - Helper methods

- (UIViewController *)topMostViewController {
    UIViewController *topViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
        
        if ([topViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *navigationController = (UINavigationController *) topViewController;
            topViewController = navigationController.viewControllers.lastObject;
        }
        
        if ([topViewController isKindOfClass:UITabBarController.class]) {
            UITabBarController *tabBarController = (UITabBarController *) topViewController;
            topViewController = tabBarController.selectedViewController;
        }
    }
    return topViewController;
}

#pragma mark - Getters

- (JPTheme *)theme {
    if (!_theme) {
        _theme = [JPTheme new];
    }
    return _theme;
}

@end

@implementation JudoKit (ApplePay)

- (void)paymentWithApplePayWithConfiguration:(ApplePayConfiguration *)configuration {
    
    PKPaymentRequest *paymentRequest = [configuration generatePaymentRequest];
    PKPaymentAuthorizationViewController *viewController;
    viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    viewController.delegate = self;
    
    [self.topMostViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion  API_AVAILABLE(ios(11.0)){
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    [controller dismissViewControllerAnimated:YES completion:nil];
    completion(PKPaymentAuthorizationStatusSuccess);
}

@end
