//
//  QuoteClientTests.swift
//  QuoteClientTests
//
//  Created by Adolfo Vera Blasco on 24/5/16.
//  Copyright © 2016 Adolfo Vera Blasco. All rights reserved.
//

import XCTest
@testable import QuoteClient

class QuoteClientTests: XCTestCase {
    ///
    private var characters: [String]!

    ///
    private var character: String
    {
        let random: Int = Int(arc4random_uniform(UInt32(self.characters.count)))
        return self.characters[random]
    }

    override func setUp() 
    {
        super.setUp()

        self.characters = [ "bran", "tyrion", "cersei", "bronn", "jaime", "olenna" ]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRandomQuote() -> Void
    {
        let expectation: XCTestExpectation = self.expectationWithDescription("Test for random quote")
        
        QuoteClient.quoteInstance.randomQuote { (result) -> (Void) in
            switch result
            {
                case let QuoteResult.Success(result: (quote, character)):
                    print("\(quote)\r\n\t- \(character)")
                case let QuoteResult.Error(reason):
                    print("error: \(reason)")
            }
            
            expectation.fulfill()
        }
        
        // Esperamos a que la llamada al servicio termine...
        self.waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            if let error = error
            {
                print("Algo ha ido mal mientras esperamos... \(error.description)")
            }
        }
    }
    
    func testQuoteForCharacter() -> Void
    {
        let expectation: XCTestExpectation = self.expectationWithDescription("Test for character quote")
        
        QuoteClient.quoteInstance.quoteByCharacter(self.character) { (result) -> (Void) in
            switch result
            {
                case let QuoteResult.Success(result: (quote, character)):
                    print("\(quote)\r\n\t- \(character)")
                case let QuoteResult.Error(reason):
                    print("error: \(reason)")
            }
            
            expectation.fulfill()
        }
        
        // Esperamos a que la llamada al servicio termine...
        self.waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            if let error = error
            {
                print("Algo ha ido mal mientras esperamos... \(error.description)")
            }
        }

    }
    
    
    func testRandomPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.testRandomQuote()
        }
    }
    
    func testCharacterPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.testQuoteForCharacter()
        }
    }
}
