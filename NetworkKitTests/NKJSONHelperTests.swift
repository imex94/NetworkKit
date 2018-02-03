//
//  NetworkKitTests.swift
//  NetworkKitTests
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

class NKJSONHelperTests: XCTestCase {
    
    var expectationItem: NKHNTestItem?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        expectationItem = NKHNTestItem(data: [
            "id": "11245652",
            "by": "jergason",
            "kids": [
                11245801,
                11245962,
                11245988
            ],
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
    
    func testJSONParsingIntoSwitObjectUsingSimpleJSON() {
        let filePath = Bundle(for: NKJSONHelperTests.self).path(forResource: "hcNews", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        
        var actual: NKHNTestItem?
        let _ = actual <-- json
        
        XCTAssertEqual(actual!, expectationItem)
    }
    
    func testJSONParsingIntoSwiftObjectUsingBigJSON() {
        let filePath = Bundle(for: NKJSONHelperTests.self).path(forResource: "twitter", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
        
        var actual: NKTweet?
        if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
            
            let _ = actual <-- json!["statuses"]![0]
        }
        
        let expectedUser = NKTwitterUser(data: [
            "name": "Sean Cummings",
            "location": "LA, CA",
            "profile_image_url_https": "https://si0.twimg.com/profile_images/2359746665/1v6zfgqo8g0d3mk7ii5s_normal.jpeg",
            "followers_count": 70,
            "verified": false,
            "screen_name": "sean_cummings"
            ])

        XCTAssertEqual(actual!.retweetCount, 0)
        XCTAssertEqual(actual!.text, "Aggressive Ponytail #freebandnames")
        XCTAssertEqual(actual!.user!, expectedUser)
    }
}
