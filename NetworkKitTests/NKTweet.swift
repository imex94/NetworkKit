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

import NetworkKit

extension NKTweet: Equatable { }

func ==(lhs: NKTweet, rhs: NKTweet) -> Bool {
    return lhs.text == rhs.text && lhs.retweetCount == rhs.retweetCount && lhs.user == rhs.user
}

extension NKTwitterUser: Equatable { }

func ==(lhs: NKTwitterUser, rhs: NKTwitterUser) -> Bool {
    return lhs.name == rhs.name && lhs.location == rhs.location && lhs.profileImage?.absoluteString == rhs.profileImage?.absoluteString && lhs.followers == rhs.followers && lhs.verified == rhs.verified && lhs.screenName == rhs.screenName
}

struct NKTwitterUser: Deserializable {
    var name = ""
    var location = ""
    var profileImage = URL(string: "")
    var followers = 0
    var verified = false
    var screenName = ""
    
    init(data: [String : Any]) {
        let _ = name <-- data["name"]
        let _ = location <-- data["location"]
        let _ = profileImage <-- data["profile_image_url_https"]
        let _ = followers <-- data["followers_count"]
        let _ = verified <-- data["verified"]
        let _ = screenName <-- data["screen_name"]
    }
}

struct NKTweet: Deserializable {
    var text = ""
    var retweetCount = 0
    var user: NKTwitterUser?
    
    init(data: [String : Any]) {
        let _ = text <-- data["text"]
        let _ = retweetCount <-- data["retweet_count"]
        let _ = user <-- data["user"]
    }
}
