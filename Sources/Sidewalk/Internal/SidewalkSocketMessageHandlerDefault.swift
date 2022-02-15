import Foundation
import Telegraph
import WebKit

class SidewalkSocketMessageHandlerDefault: SidewalkSocketMessageHandler {
    
    unowned let webview: WKWebView
    var completionHandlers: [String: ((Any?, Error?) -> Void)] = [:]
    
    init(webview: WKWebView) {
        self.webview = webview
    }
    
    func didReceive(message: WebSocketMessage, onSocket socket: WebSocket) {
        //TODO: fixme! check tpye and don't force
        let completionMessage = try! JSONDecoder().decode(SidewalkSocketCompletionMessage.self, from: message.payload.data!)
        
        guard let completionHandler = completionHandlers.removeValue(forKey: completionMessage.callbackId) else { return }
        completionHandler(completionMessage.retval?.value, nil)

    }
    
    func send(data: Data, onSocket socket: WebSocket, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        if let completionHandler = completionHandler {
            
            var id = NanoID.new(3)
            completionHandlers[id] = completionHandler

            id.append("|@|")
            var newData = id.data(using: .utf8)!
            newData.append(data)
            

            socket.send(data: newData)
        } else {
            socket.send(data: data)
        }

    }
    
    func send(text: String, onSocket socket: WebSocket, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        
        if let completionHandler = completionHandler {
            var id = NanoID.new(3)
            completionHandlers[id] = completionHandler

            id.append("|@|")
        
            socket.send(text: id + text.base64)
        } else {
            socket.send(text: text.base64)
        }
    }

}
