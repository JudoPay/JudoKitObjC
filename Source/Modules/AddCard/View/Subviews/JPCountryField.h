//
//  JPCountryField.h
//  JudoKitObjC
//
//  Created by Mihai Petrenco on 12/11/19.
//  Copyright © 2019 Judo Payments. All rights reserved.
//

#import "JPTextField.h"
#import "JPAddCardViewModel.h"

@interface JPCountryField : JPTextField
- (void)configureWithViewModel:(JPAddCardPickerViewModel *)viewModel;
@end
