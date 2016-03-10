//
//  NKHNTestItem.swift
//  HackerNews
//
//  Created by Alex Telek on 09/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import NetworkKit

extension NKHNTestItem: Equatable { }

func ==(lhs: NKHNTestItem, rhs: NKHNTestItem) -> Bool {
    return lhs.id == rhs.id && lhs.username == rhs.username && lhs.title == rhs.title && lhs.type == rhs.type && lhs.parent == rhs.parent && lhs.date == rhs.date
}

/**
 An instance of an Item object.
 */
struct NKHNTestItem: Deserializable {
    var id = 0
    var username = ""
    var kids = [Int]()
    var title = ""
    var type = ""
    var parent = 0
    var date = NSDate()
    
    /**
     Constructor of the Item class
     
     - Parameters:
     - data: The JSONDictionary parsed by the JSONHelper. @see JSONHelper
     */
    init(data: [String : AnyObject]) {
        id <-- data["id"]
        username <-- data["by"]
        kids <-- data["kids"]
        title <-- data["title"]
        type <-- data["type"]
        parent <-- data["parent"]
        date <-- data["time"]
    }
}
