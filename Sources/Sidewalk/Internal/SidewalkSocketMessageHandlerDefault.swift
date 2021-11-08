import Foundation
import Telegraph
import WebKit

class SidewalkSocketMessageHandlerDefault: SidewalkSocketMessageHandler {
    
    unowned let webview: WKWebView
    
    init(webview: WKWebView) {
        self.webview = webview
    }
    
    func didReceive(message: WebSocketMessage, onSocket socket: WebSocket) {
        
    }
    
    func send(data: Data, onSocket socket: WebSocket) {
        socket.send(data: data)
    }
    
    func send(text: String, onSocket socket: WebSocket) {
        socket.send(text: text.base64)
    }
    
    func send(message: WebSocketMessage, onSocket socket: WebSocket) {
        socket.send(message: message)
    }

}
