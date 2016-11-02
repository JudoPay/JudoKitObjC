//
//  CardDetailsSetTests.swift
//  JudoKitObjCTests
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

import XCTest

@testable import JudoKitObjC

class CardDetailsSetTests : JudoTestCase {
    
    func testCardDetailsMustBePresent() {
        let cardDetails = getCardDetails()
        
        let jpvc = getJudoPayViewController(cardDetails, paymentToken: nil)
        
        let cardInputField = jpvc.cardInputField
        let expiryDateInputField = jpvc.expiryDateInputField
        
        XCTAssertEqual("4976 0000 0000 3436", cardInputField?.textField.text)
        XCTAssertEqual("12/20", expiryDateInputField?.textField.text)
    }
    
    func testCardDetailsMustBeMasked() {
        let cardDetails = getCardDetails()
        let paymentToken = getPaymentToken()
        
        let jpvc = getJudoPayViewController(cardDetails, paymentToken: paymentToken)
        
        let cardInputField = jpvc.cardInputField
        let expiryDateInputField = jpvc.expiryDateInputField
        
        XCTAssertEqual("**** **** **** 3436", cardInputField?.textField.text)
        XCTAssertEqual("12/20", expiryDateInputField?.textField.text)
    }
    
    func testCardDetailsMustBeNotPresent() {
        let paymentToken = getPaymentToken()
        
        let jpvc = getJudoPayViewController(nil, paymentToken: paymentToken)
        
        let cardInputField = jpvc.cardInputField
        let expiryDateInputField = jpvc.expiryDateInputField
        
        XCTAssertEqual("", cardInputField?.textField.text)
        XCTAssertEqual("", expiryDateInputField?.textField.text)
    }
    
    fileprivate func getCardDetails() -> JPCardDetails {
        return JPCardDetails(cardNumber: "4976000000003436", expiryMonth: 12, expiryYear: 20)
    }
    
    fileprivate func getPaymentToken() -> JPPaymentToken {
        return JPPaymentToken(consumerToken: "MY CONSUMER TOKEN", cardToken: "MY CARD TOKEN")
    }
    
    fileprivate func getJudoPayViewController(_ cardDetails: JPCardDetails?, paymentToken: JPPaymentToken?) -> JudoPayViewController {
        let vc = JudoPayViewController(judoId: myJudoId, amount: oneGBPAmount, reference: validReference, transaction: .payment, currentSession: judo, cardDetails: cardDetails) { (_, _) in }
        vc.paymentToken = paymentToken
        vc.theme = JPTheme()
        _ = vc.view
        return vc
    }
}
