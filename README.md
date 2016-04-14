<p align= "center">
  <img src="https://github.com/imex94/NetworkKit/blob/master/images/networkKit.png" />
</p>

# NetworkKit ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)

[![Build Status](https://travis-ci.org/imex94/NetworkKit.svg?branch=master)](https://travis-ci.org/imex94/NetworkKit)
[![Available devices](https://camo.githubusercontent.com/30f3ea607a65990e8cf2d6e11a48602167399324/68747470733a2f2f636f636f61706f642d6261646765732e6865726f6b756170702e636f6d2f702f41464e6574776f726b696e672f62616467652e706e67)]()
[![Version](https://img.shields.io/cocoapods/v/NetworkKit.svg?style=flat)](http://cocoapods.org/pods/NetworkKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A lightweight iOS, Mac and Watch OS framework that makes networking and parsing super simple. Uses the open-sourced [JSONHelper](https://github.com/isair/JSONHelper) with functional parsing. For networking the library supports basic **GET**, **POST**, **DELETE** HTTP requests.

## Install

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To install it, simply add the following line to your ```Podfile```:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'NetworkKit'
```

Then run the folloring command:

```
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh) using the following command:

```
$ brew update
$ brew install carthage
```

To integrate NetworkKit into your Xcode project using Carthage, add it into your ```Cartfile```:

```
github "imex94/NetworkKit" ~> 1.3
```

Run ```carthage update``` to build the framework and drag the built ```NetworkKit.framework``` into your Xcode project under **Target** - **General** - **Embedded binaries**:

![Import Framework](https://github.com/imex94/NetworkKit/blob/master/images/import2.png "Import Framework")

## Usage

**NetworkKitExample** project provides a guidance to get started.

For the purpose of this example, let say we want to download one of the stories from Hacker News. For this let's use their API endpoint - https://hacker-news.firebaseio.com/v0/item/11245652.json?print=pretty, which give us the following **JSON** response:


[![Run in Postman](https://run.pstmn.io/button.svg)](https://www.getpostman.com/run-collection/aa59a52596f959def779)

```json
{
  "by": "jergason",
  "id": 11245652,
  "kids": [
    11245801,
    11245962,
    11250239,
    11246046
  ],
  "time": 1457449896,
  "title": "CocoaPods downloads max out five GitHub server CPUs",
  "type": "story"
}
```
We want to deserialize the JSON response above to **Swift object**. To do this, we need a **struct** that conforms the protocol **Deserializable** and implement the **required init(data: [String: AnyObject])** constructor and use the deserialization operator (`<--`):

```swift
import NetworkKit
```

```swift
struct NKItem: Deserializable {
    var id: Int?
    var username: String?
    var kids: [Int]?
    var title: String?
    var type: String?
    var date: NSDate?

    init(data: [String : AnyObject]) {
        id <-- data["id"]
        username <-- data["by"]
        kids <-- data["kids"]
        title <-- data["title"]
        type <-- data["type"]
        date <-- data["time"]
    }
}
```

To connect to an API and perform a **GET** request is simple and intuitive and parsing is like **magic**:

```swift
NKHTTPRequest.GET(
  "https://hacker-news.firebaseio.com/v0/item/11245652.json",                
  params: ["print": "pretty"],
  success: { data in
      var item: NKItem?
      item <-- data                                        
  },
  failure: { error in
      print(error.message)
  })
```

## API

### Networking

#### GET
A simple HTTP GET method to get request from a url.

**urlString** - `String` <br />
The string representing the url. <br />

<!-- **auth (Optional)** - `NKOauth?` <br />
Add Oauth 2.0 when the API requires one. Just specify the consumerKey and consumer Secret, like this
NKOauth(consumerKey: "", consumerSecret: ""). <br /> -->

**params (Optional)** - `[NSObject: AnyObject]?` <br />
The parameters you need to pass with the GET method. Everything after '?'. <br />

**success** - `((AnyObject) -> Void)` <br />
Successful closure in case the request was successful. <br />

**failure** -  `((NKHTTPRequestError) -> Void)` <br />
Failure Closure which notifies if any error has occurred during the request. <br />

#### POST
A simple HTTP POST method to post a resource to the url.

**urlString** - `String` <br />
The string representing the url.

<!-- **auth (Optional)** - `NKOauth?` <br />
Add Oauth 2.0 when the API requires one. Just specify the consumerKey and consumer Secret, like this
NKOauth(consumerKey: "", consumerSecret: ""). <br /> -->

**params (Optional)** - `[NSObject: AnyObject]?` <br />
The body you need to pass with the POST method. Resources you want to pass. <br />

**success** - `((AnyObject) -> Void)` <br />
Successful closure in case the request was successful. <br />

**failure** -  `((NKHTTPRequestError) -> Void)` <br />
Failure Closure which notifies if any error has occured during the request. <br />

#### DELETE
A simple HTTP DELETE method to delete a resource from the server.

**urlString** - `String` <br />
The string representing the url. <br />

<!-- **auth (Optional)** - `NKOauth?` <br />
Add Oauth 2.0 when the API requires one. Just specify the consumerKey and consumer Secret, like this
NKOauth(consumerKey: "", consumerSecret: ""). <br /> -->

**params (Optional)** - `[NSObject: AnyObject]?` <br />
The body you need to pass with the DELETE method. Resources you want to delete. <br />

**success** - `((AnyObject) -> Void)` <br />
Successful closure in case the request was successful. <br />

**failure** -  `((NKHTTPRequestError) -> Void)` <br />
Failure Closure which notifies if any error has occured during the request. <br />

<!-- #### OAuth 2.0

Or if you need OAuth 2.0 to use an API, that's also simple, just include the auth **consumer key** and **consumer secret** when you perform a request:

```swift
NKHTTPRequest.GET(
  "https://hacker-news.firebaseio.com/v0/item/11245652.json",
  auth: NKOauth(consumerKey: "consumerKey", consumerSecret: "consumerSecret"),
  params: ["print": "pretty"],
  success: { data in
      var item: NKEItem?
      item <-- data
  },
  failure: { error in
      print(error.message)
  })
``` -->

#### Cancel HTTP Requests

There are error and internet availability checking implemented in the framework, but you can simply cancel any task you want if its needed:

```swift
let dataTask = NKHTTPRequest.GET(
  "https://hacker-news.firebaseio.com/v0/item/11245652.json",
  params: ["print": "pretty"],
  success: { data in

  },
  failure: { error in
    print(error.message)
})

dataTask?.cancel()
```

### Parsing

Simple use of parsing can be seen above. There are more advanced options to use

#### Assigning default values

```swift
struct NKItem: Deserializable {
    var id = 0
    var username = ""

    init(data: [String : AnyObject]) {
        id <-- data["id"]
        username <-- data["by"]
    }
}
```

#### NSURL Deserialization

```swift
let profileImage: NSURL?
profileImage <-- "https://example.com/images/profile_normal.png"
```

#### NSDate Deserialization

```swift
let date: NSDate?
date <-- 1414172803 // timestamp to NSDate deserialization
```

#### Nested JSON

Let's consider a the truncated version of the Twitter API response:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://www.getpostman.com/run-collection/aa59a52596f959def779)

```json
{
  "text":"Aggressive Ponytail #freebandnames",
  "retweet_count": 2,
  "user":{  
      "name":"Sean Cummings",
      "location":"LA, CA",
      "verified":false,
      "screen_name":"sean_cummings"
  }
}
```

Where you can just simply create a User and a Tweet structure with a user instance inside:

```swift
struct NKTwitterUser: Deserializable {
    var name = ""
    var location = ""
    var verified = false
    var screenName = ""

    init(data: [String : AnyObject]) {
        name <-- data["name"]
        location <-- data["location"]
        verified <-- data["verified"]
        screenName <-- data["screen_name"]
    }
}
```

```swift
struct NKTweet: Deserializable {
    var text = ""
    var retweetCount = 0
    var user: NKTwitterUser?

    init(data: [String : AnyObject]) {
        text <-- data["text"]
        retweetCount <-- data["retweet_count"]
        user <-- data["user"]
    }
}
```

It's that simple.

## License

NetworkKit is available under the MIT license. See the LICENSE file for more info.
MIT ⓒ Alex Telek
