//
//  NKEItem.swift
//  NetworkKit
//
//  Created by Alex Telek on 11/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import NetworkKit

struct NKEItem: Deserializable {
    var id = 0
    var username = ""
    var kids = [Int]()
    var title = ""
    var type = ""
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
        date <-- data["time"]
    }
}
