import Foundation
import Telegraph
import WebKit

class SidewalkSocketMessageHandlerJSON: SidewalkSocketMessageHandler {
    
    unowned let webview: WKWebView
    
    init(webview: WKWebView) {
        self.webview = webview
    }
    
    func didReceive(message: WebSocketMessage, onSocket socket: WebSocket) {
        
    }
    
    func send(data: Data, onSocket socket: WebSocket) {
        fatalError("not supported")
    }
    
    func send(text: String, onSocket socket: WebSocket) {
        do {
            //TODO: check, if base64 is necessary
            let data = try JSONEncoder().encode(SidewalkSocketEvalMessage(evalutation: text.base64))
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
