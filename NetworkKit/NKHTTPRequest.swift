//
//  NKHTTPRequest.swift
//  NetworkKit
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

import Foundation

/// HTTP Request error that can occur during network fetching or
/// parsing the data
/// Two main types exist:
///     WARNING: Not serious error, just a warning that somethong went wrong
///     ERROR: Serious error, might cause the app to crash
public enum NKHTTPRequestError: Error {
    case invalidURL(String)
    case dataTaskError(String)
    case noDataReturned(String)
    case serializationException(String)
    case noInternetConnection(String)
}

/// An extension for the custom error type to return the error message
extension NKHTTPRequestError {
    public var message: String {
        switch self {
            case .invalidURL(let x): return x
            case .dataTaskError(let x): return x
            case .noDataReturned(let x): return x
            case .serializationException(let x): return x
            case .noInternetConnection(let x): return x
        }
    }
}

/// Successful HTTP Request Closure
public typealias NKHTTPRequestSuccessClosure = (Any) -> Void

/// Failure HTTP Request Closure
public typealias NKHTTPRequestFailureClosure = (NKHTTPRequestError) -> Void

/// Create an HTTP Request
open class NKHTTPRequest: NSObject {

    /**
     A simple HTTP GET method to get request from a url.
     
     - Parameters:
     - urlString: The string representing the url.
     - params: The parameters you need to pass with the GET method. Everything after '?'.
     - success: Successful closure in case the request was successful.
     - failure: Failure Closure which notifies if any error has occured during the request.
     
     */
    open class func GET(_ urlString: String, params: [String: String]?, success: @escaping NKHTTPRequestSuccessClosure, failure: @escaping NKHTTPRequestFailureClosure) -> URLSessionDataTask? {
        
        #if !os(watchOS)
        guard NKReachability.isNetworkAvailable() else {
            failure(.noInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return nil
        }
        #endif
        
        var urlS = urlString
        if let params = params {
            urlS += "?"
            var counter = 0
            for (key, value) in params {
                if counter == 0 { urlS += "\(key)=\(value)" }
                else {
                    urlS += "&\(key)=\(value)"
                }
                counter += 1
            }
        }
        
        guard let url = URL(string: urlS) else {
            failure(.invalidURL("ERROR: \(urlS) is an invalid URL for the HTTP Request."))
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    /**
     A simple HTTP POST method to post a resource to the url.
     
     - Parameters:
     - urlString: The string representing the url.
     - params: The body you need to pass with the POST method. Resources you want to pass.
     - success: Successful closure in case the request was successful.
     - failure: Failure Closure which notifies if any error has occured during the request.
     */
    open class func POST(_ urlString: String, params: [AnyHashable: Any]?, success: @escaping NKHTTPRequestSuccessClosure, failure: @escaping NKHTTPRequestFailureClosure) -> URLSessionDataTask? {
     
        #if !os(watchOS)
        guard NKReachability.isNetworkAvailable() else {
            failure(.noInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return nil
        }
        #endif
        
        guard let url = URL(string: urlString) else {
            
            failure(.invalidURL("ERROR: \(urlString) is an invalid URL for the HTTP Request."))
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        if params != nil { request.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted) }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    /**
     A simple HTTP DELETE method to delete a resource from the server.
     
     - Parameters:
     - urlString: The string representing the url.
     - params: The body you need to pass with the DELETE method. Resources you want to delete.
     - success: Successful closure in case the request was successful.
     - failure: Failure Closure which notifies if any error has occured during the request.
     */
    open class func DELETE(_ urlString: String, params: [AnyHashable: Any]?, success: @escaping NKHTTPRequestSuccessClosure, failure: @escaping NKHTTPRequestFailureClosure) -> URLSessionDataTask? {
        
        #if !os(watchOS)
        guard NKReachability.isNetworkAvailable() else {
            failure(.noInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return nil
        }
        #endif
        
        guard let url = URL(string: urlString) else {
            
            failure(.invalidURL("ERROR: \(urlString) is an invalid URL for the HTTP Request."))
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        if params != nil { request.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted) }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    fileprivate class func dataTaskWithRequest(_ request: NSMutableURLRequest, success: @escaping NKHTTPRequestSuccessClosure, failure: @escaping NKHTTPRequestFailureClosure) -> URLSessionDataTask {
        
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (d, r, e) in
            
            guard (e == nil) else {
                
                failure(.invalidURL("WARNING: \(e!.localizedDescription)"))
                return
            }
            
            guard let data = d else {
                
                failure(.invalidURL("WARNING: There was no data returned for this request."))
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                var responseDict: Any?
                do {
                    responseDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                } catch {
                    
                    failure(.serializationException("ERROR: There was an error parsing the data from the response."))
                }
                
                guard let json = responseDict else {
                    
                    failure(.serializationException("WARNING: There was no data parsed from the response. It's empty. "))
                    return
                }
                
                success(json)
            })
        }
        dataTask.resume()
        
        return dataTask
    }
}
