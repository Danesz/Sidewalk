# Sidewalk

Proof-of-concept  [`WKWebview.evaluateJavaScript(...)`](https://developer.apple.com/documentation/webkit/wkwebview/1415017-evaluatejavascript) replacement for WebSocket-based Javascript execution.


## Latest version
[![Github tag](https://badgen.net/github/tag/Danesz/Sidewalk)](https://github.com/Danesz/Sidewalk/tags/)

## Goals
- Workaround for a [memory leak in WKWebView](https://bugs.webkit.org/show_bug.cgi?id=215729)
- Provide a different way for JS <-> Swift communication
- Playing with WebSockets
- Playground for [async/await](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html) in Swift 5.5

## Notes
- The project is experimental and full of TODOs !
- Use it for your own risk, test it carefully !
- To send through big amount of data, you need to use `sidewalkJavaScript(data: Data, ...)` method and handle the data in Javascript by yourself. (`customMessageHandler`)
- There is no HTTPS/WSS support yet. If you inject Sidewalk into a page with HTTPS base URL, the connection will fail due to mixed content error
- There is no `completionHandler` implementation yet ---> not possible to access JS execution result
- There is no bidirectional communication yet ---> you can only execute Javascript
- To receive messages from Javascript, you still have to use [`WKScriptMessageHandler`](https://developer.apple.com/documentation/webkit/wkscriptmessagehandler)

## TODOs
- [ ] add HTTPS/WSS support
- [ ] add bidirectional messaging 
- [ ] add completion handler for script evaluation results (async/await with message ID on top of bidirectional messaging)
- [ ] add reconnection logic in case of exceptional socket close
- [ ] here will be the collection of TODOs from the code

## Sample project

This project highlights the problem with `WKWebview.evaluateJavaScript(...)` and shows how to overcome the issue with Sidewalk.
https://github.com/Danesz/SidewalkExample.git


## How to use

1. Install the Swift package
```swift
...
dependencies: [
    .package(url: "https://github.com/Danesz/Sidewalk.git", from: "0.0.2"),
],
...
```

2. A) Attach it to the webview before it loads the page
```swift
import Sidewalk
...

Sidewalk.shared().attachToWebView(webview, when: .atDocumentStart)
webview.loadHTMLString(...)
```

2. B) Or, inject the Javascript manually when needed on the already loaded page
```swift
import Sidewalk
...

Sidewalk.shared().injectNow(webview)
```

3. Execute Javascript via Sidewalk on your WKWebview instance. (Sidewalk defines and extension on the WKWebview class)
```swift
import Sidewalk
...

//old way
//webview.evaluateJavaScript("console.log('I am here')")

//new way
webview.sidewalkJavaScript("console.log('I am here')")
```

4. Tell to Sidewalk to forget your webview once you don't need the webview anymore. (to avoid memory leaks)

```swift
import Sidewalk
...

Sidewalk.shared().forgetWebview(webview)
```

5. (optional) Use custom messaging between JS and Swift.
In this example we send JSON messages to Javascript and inside the webview we can decide how to react based on the message type.

In Swift:
```swift
import Sidewalk
...

struct SidewalkSocketDirectBodyUpdateMessage: Codable {
    let type: String = "bodyUpdate"
    var content: String
}

class SidewalkSocketMessageHandlerJSON: SidewalkSocketMessageHandler {
        
    func didReceive(message: WebSocketMessage, onSocket socket: WebSocket) {
        fatalError("not supported")
    }
    
    func send(data: Data, onSocket socket: WebSocket) {
        fatalError("not supported")
    }
    
    func send(text: String, onSocket socket: WebSocket) {
        do {
            let data = try JSONEncoder().encode(SidewalkSocketDirectBodyUpdateMessage(content: text))
            if let message = String(data: data, encoding: String.Encoding.utf8) {
                socket.send(text: message)
            }
        } catch let error {
            print("SidewalkSocketMessageHandlerJSON error", error.localizedDescription)
        }
    }
    
    func send(message: WebSocketMessage, onSocket socket: WebSocket) {
        fatalError("not supported")
    }

}
```
And receive it in Javascript:
```javascript
Sidewalk.customMessageHandler = function(event){
    let parsed = JSON.parse(event.data);
    if (parsed.type === "bodyUpdate") {
        document.body.innerHTML = parsed.content;
    }
}
```
## Contribution
Any contribution is welcome!
