//
//  NKHTTPRequestTests.swift
//  HackerNews
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alex Telek
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
@testable import NetworkKit

class NKHTTPRequestTests: XCTestCase {
    
    var expectationItem: NKHNTestItem?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        expectationItem = NKHNTestItem(data: [
            "id": "11245652",
            "by": "jergason",
            "kids": [11245801, 11245962, 11245988, 11246458, 11245828, 11246239, 11247401, 11246103, 11246312, 11246283, 11246651, 11245938, 11248198, 11247700, 11246079, 11245996, 11246061, 11246324, 11247246, 11249042, 11247608, 11246402, 11247078, 11246188, 11250241, 11246207, 11250426, 11246788, 11247452, 11246175, 11245831, 11254446, 11246106, 11246009, 11246892, 11247181, 11245832, 11250609, 11253252, 11246384, 11246748, 11246046, 11247933, 11250239],
            "title": "CocoaPods downloads max out five GitHub server CPUs",
            "type": "story",
            "parent": 0,
            "time": 1457449896
            ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGETRequest() {
        let expectation = self.expectation(description: "Test GET HTTP Request")
        
        var item: NKHNTestItem?
        var errorMessage: String?
        
        if !NKReachability.isNetworkAvailable() {
            XCTAssertTrue(true)
        } else {
            _ = NKHTTPRequest.GET(
                "https://hacker-news.firebaseio.com/v0/item/11245652.json",
                params: ["print": "pretty"],
                success: { data in
                    
                    let _ = item <-- data
                    
                    expectation.fulfill()
                },
                failure: { error in
                    errorMessage = error.message
                    
                    expectation.fulfill()
            })
            
            waitForExpectations(timeout: 10.0, handler: nil)
            
            XCTAssertEqual(item, self.expectationItem)
            XCTAssertNil(errorMessage)
        }
    }
    
    func testHTTPRequestCancelledShouldResultWarning() {
        let expectation = self.expectation(description: "Test GET HTTP Request")
        
        var item: NKHNTestItem?
        var errorMessage: String?
        
        if !NKReachability.isNetworkAvailable() {
            XCTAssertTrue(true)
        } else {
            let task = NKHTTPRequest.GET(
                "https://hacker-news.firebaseio.com/v0/item/11245652.json",
                params: ["print": "pretty"],
                success: { data in
                    
                    let _ = item <-- data
                    
                    expectation.fulfill()
                },
                failure: { error in
                    
                    errorMessage = error.message
                    
                    expectation.fulfill()
            })
            task?.cancel()
            
            waitForExpectations(timeout: 10.0, handler: nil)
            
            XCTAssertNil(item)
            XCTAssertNotNil(errorMessage)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
            _ = NKHTTPRequest.GET(
                "https://hacker-news.firebaseio.com/v0/item/11245652.json",
                params: ["print": "pretty"],
                success: { data in
                },
                failure: { error in
            })
            
        }
    }
    
}
