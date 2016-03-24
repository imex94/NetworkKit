//
//  NKReachabilityTests.swift
//  NetworkKit
//
//  Created by Alex Telek on 21/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

#if !os(watchOS)
import XCTest
import SystemConfiguration
@testable import NetworkKit

class NKReachabilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInternetAvailability() {
        if NKReachability.isNetworkAvailable() {
            
            XCTAssertTrue(NKReachability.isNetworkAvailable())
            
        } else {
            
            XCTAssertTrue(!NKReachability.isNetworkAvailable())
        }
    }
    
}
#endif
