# NetworkKit

A lightweight iOS, Mac and Watch OS framework that makes networking and parsing super simple. Uses the open-sourced [JSONHelper](https://github.com/isair/JSONHelper) with functional parsing. For networking the library supports basic GET, POST, DELETE HTTP requests.

_Authentication coming soon_.

## Install

### Framework

Download **NetworkKit.framework** file in the Framework folder and drag it into your application.

Make sure you copy the framework into the project directory and in side the **Project Target** - **Build Phases** - **Link Binary With Libraries** you have added the framework.

![Import Framework](https://github.com/imex94/NetworkKit/blob/master/images/import.png "Import Framework")

## Usage

To connect to an API and perform a **GET** request is simple and intuitive, something like this

```swift
NKHTTPRequest.GET(
  "https://hacker-news.firebaseio.com/v0/item/11245652.json",                
  params: ["print": "pretty"],
  success: { data in
      var item: NKHNItem?
      item <-- data                                        
  },
  failure: { error in
      print(error.message)
  })
```
