//
//  JPValidationResult.m
//  InputFieldTest
//
//  Created by Mihai Petrenco on 12/10/19.
//  Copyright © 2019 Mihai Petrenco. All rights reserved.
//

#import "JPValidationResult.h"

@implementation JPValidationResult

- (instancetype)initWithResult:(BOOL)isValid
                isInputAllowed:(BOOL)isInputAllowed
                  errorMessage:(NSString *)errorMessage
                   cardNetwork:(CardNetwork)cardNetwork
                formattedInput:(NSString *)formattedInput{
    
    if (self = [super init]) {
        self.isValid = isValid;
        self.isInputAllowed = isInputAllowed;
        self.errorMessage = errorMessage;
        self.cardNetwork = cardNetwork;
        self.formattedInput = formattedInput;
    }
    return self;
}

+ (instancetype)validationWithResult:(BOOL)isValid
                        inputAllowed:(BOOL)isInputAllowed
                        errorMessage:(NSString *)errorMessage
                         cardNetwork:(CardNetwork)cardNetwork
                      formattedInput:(NSString *)formattedInput{
    
    return [[JPValidationResult alloc] initWithResult:isValid
                                       isInputAllowed:isInputAllowed
                                         errorMessage:errorMessage
                                          cardNetwork:cardNetwork
                                       formattedInput:formattedInput];
}

@end
