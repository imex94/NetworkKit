//
//  NKHNTestItem.swift
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

extension NKHNTestItem: Equatable { }

func ==(lhs: NKHNTestItem, rhs: NKHNTestItem) -> Bool {
    return lhs.id == rhs.id && lhs.username == rhs.username && lhs.title == rhs.title && lhs.type == rhs.type && lhs.parent == rhs.parent
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
    var date = Date()
    
    /**
     Constructor of the Item class
     
     - Parameters:
     - data: The JSONDictionary parsed by the JSONHelper. @see JSONHelper
     */
    init(data: [String : Any]) {
        let _ = id <-- data["id"]
        let _ = username <-- data["by"]
        let _ = kids <-- data["kids"]
        let _ = title <-- data["title"]
        let _ = type <-- data["type"]
        let _ = parent <-- data["parent"]
        let _ = date <-- data["time"]
    }
}
