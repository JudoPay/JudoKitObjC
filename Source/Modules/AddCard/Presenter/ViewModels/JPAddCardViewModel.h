//
//  JPAddCardViewModel.h
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

#import <Foundation/Foundation.h>

/**
 * An enum that defines the input field types present in the Add Card view
 */
typedef NS_ENUM(NSInteger, JPInputType) {
    JPInputTypeCardNumber,
    JPInputTypeCardholderName,
    JPInputTypeCardExpiryDate,
    JPInputTypeCardSecureCode,
    JPInputTypeCardCountry,
    JPInputTypeCardPostalCode,
    JPInputTypeOther
};

#pragma mark - JPAddCardInputFieldViewModel

@interface JPAddCardInputFieldViewModel : NSObject
/**
 * The type of the input field
 */
@property (nonatomic, assign) JPInputType type;

/**
 * The text string of the input field
 */
@property (nonatomic, strong) NSString *text;

/**
 * The placeholder string of the input field
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 * The error string of the input field
 */
@property (nonatomic, strong) NSString *errorText;

@end

#pragma mark - JPAddCardButtonViewModel

@interface JPAddCardButtonViewModel : NSObject

/**
 * The title of the button
 */
@property (nonatomic, strong) NSString *title;

/**
 * A boolean value that indicates if the button is enabled
 */
@property (nonatomic, assign) BOOL isEnabled;

@end

#pragma mark - JPAddCardPickerViewModel

@interface JPAddCardPickerViewModel : JPAddCardInputFieldViewModel

/**
 * An array of strings that act as picker titles
 */
@property (nonatomic, strong) NSArray *pickerTitles;

@end

#pragma mark - JPAddCardViewModel

@interface JPAddCardViewModel : NSObject

@property (nonatomic, assign) double sliderHeight;

@property (nonatomic, assign) BOOL shouldDisplayAVSFields;

/**
 * The JPAddCardInputFieldViewModel for the card number input field
 */
@property (nonatomic, strong) JPAddCardInputFieldViewModel *cardNumberViewModel;

/**
 * The JPAddCardInputFieldViewModel for the cardholder name input field
 */
@property (nonatomic, strong) JPAddCardInputFieldViewModel *cardholderNameViewModel;

/**
 * The JPAddCardInputFieldViewModel for the expiry date input field
 */
@property (nonatomic, strong) JPAddCardInputFieldViewModel *expiryDateViewModel;

/**
 * The JPAddCardInputFieldViewModel for the secure code input field
 */
@property (nonatomic, strong) JPAddCardInputFieldViewModel *secureCodeViewModel;

/**
 * The JPAddCardPickerViewModel for the country picker
 */
@property (nonatomic, strong) JPAddCardPickerViewModel *countryPickerViewModel;

/**
 * The JPAddCardInputFieldViewModel for the postal code input field
 */
@property (nonatomic, strong) JPAddCardInputFieldViewModel *postalCodeInputViewModel;

/**
 * The JPAddCardButtonViewModel for the add card button
 */
@property (nonatomic, strong) JPAddCardButtonViewModel *addCardButtonViewModel;

@end
