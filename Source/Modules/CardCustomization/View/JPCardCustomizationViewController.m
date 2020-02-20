//
//  JPCardCustomizationViewController.m
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

#import "JPCardCustomizationViewController.h"
#import "JPCardCustomizationView.h"
#import "UIImage+Additions.h"
#import "JPCardCustomizationPresenter.h"

@implementation JPCardCustomizationViewController

#pragma mark - View lifecycle

- (void)loadView {
    self.cardCustomizationView = [JPCardCustomizationView new];
    self.view = self.cardCustomizationView;
    [self configureView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter prepareViewModel];
}

#pragma mark - User actions

- (void)onBackButtonTap {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Layout setup

- (void)configureView {
    [self configureNavigationBar];
    self.cardCustomizationView.tableView.delegate = self;
    self.cardCustomizationView.tableView.dataSource = self;
}

- (void)configureNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageWithIconName:@"back-icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonTap) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backBarButton.customView.heightAnchor constraintEqualToConstant:22.0].active = YES;
    [backBarButton.customView.widthAnchor constraintEqualToConstant:22.0].active = YES;
    self.navigationItem.leftBarButtonItem = backBarButton;
}

@end

@implementation JPCardCustomizationViewController (TableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

@end

@implementation JPCardCustomizationViewController (TableViewDelegate)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

