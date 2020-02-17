//
//  IDEALFormViewController.m
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

#import "IDEALFormViewController.h"
#import "FloatingTextField.h"
#import "IDEALBank.h"
#import "IDEALBankSelectionTableViewController.h"
#import "IDEALBankTableViewCell.h"
#import "IDEALService.h"
#import "JPAmount.h"
#import "JPInputField+JPTheme.h"
#import "JPInputField.h"
#import "JPOrderDetails.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPTheme.h"
#import "JPTransactionData.h"
#import "NSError+Judo.h"
#import "NSString+Localize.h"
#import "TransactionStatusView.h"
#import "UIButton+JPTheme.h"
#import "UIColor+Judo.h"
#import "UILabel+JPTheme.h"
#import "UIView+SafeAnchors.h"
#import "UIViewController+JPTheme.h"

@interface IDEALFormViewController ()

@property (nonatomic, strong) UIView *safeAreaView;
@property (nonatomic, strong) UIButton *paymentButton;
@property (nonatomic, strong) JPInputField *nameInputField;
@property (nonatomic, strong) UILabel *selectedBankLabel;
@property (nonatomic, strong) UIView *selectedBankLabelView;
@property (nonatomic, strong) UITableViewCell *bankSelectionCell;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) TransactionStatusView *transactionStatusView;

@property (nonatomic, strong) JPTheme *theme;
@property (nonatomic, strong) IDEALBank *_Nullable selectedBank;
@property (nonatomic, strong) JudoCompletionBlock completionBlock;

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, assign) BOOL shouldDismissWebView;
@property (nonatomic, strong) JPResponse *redirectResponse;

@property (nonatomic, strong) NSTimer *delayTimer;
@property (nonatomic, strong) IDEALService *idealService;
@property (nonatomic, strong) IDEALBankSelectionTableViewController *bankSelectionController;

@property (nonatomic, strong) NSLayoutConstraint *paymentButtonBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *safeAreaViewConstraints;

@end

@implementation IDEALFormViewController

#pragma mark - Initializers

- (instancetype)initWithSiteId:(NSString *)siteId
                         theme:(JPTheme *)theme
                        amount:(JPAmount *)amount
                     reference:(JPReference *)reference
                       session:(JPSession *)session
               paymentMetadata:(NSDictionary *)paymentMetadata
                    completion:(JudoCompletionBlock)completion {

    if (self = [super init]) {
        self.theme = theme;
        self.completionBlock = completion;
        self.idealService = [[IDEALService alloc] initWithSiteId:siteId
                                                          amount:amount
                                                       reference:reference
                                                         session:session
                                                 paymentMetadata:paymentMetadata];
    }

    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self applyTheming];
    [self displaySavedBankIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerKeyboardObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.idealService stopPollingTransactionStatus];
    [self.nameInputField endEditing:YES];
    [self removeKeyboardObservers];
    [super viewWillDisappear:animated];
}

#pragma mark - User actions

- (void)onViewTap:(id)sender {
    [self.nameInputField endEditing:YES];
}

- (void)onBackButtonTap:(id)sender {
    if (self.completionBlock) {
        self.completionBlock(nil, NSError.judoUserDidCancelError);
    }
}

- (void)onSelectBankButtonTap:(id)sender {
    self.bankSelectionController = [IDEALBankSelectionTableViewController new];
    self.bankSelectionController.delegate = self;
    [self.navigationController pushViewController:self.bankSelectionController animated:YES];
}

- (void)onPayButtonTap:(id)sender {
    [self.view endEditing:YES];
    self.idealService.accountHolderName = self.nameInputField.textField.text;
    [self.idealService redirectURLForIDEALBank:self.selectedBank
                                    completion:^(JPResponse *response, NSError *error) {
                                        if (error) {
                                            self.completionBlock(nil, error);
                                            return;
                                        }

                                        JPTransactionData *transactionData = response.items.firstObject;
                                        self.redirectUrl = transactionData.redirectUrl;
                                        self.orderId = transactionData.orderDetails.orderId;
                                        self.redirectResponse = response;

                                        self.navigationItem.rightBarButtonItem.enabled = NO;
                                        [self loadWebViewWithURLString:self.redirectUrl];
                                    }];
}

- (void)displayPaymentElementsIfNeeded {
    BOOL shouldDisplay = (self.selectedBank != nil && self.nameInputField.textField.text.length > 2);
    [self shouldDisplayPaymentElements:shouldDisplay];
}

#pragma mark - Action handlers

- (void)shouldDisplayPaymentElements:(BOOL)shouldContinue {
    self.safeAreaView.hidden = !shouldContinue;
    self.paymentButton.hidden = !shouldContinue;
    self.navigationItem.rightBarButtonItem.enabled = shouldContinue;
}

- (void)loadWebViewWithURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:self.webView];
    [self setupWebViewConstraints];
    [self.webView loadRequest:request];
}

- (void)setupWebViewConstraints {
    [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)displaySavedBankIfNeeded {
    NSInteger bankTypeValue = [NSUserDefaults.standardUserDefaults integerForKey:@"iDEALBankType"];
    IDEALBankType bankType = (IDEALBankType)bankTypeValue;

    if (bankType == IDEALBankNone) {
        return;
    }

    IDEALBank *storedBank = [IDEALBank bankWithType:bankType];
    [self tableViewController:self.bankSelectionController didSelectBank:storedBank];
}

#pragma mark - Theming

- (void)applyTheming {
    [self applyTheme:self.theme];
    [self.nameInputField applyTheme:self.theme];
    [self.selectedBankLabel applyTheme:self.theme];
    [self.paymentButton applyTheme:self.theme];
}

#pragma mark - Private methods

- (void)startPollingStatus {
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      repeats:NO
                                                        block:^(NSTimer *_Nonnull timer) {
                                                            [self.transactionStatusView changeStatusTo:IDEALStatusPendingDelay andSubtitle:nil];
                                                        }];

    [self.idealService pollTransactionStatusForOrderId:self.orderId
                                              checksum:self.checksum
                                            completion:^(JPResponse *response, NSError *error) {
                                                [self.delayTimer invalidate];
                                                if (error && error.localizedDescription == NSError.judoRequestTimeoutError.localizedDescription) {
                                                    [self.transactionStatusView changeStatusTo:IDEALStatusTimeout andSubtitle:nil];
                                                    self.completionBlock(self.redirectResponse, NSError.judoRequestTimeoutError);
                                                    return;
                                                }

                                                if (error) {
                                                    if (error.code != JudoErrorUserDidCancel) {
                                                        [self.transactionStatusView changeStatusTo:IDEALStatusError
                                                                                       andSubtitle:error.localizedDescription];
                                                    }
                                                    self.completionBlock(self.redirectResponse, error);
                                                    return;
                                                }

                                                JPOrderDetails *orderDetails = response.items.firstObject.orderDetails;
                                                IDEALStatus orderStatus = [self orderStatusFromStatusString:orderDetails.orderStatus];

                                                [self.transactionStatusView changeStatusTo:orderStatus
                                                                               andSubtitle:nil];
                                                self.completionBlock(response, error);
                                            }];
}

- (IDEALStatus)orderStatusFromStatusString:(NSString *)orderStatusString {
    if ([orderStatusString isEqual:@"PENDING"])
        return IDEALStatusPending;
    if ([orderStatusString isEqual:@"SUCCEEDED"])
        return IDEALStatusSuccess;
    return IDEALStatusFailed;
}

#pragma mark - Layout setup methods

- (void)setupViews {

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(onViewTap:)];
    [self.view addGestureRecognizer:tapGesture];
    [self setupNavigationBar];
    [self setupPaymentButton];
    [self setupStackView];
    [self setupTransactionStatusView];

    self.selectedBankLabelView.hidden = YES;
    self.transactionStatusView.hidden = YES;
}

- (void)setupTransactionStatusView {
    [self.view addSubview:self.transactionStatusView];

    NSArray *constraints = @[
        [self.transactionStatusView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.transactionStatusView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [self.transactionStatusView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
        [self.transactionStatusView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ];

    [NSLayoutConstraint activateConstraints:constraints];

    [self applyTheming];
}

- (void)setupNavigationBar {

    self.navigationItem.title = @"ideal".localized;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back".localized
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onBackButtonTap:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pay".localized
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onPayButtonTap:)];

    [self shouldDisplayPaymentElements:NO];
}

- (void)setupPaymentButton {

    [self.view addSubview:self.safeAreaView];
    [self.view addSubview:self.paymentButton];

    self.safeAreaViewConstraints = [self.safeAreaView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];

    NSArray *viewConstraints = @[
        [self.safeAreaView.heightAnchor constraintEqualToConstant:self.theme.buttonHeight],
        [self.safeAreaView.rightAnchor constraintEqualToAnchor:self.view.safeRightAnchor],
        [self.safeAreaView.leftAnchor constraintEqualToAnchor:self.view.safeLeftAnchor],
        self.safeAreaViewConstraints
    ];

    self.paymentButtonBottomConstraint = [self.paymentButton.bottomAnchor constraintEqualToAnchor:self.view.safeBottomAnchor];

    NSArray *buttonConstraints = @[
        [self.paymentButton.heightAnchor constraintEqualToConstant:self.theme.buttonHeight],
        [self.paymentButton.rightAnchor constraintEqualToAnchor:self.view.safeRightAnchor],
        [self.paymentButton.leftAnchor constraintEqualToAnchor:self.view.safeLeftAnchor],
        self.paymentButtonBottomConstraint
    ];

    [NSLayoutConstraint activateConstraints:viewConstraints];
    [NSLayoutConstraint activateConstraints:buttonConstraints];
}

- (void)setupStackView {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;

    [stackView addArrangedSubview:self.nameInputField];
    [stackView addArrangedSubview:self.selectedBankLabelView];
    [stackView addArrangedSubview:self.bankSelectionCell];

    [self.view addSubview:stackView];

    NSArray *subviewConstraints = @[
        [self.nameInputField.heightAnchor constraintEqualToConstant:self.theme.inputFieldHeight],
        [self.bankSelectionCell.leftAnchor constraintEqualToAnchor:stackView.leftAnchor],
        [self.bankSelectionCell.rightAnchor constraintEqualToAnchor:stackView.rightAnchor],
        [self.bankSelectionCell.heightAnchor constraintGreaterThanOrEqualToConstant:self.theme.buttonHeight],
    ];

    NSArray *stackViewConstraints = @[
        [stackView.topAnchor constraintEqualToAnchor:self.view.safeTopAnchor
                                            constant:20.0f],
        [stackView.rightAnchor constraintEqualToAnchor:self.safeAreaView.rightAnchor],
        [stackView.leftAnchor constraintEqualToAnchor:self.safeAreaView.leftAnchor],
    ];

    [NSLayoutConstraint activateConstraints:subviewConstraints];
    [NSLayoutConstraint activateConstraints:stackViewConstraints];
}

#pragma mark - Lazy instantiated properties

- (JPInputField *)nameInputField {
    if (!_nameInputField) {
        _nameInputField = [[JPInputField alloc] initWithTheme:self.theme];
        _nameInputField.textField.placeholder = @"enter_name".localized;
        _nameInputField.textField.keyboardType = UIKeyboardTypeAlphabet;

        [_nameInputField.textField addTarget:self
                                      action:@selector(displayPaymentElementsIfNeeded)
                            forControlEvents:UIControlEventEditingChanged];
    }

    return _nameInputField;
}

- (UIView *)selectedBankLabelView {
    if (!_selectedBankLabelView) {

        _selectedBankLabel = [UILabel new];
        _selectedBankLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _selectedBankLabel.text = @"selected_bank".localized;

        _selectedBankLabelView = [UIView new];
        _selectedBankLabelView.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectedBankLabelView addSubview:_selectedBankLabel];

        NSArray *constraints = @[
            [_selectedBankLabel.leadingAnchor constraintEqualToAnchor:_selectedBankLabelView.leadingAnchor
                                                             constant:15.0f],
            [_selectedBankLabel.topAnchor constraintEqualToAnchor:_selectedBankLabelView.topAnchor],
            [_selectedBankLabel.bottomAnchor constraintEqualToAnchor:_selectedBankLabelView.bottomAnchor],
            [_selectedBankLabel.trailingAnchor constraintEqualToAnchor:_selectedBankLabelView.trailingAnchor],
        ];

        [NSLayoutConstraint activateConstraints:constraints];
    }

    return _selectedBankLabelView;
}

- (UITableViewCell *)bankSelectionCell {
    if (!_bankSelectionCell) {
        _bankSelectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _bankSelectionCell.translatesAutoresizingMaskIntoConstraints = NO;
        _bankSelectionCell.textLabel.text = @"select_ideal_bank".localized;
        _bankSelectionCell.imageView.contentMode = UIViewContentModeLeft;
        _bankSelectionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(onSelectBankButtonTap:)];

        [_bankSelectionCell addGestureRecognizer:tapGesture];
    }

    return _bankSelectionCell;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        _webView = [[WKWebView alloc] initWithFrame:UIScreen.mainScreen.bounds
                                      configuration:configuration];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIView *)safeAreaView {
    if (!_safeAreaView) {
        _safeAreaView = [UIView new];
        _safeAreaView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _safeAreaView;
}

- (UIButton *)paymentButton {
    if (!_paymentButton) {
        _paymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentButton.translatesAutoresizingMaskIntoConstraints = NO;
        _paymentButton.accessibilityIdentifier = @"Pay Button";
        [_paymentButton setTitle:@"pay".localized forState:UIControlStateNormal];

        [_paymentButton addTarget:self
                           action:@selector(onPayButtonTap:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentButton;
}

- (TransactionStatusView *)transactionStatusView {
    if (!_transactionStatusView) {
        _transactionStatusView = [TransactionStatusView viewWithStatus:IDEALStatusPending
                                                              subtitle:nil
                                                              andTheme:self.theme];

        _transactionStatusView.translatesAutoresizingMaskIntoConstraints = NO;
        _transactionStatusView.delegate = self;
    }
    return _transactionStatusView;
}

#pragma mark - Keyboard handling logic

- (void)registerKeyboardObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:)
                               name:UIKeyboardWillShowNotification
                             object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
}

- (void)removeKeyboardObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    if (@available(iOS 11.0, *)) {
        self.paymentButtonBottomConstraint.constant = -keyboardSize.height + self.view.safeAreaInsets.bottom;
        self.safeAreaViewConstraints.constant = -keyboardSize.height + self.view.safeAreaInsets.bottom;
    } else {
        self.paymentButtonBottomConstraint.constant = -keyboardSize.height;
        self.safeAreaViewConstraints.constant = -keyboardSize.height;
    }

    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {

    self.paymentButtonBottomConstraint.constant = 0;
    self.safeAreaViewConstraints.constant = 0;

    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

@end

#pragma mark - WKNavigation Delegate

@implementation IDEALFormViewController (WebView)

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

    if (self.shouldDismissWebView) {
        [self.webView removeFromSuperview];
        [self startPollingStatus];
        return;
    }

    self.transactionStatusView.hidden = NO;

    if ([self.redirectUrl isEqualToString:webView.URL.absoluteString]) {

        NSURLComponents *components = [NSURLComponents componentsWithString:webView.URL.absoluteString];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name = 'cs'"];
        NSURLQueryItem *checksum = [components.queryItems filteredArrayUsingPredicate:predicate].firstObject;

        if (checksum) {
            self.shouldDismissWebView = YES;
            self.checksum = checksum.value;
            return;
        }
    }

    self.completionBlock(nil, NSError.judoMissingChecksumError);
}

@end

@implementation IDEALFormViewController (BankSelectionDelegate)

- (void)tableViewController:(IDEALBankSelectionTableViewController *)controller
              didSelectBank:(IDEALBank *)bank {

    self.selectedBank = bank;
    [self displayPaymentElementsIfNeeded];
    self.selectedBankLabelView.hidden = NO;
    NSBundle *bundle = [NSBundle bundleForClass:IDEALFormViewController.class];

    NSString *iconBundlePath = [bundle pathForResource:@"icons" ofType:@"bundle"];
    NSBundle *iconBundle = [NSBundle bundleWithPath:iconBundlePath];

    NSString *iconName = [NSString stringWithFormat:@"logo-%@", bank.bankIdentifierCode];
    NSString *iconFilePath = [iconBundle pathForResource:iconName ofType:@"png"];

    self.bankSelectionCell.textLabel.text = nil;
    self.bankSelectionCell.imageView.image = [UIImage imageWithContentsOfFile:iconFilePath];

    [NSUserDefaults.standardUserDefaults setInteger:bank.type forKey:@"iDEALBankType"];
}

@end

@implementation IDEALFormViewController (TransactionViewDelegate)

- (void)statusView:(TransactionStatusView *)statusView buttonDidTapWithRetry:(BOOL)shouldRetry {

    if (shouldRetry) {
        [self.transactionStatusView changeStatusTo:IDEALStatusPending andSubtitle:nil];
        [self startPollingStatus];
        return;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
