//
//  JSONHelper.swift
//
//  Created by Baris Sencan on 28/08/2014.
//  Copyright 2014 Baris Sencan
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/isair/JSONHelper
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import Foundation

/// A type of dictionary that only uses strings for keys and can contain any
/// type of object as a value.
public typealias JSONDictionary = [String: Any]

/// Operator for use in deserialization operations.
precedencegroup DeseralizationPrecendence {
    associativity: right
}

infix operator <-- : DeseralizationPrecendence

/// Returns nil if given object is of type NSNull.
///
/// :param: object Object to convert.
///
/// :returns: nil if object is of type NSNull, else returns the object itself.
private func convertToNilIfNull(_ object: Any?) -> Any? {
    if object is NSNull {
        return nil
    }
    return object
}

// MARK: Primitive Type Deserialization

// For optionals.
public func <-- <T>(property: inout T?, value: Any?) -> T? {
    var newValue: T?
    let _ = ""
    if let unwrappedValue: Any = convertToNilIfNull(value) {
        // We unwrapped the given value successfully, try to convert.
        if let convertedValue = unwrappedValue as? T {
            // Convert by just type-casting.
            newValue = convertedValue
        } else {
            // Convert by processing the value first.
            switch property {
            case is Int?:
                if unwrappedValue is String {
                    if let intValue = Int("\(unwrappedValue)") {
                        newValue = intValue as? T
                    }
                }
            case is URL?:
                newValue = URL(string: "\(unwrappedValue)") as? T
            case is Date?:
                if let timestamp = unwrappedValue as? Int {
                    newValue = Date(timeIntervalSince1970: Double(timestamp)) as? T
                } else if let timestamp = unwrappedValue as? Double {
                    newValue = Date(timeIntervalSince1970: timestamp) as? T
                } else if let timestamp = unwrappedValue as? NSNumber {
                    newValue = Date(timeIntervalSince1970: timestamp.doubleValue) as? T
                }
            default:
                break
            }
        }
    }
    property = newValue
    return property
}

// For non-optionals.
public func <-- <T>(property: inout T, value: Any?) -> T {
    var newValue: T?
    let _ = newValue <-- value
    if let newValue = newValue { property = newValue }
    return property
}

// Special handling for value and format pair to NSDate conversion.
public func <-- (property: inout Date?, valueAndFormat: (Any?, Any?)) -> Date? {
    var newValue: Date?
    if let dateString = convertToNilIfNull(valueAndFormat.0) as? String {
        if let formatString = convertToNilIfNull(valueAndFormat.1) as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formatString
            if let newDate = dateFormatter.date(from: dateString) {
                newValue = newDate
            }
        }
    }
    property = newValue
    return property
}

public func <-- (property: inout Date, valueAndFormat: (Any?, Any?)) -> Date {
    var date: Date?
    let _ = date <-- valueAndFormat
    if let date = date { property = date }
    return property
}

// MARK: Primitive Array Deserialization

public func <-- (array: inout [String]?, value: Any?) -> [String]? {
    if let stringArray = convertToNilIfNull(value) as? [String] {
        array = stringArray
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [String], value: Any?) -> [String] {
    var newValue: [String]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Int]?, value: Any?) -> [Int]? {
    if let intArray = convertToNilIfNull(value) as? [Int] {
        array = intArray
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [Int], value: Any?) -> [Int] {
    var newValue: [Int]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Float]?, value: Any?) -> [Float]? {
    if let floatArray = convertToNilIfNull(value) as? [Float] {
        array = floatArray
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [Float], value: Any?) -> [Float] {
    var newValue: [Float]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Double]?, value: Any?) -> [Double]? {
    if let doubleArrayDoubleExcitement = convertToNilIfNull(value) as? [Double] {
        array = doubleArrayDoubleExcitement
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [Double], value: Any?) -> [Double] {
    var newValue: [Double]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Bool]?, value: Any?) -> [Bool]? {
    if let boolArray = convertToNilIfNull(value) as? [Bool] {
        array = boolArray
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [Bool], value: Any?) -> [Bool] {
    var newValue: [Bool]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [URL]?, value: Any?) -> [URL]? {
    if let stringURLArray = convertToNilIfNull(value) as? [String] {
        array = [URL]()
        for stringURL in stringURLArray {
            if let url = URL(string: stringURL) {
                array!.append(url)
            }
        }
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [URL], value: Any?) -> [URL] {
    var newValue: [URL]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Date]?, valueAndFormat: (Any?, Any?)) -> [Date]? {
    var newValue: [Date]?
    if let dateStringArray = convertToNilIfNull(valueAndFormat.0) as? [String] {
        if let formatString = convertToNilIfNull(valueAndFormat.1) as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formatString
            newValue = [Date]()
            for dateString in dateStringArray {
                if let date = dateFormatter.date(from: dateString) {
                    newValue!.append(date)
                }
            }
        }
    }
    array = newValue
    return array
}

public func <-- (array: inout [Date], valueAndFormat: (Any?, Any?)) -> [Date] {
    var newValue: [Date]?
    let _ = newValue <-- valueAndFormat
    if let newValue = newValue { array = newValue }
    return array
}

public func <-- (array: inout [Date]?, value: Any?) -> [Date]? {
    if let timestamps = convertToNilIfNull(value) as? [Any] {
        array = [Date]()
        for timestamp in timestamps {
            var date: Date?
            let _ = date <-- timestamp
            if date != nil { array!.append(date!) }
        }
    } else {
        array = nil
    }
    return array
}

public func <-- (array: inout [Date], value: Any?) -> [Date] {
    var newValue: [Date]?
    let _ = newValue <-- value
    if let newValue = newValue { array = newValue }
    return array
}


// MARK: Primitive Map Deserialization

public func <-- (map: inout [String: String]?, value: Any?) -> [String: String]? {
    if let stringMap = convertToNilIfNull(value) as? [String: String] {
        map = stringMap
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: String], value: Any?) -> [String: String] {
    var newValue: [String: String]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Int]?, value: Any?) -> [String: Int]? {
    if let intMap = convertToNilIfNull(value) as? [String: Int] {
        map = intMap
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: Int], value: Any?) -> [String: Int] {
    var newValue: [String: Int]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Float]?, value: Any?) -> [String: Float]? {
    if let floatMap = convertToNilIfNull(value) as? [String: Float] {
        map = floatMap
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: Float], value: Any?) -> [String: Float] {
    var newValue: [String: Float]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Double]?, value: Any?) -> [String: Double]? {
    if let doubleMapDoubleExcitement = convertToNilIfNull(value) as? [String: Double] {
        map = doubleMapDoubleExcitement
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: Double], value: Any?) -> [String: Double] {
    var newValue: [String: Double]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Bool]?, value: Any?) -> [String: Bool]? {
    if let boolMap = convertToNilIfNull(value) as? [String: Bool] {
        map = boolMap
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: Bool], value: Any?) -> [String: Bool] {
    var newValue: [String: Bool]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: URL]?, value: Any?) -> [String: URL]? {
    if let stringURLMap = convertToNilIfNull(value) as? [String: String] {
        map = [String: URL]()
        for (key, stringURL) in stringURLMap {
            if let url = URL(string: stringURL) {
                map![key] = url
            }
        }
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: URL], value: Any?) -> [String: URL] {
    var newValue: [String: URL]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Date]?, valueAndFormat: (Any?, Any?)) -> [String: Date]? {
    var newValue: [String: Date]?
    if let dateStringMap = convertToNilIfNull(valueAndFormat.0) as? [String: String] {
        if let formatString = convertToNilIfNull(valueAndFormat.1) as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formatString
            newValue = [String: Date]()
            for (key, dateString) in dateStringMap {
                if let date = dateFormatter.date(from: dateString) {
                    newValue![key] = date
                }
            }
        }
    }
    map = newValue
    return map
}

public func <-- (map: inout [String: Date], valueAndFormat: (Any?, Any?)) -> [String: Date] {
    var newValue: [String: Date]?
    let _ = newValue <-- valueAndFormat
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- (map: inout [String: Date]?, value: Any?) -> [String: Date]? {
    if let timestamps = convertToNilIfNull(value) as? [String: Any] {
        map = [String: Date]()
        for (key, timestamp) in timestamps {
            var date: Date?
            let _ = date <-- timestamp
            if date != nil { map![key] = date! }
        }
    } else {
        map = nil
    }
    return map
}

public func <-- (map: inout [String: Date], value: Any?) -> [String: Date] {
    var newValue: [String: Date]?
    let _ = newValue <-- value
    if let newValue = newValue { map = newValue }
    return map
}


// MARK: Custom Object Deserialization

public protocol Deserializable {
    init(data: JSONDictionary)
}

public func <-- <T: Deserializable>(instance: inout T?, dataObject: Any?) -> T? {
    if let data = convertToNilIfNull(dataObject) as? JSONDictionary {
        instance = T(data: data)
    } else {
        instance = nil
    }
    return instance
}

public func <-- <T: Deserializable>(instance: inout T, dataObject: Any?) -> T {
    var newInstance: T?
    let _ = newInstance <-- dataObject
    if let newInstance = newInstance { instance = newInstance }
    return instance
}

// MARK: Custom Object Array Deserialization

public func <-- <T: Deserializable>(array: inout [T]?, dataObject: Any?) -> [T]? {
    if let dataArray = convertToNilIfNull(dataObject) as? [JSONDictionary] {
        array = [T]()
        for data in dataArray {
            array!.append(T(data: data))
        }
    } else {
        array = nil
    }
    return array
}

public func <-- <T: Deserializable>(array: inout [T], dataObject: Any?) -> [T] {
    var newArray: [T]?
    let _ = newArray <-- dataObject
    if let newArray = newArray { array = newArray }
    return array
}

// MARK: Custom Object Map Deserialization

public func <-- <T: Deserializable>(map: inout [String: T]?, dataObject: Any?) -> [String: T]? {
    if let dataMap = convertToNilIfNull(dataObject) as? [String: JSONDictionary] {
        map = [String: T]()
        for (key, data) in dataMap {
            map![key] = T(data: data)
        }
    } else {
        map = nil
    }
    return map
}

public func <-- <T: Deserializable>(map: inout [String: T], dataObject: Any?) -> [String: T] {
    var newMap: [String: T]?
    let _ = newMap <-- dataObject
    if let newMap = newMap { map = newMap }
    return map
}

// MARK: Raw Value Representable (Enum) Deserialization

public func <-- <T: RawRepresentable>(property: inout T?, value: Any?) -> T? {
    var newEnumValue: T?
    var newRawEnumValue: T.RawValue?
    let _ = newRawEnumValue <-- value
    if let unwrappedNewRawEnumValue = newRawEnumValue {
        if let enumValue = T(rawValue: unwrappedNewRawEnumValue) {
            newEnumValue = enumValue
        }
    }
    property = newEnumValue
    return property
}

// For non-optionals.
public func <-- <T: RawRepresentable>(property: inout T, value: Any?) -> T {
    var newValue: T?
    let _ = newValue <-- value
    if let newValue = newValue { property = newValue }
    return property
}

// MARK: JSON String Deserialization

private func dataStringToObject(_ dataString: String) -> Any? {
    let data: Data = dataString.data(using: String.Encoding.utf8)!
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        return jsonObject as Any?
    } catch {
        return nil
    }
}

public func <-- <T: Deserializable>(instance: inout T?, dataString: String) -> T? {
    return instance <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(instance: inout T, dataString: String) -> T {
    return instance <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(array: inout [T]?, dataString: String) -> [T]? {
    return array <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(array: inout [T], dataString: String) -> [T] {
    return array <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(map: inout [String: T]?, dataString: String) -> [String:T]? {
    return map <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(map: inout [String: T], dataString: String) -> [String:T] {
    return map <-- dataStringToObject(dataString)
}


