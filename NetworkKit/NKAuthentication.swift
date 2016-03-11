//
//  NKAuthentication.swift
//  NetworkKit
//
//  Created by Alex Telek on 11/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import AuthFramework

public struct NKOauth {
    public var consumerKey = ""
    public var consumerSecret = ""
    
    public init(consumerKey: String!, consumerSecret: String!) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
}

class NKAuthentication: NSObject {
    
    class func authHeader(oauth: NKOauth) -> AFAuthClient {
        return AFAuthClient(consumerKey: oauth.consumerKey, consumerSecret: oauth.consumerSecret)
    }
}
