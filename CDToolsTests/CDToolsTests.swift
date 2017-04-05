//
//  CDToolsTests.swift
//  CDToolsTests
//
//  Created by Christian Deckert on 08.09.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import XCTest
@testable import CDTools

class CDToolsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDispatch() {

        DispatchQueue(preferredQueue: .priorityBackground, preferredDelay: 0.4).dispatch {
            print("do work")
            
            }.then { successful in
                print("done")
        }
        
        XCTAssert(true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
