//
//  NKReachability.swift
//  HackerNews
//
//  Created by Alex Telek on 09/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import SystemConfiguration

/// reachability class for checking if the internet connection is available
class NKReachability: NSObject {
    
    /**
     Reachability method to check internet connection, using
     System Configuration
     
     - Returns: *true* if thee is internet connection, *false* otherwise
     */
    class func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
