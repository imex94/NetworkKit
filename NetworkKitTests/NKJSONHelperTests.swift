//
//  NetworkKitTests.swift
//  NetworkKitTests
//
//  Created by Alex Telek on 09/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

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
        let filePath = NSBundle(forClass: NKJSONHelperTests.self).pathForResource("hcNews", ofType: "json")
        let data = NSData(contentsOfFile: filePath!)
        let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        
        var actual: NKHNTestItem?
        actual <-- json
        
        XCTAssertTrue(actual! == expectationItem)
    }
    
    func testJSONParsingIntoSwiftObjectUsingBigJSON() {
        let filePath = NSBundle(forClass: NKJSONHelperTests.self).pathForResource("twitter", ofType: "json")
        let data = NSData(contentsOfFile: filePath!)
        let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        
        var actual = [NKTweet]()
        actual <-- json!["statuses"]
        
        let tweet = actual[0]
        
        let expectedUser = NKTwitterUser(data: [
            "name": "Sean Cummings",
            "location": "LA, CA",
            "profile_image_url_https": "https://si0.twimg.com/profile_images/2359746665/1v6zfgqo8g0d3mk7ii5s_normal.jpeg",
            "followers_count": 70,
            "verified": false,
            "screen_name": "sean_cummings"
            ])
        
        XCTAssertEqual(tweet.id, 250075927172759552)
        XCTAssertEqual(tweet.retweetCount, 0)
        XCTAssertEqual(tweet.text, "Aggressive Ponytail #freebandnames")
        XCTAssertEqual(tweet.user!, expectedUser)
    }
}
