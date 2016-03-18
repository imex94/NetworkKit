//
//  NKTweet.swift
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


import UIKit
import NetworkKit

extension NKTweet: Equatable { }

func ==(lhs: NKTweet, rhs: NKTweet) -> Bool {
    return lhs.text == rhs.text && lhs.retweetCount == rhs.retweetCount && lhs.user == rhs.user
}

extension NKTwitterUser: Equatable { }

func ==(lhs: NKTwitterUser, rhs: NKTwitterUser) -> Bool {
    return lhs.name == rhs.name && lhs.location == rhs.location && lhs.profileImage == rhs.profileImage && lhs.followers == rhs.followers && lhs.verified == rhs.verified && lhs.screenName == rhs.screenName
}

struct NKTwitterUser: Deserializable {
    var name = ""
    var location = ""
    var profileImage = NSURL()
    var followers = 0
    var verified = false
    var screenName = ""
    
    init(data: [String : AnyObject]) {
        name <-- data["name"]
        location <-- data["location"]
        profileImage <-- data["profile_image_url_https"]
        followers <-- data["followers_count"]
        verified <-- data["verified"]
        screenName <-- data["screen_name"]
    }
}

struct NKTweet: Deserializable {
    var text = ""
    var retweetCount = 0
    var user: NKTwitterUser?
    
    init(data: [String : AnyObject]) {
        text <-- data["text"]
        retweetCount <-- data["retweet_count"]
        user <-- data["user"]
    }
}