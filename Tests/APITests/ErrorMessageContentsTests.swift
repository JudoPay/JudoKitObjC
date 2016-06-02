//
//  ErrorMessageContentsTests.swift
//  JudoKitObjCTests
//
//  Created by Ashley Barrett on 08/04/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import XCTest

let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request."
let UnableToProcessRequestErrorTitle = "Unable to process"

let ErrorRequestFailed = "The request responded without data"
let ErrorPaymentMethodMissing = "The payment method (card details, token or PKPayment) has not been set for a transaction that requires it (custom UI)"
let ErrorAmountMissing = "The amount has not been set for a transaction that requires it (custom UI)"
let ErrorReferenceMissing = "The reference has not been set for a transaction that requires it (custom UI)"
let ErrorResponseParseError = "An error with a response from the backend API"
let ErrorUserDidCancel = "Received when user cancels the payment journey"
let ErrorParameterError = "A parameter entered into the dictionary (request body to Judo API) is not set"
let ErrorFailed3DSRequest = "After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page"

let JPErrorTitleKey = "JPErrorTitleKey"

let Error3DSRequest = "Error when routing to 3DS"
let ErrorUnderlyingError = "An error in the iOS system with an enclosed underlying error"
let ErrorTransactionDeclined = "A transaction that was sent to the backend returned declined"

class ErrorMessageContentsTests: JudoTestCase {
    
    func test_ErrorRequestFailed() {
        let actual = NSError.judoRequestFailedError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorRequestFailed)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorPaymentMethodMissing() {
        let actual = NSError.judoPaymentMethodMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorPaymentMethodMissing)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorAmountMissing() {
        let actual = NSError.judoAmountMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorAmountMissing)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorReferenceMissing() {
        let actual = NSError.judoReferenceMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorReferenceMissing)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorResponseParseError() {
        let actual = NSError.judoResponseParseError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorResponseParseError)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorUserDidCancel() {
        let actual = NSError.judoUserDidCancelError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, nil);
        XCTAssertEqual(devDescription, ErrorUserDidCancel)
        XCTAssertEqual(errorTitle, nil)
    }
    
    func test_ErrorParameterError() {
        let actual = NSError.judoParameterError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorParameterError)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
    
    func test_ErrorFailed3DSRequest() {
        let actual = NSError.judo3DSRequestFailedErrorWithUnderlyingError(nil);
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        let errorTitle = actual.userInfo[JPErrorTitleKey] as? String
        
        XCTAssertEqual(errorDescription, UnableToProcessRequestErrorDesc)
        XCTAssertEqual(devDescription, ErrorFailed3DSRequest)
        XCTAssertEqual(errorTitle, UnableToProcessRequestErrorTitle)
    }
}
