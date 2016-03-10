# NetworkKit

A lightweight iOS, Mac and Watch OS framework that makes networking and parsing super simple. Uses the open-sourced [JSONHelper](https://github.com/isair/JSONHelper) with functional parsing. For networking the library supports basic **GET**, **POST**, **DELETE** HTTP requests.

_Authentication coming soon_

## Install

### Framework

Download **NetworkKit.framework** file in the Framework folder and drag it into your application.

Make sure you copy the framework into the project directory and in side the **Project Target** - **Build Phases** - **Link Binary With Libraries** you have added the framework.

![Import Framework](https://github.com/imex94/NetworkKit/blob/master/images/import.png "Import Framework")

## Usage

For the purpose of this example, let say we want to download one of the stories from Hacker News. For this let's use their API endpoint - https://hacker-news.firebaseio.com/v0/item/11245652.json?print=pretty, which give us the following **JSON** response:

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

**GET** - A simple HTTP GET method to get request from a url.

_Parameters_

`urlString`: The string representing the url.
`params`: The parameters you need to pass with the GET method. Everything after '?'.
`success`: Successful closure in case the request was successful.
`failure`: Failure Closure which notifies if any error has occurred during the request.


### Parsing

## License

MIT ⓒ Alex Telek
