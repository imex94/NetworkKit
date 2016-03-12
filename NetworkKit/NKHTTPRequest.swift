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

import UIKit

/// HTTP Request error that can occur during network fetching or
/// parsing the data
/// Two main types exist:
///     WARNING: Not serious error, just a warning that somethong went wrong
///     ERROR: Serious error, might cause the app to crash
public enum NKHTTPRequestError: ErrorType {
    case InvalidURL(String)
    case DataTaskError(String)
    case NoDataReturned(String)
    case SerializationException(String)
    case NoInternetConnection(String)
}

/// An extension for the custom error type to return the error message
extension NKHTTPRequestError {
    public var message: String {
        switch self {
            case .InvalidURL(let x): return x
            case .DataTaskError(let x): return x
            case .NoDataReturned(let x): return x
            case .SerializationException(let x): return x
            case .NoInternetConnection(let x): return x
        }
    }
}

/// Successful HTTP Request Closure
public typealias NKHTTPRequestSuccessClosure = (AnyObject) -> Void

/// Failure HTTP Request Closure
public typealias NKHTTPRequestFailureClosure = (NKHTTPRequestError) -> Void

public class NKHTTPRequest: NSObject {
    
    public class func GET(urlString: String, params: [String: String]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        return GET(urlString, auth: nil, params: params, success: success, failure: failure)
    }
    
    /**
     A simple HTTP GET method to get request from a url.
     
     - Parameters:
     - urlString: The string representing the url.
     - params: The parameters you need to pass with the GET method. Everything after '?'.
     - success: Successful closure in case the request was successful.
     - failure: Failure Closure which notifies if any error has occured during the request.
     
     */
    public class func GET(var urlString: String, auth: NKOauth?, params: [String: String]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        guard NKReachability.isNetworkAvailable() else {
            failure(.NoInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if let params = params {
            urlString += "?"
            var counter = 0
            for (key, value) in params {
                if counter == 0 { urlString += "\(key)=\(value)" }
                else {
                    urlString += "&\(key)=\(value)"
                }
                counter++
            }
        }
        
        guard let url = NSURL(string: urlString) else {
            failure(.InvalidURL("ERROR: \(urlString) is an invalid URL for the HTTP Request."))
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if auth != nil { request.setValue(NKAuthentication.authHeader(auth!).authenticationHeaderForRequest(request), forHTTPHeaderField: "Authorization") }
        
        dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    public class func POST(urlString: String, params: [NSObject: AnyObject]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
     
        return POST(urlString, auth: nil, params: params, success: success, failure: failure)
    }
    
    /**
     A simple HTTP POST method to post a resource to the url.
     
     - Parameters:
        - urlString: The string representing the url.
        - params: The body you need to pass with the POST method. Resources you want to pass.
        - success: Successful closure in case the request was successful.
        - failure: Failure Closure which notifies if any error has occured during the request.
     */
    public class func POST(urlString: String, auth: NKOauth?, params: [NSObject: AnyObject]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        guard NKReachability.isNetworkAvailable() else {
            failure(.NoInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        guard let url = NSURL(string: urlString) else {
            
            failure(.InvalidURL("ERROR: \(urlString) is an invalid URL for the HTTP Request."))
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        if params != nil { request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted) }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if auth != nil { request.setValue(NKAuthentication.authHeader(auth!).authenticationHeaderForRequest(request), forHTTPHeaderField: "Authorization") }
        
        dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    public class func DELETE(urlString: String, params: [NSObject: AnyObject]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        return DELETE(urlString, auth: nil, params: params, success: success, failure: failure)
    }
    
    /**
     A simple HTTP DELETE method to delete a resource from the server.
     
     - Parameters:
        - urlString: The string representing the url.
        - params: The body you need to pass with the DELETE method. Resources you want to delete.
        - success: Successful closure in case the request was successful.
        - failure: Failure Closure which notifies if any error has occured during the request.
     */
    public class func DELETE(urlString: String, auth: NKOauth?, params: [NSObject: AnyObject]?, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        guard NKReachability.isNetworkAvailable() else {
            failure(.NoInternetConnection("The Internet connection appears to be offline. Try to connect again."))
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        guard let url = NSURL(string: urlString) else {
            
            failure(.InvalidURL("ERROR: \(urlString) is an invalid URL for the HTTP Request."))
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        if params != nil { request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted) }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if auth != nil { request.setValue(NKAuthentication.authHeader(auth!).authenticationHeaderForRequest(request), forHTTPHeaderField: "Authorization") }
        
        dataTaskWithRequest(request, success: success, failure: failure)
    }
    
    private class func dataTaskWithRequest(request: NSMutableURLRequest, success: NKHTTPRequestSuccessClosure, failure: NKHTTPRequestFailureClosure) {
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (d, r, e) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            guard (e == nil) else {
                
                failure(.InvalidURL("WARNING: \(e!.description)"))
                return
            }
            
            guard let data = d else {
                
                failure(.InvalidURL("WARNING: There was no data returned for this request."))
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var responseDict: AnyObject?
                do {
                    responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    
                    failure(.SerializationException("ERROR: There was an error parsing the data from the response."))
                }
                
                guard let json = responseDict else {
                    
                    failure(.SerializationException("WARNING: There was no data parsed from the response. It's empty. "))
                    return
                }
                
                success(json)
            })
        }
        dataTask.resume()
    }
}
