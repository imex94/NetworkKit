//
//  ViewController.swift
//  NetworkKitExample
//
//  Created by Alex Telek on 11/03/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import NetworkKit

class NKEViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NKHTTPRequest.GET(
            "https://hacker-news.firebaseio.com/v0/item/11245652.json",
            params: ["print": "pretty"],
            success: { data in
                
                var item: NKEItem?
                item <-- data
                
                print(item)
            },
            failure: { error in
                print(error.message)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

