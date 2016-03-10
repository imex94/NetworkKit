//
//  NKTweet.swift
//  HackerNews
//
//  Created by Alex Telek on 10/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import NetworkKit

extension NKTweet: Equatable { }

func ==(lhs: NKTweet, rhs: NKTweet) -> Bool {
    return lhs.text == rhs.text && lhs.retweetCount == rhs.retweetCount && lhs.id == rhs.id && lhs.user == rhs.user
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
    var id = 0
    var user: NKTwitterUser?
    
    init(data: [String : AnyObject]) {
        text <-- data["text"]
        retweetCount <-- data["retweet_count"]
        id <-- data["id"]
        user <-- data["user"]
    }
}