import Foundation
import Telegraph
import WebKit

class SidewalkSocketServer: ServerWebSocketDelegate, ServerDelegate {
    
    // MARK: - Properties

    private static var sharedInstance: SidewalkSocketServer = {
        let instance = SidewalkSocketServer()
        return instance
    }()

    // MARK: -

    private let server: Server

    // Initialization

    private init() {
        server = Server()
        server.webSocketDelegate = self
        server.delegate = self
        
        //enable CORS for non-localhost pages, if needed
        //server.httpConfig.requestHandlers.append(SidewalkCorsHandler())
        
        do {
            //TODO: support HTTPS/WSS
            try server.start(port: 0, interface: "localhost")
        } catch let error {
            print("[!!! SIDEWALK ERROR]: ", error)
        }
        
    }

    // MARK: - Accessors

    public class func shared() -> SidewalkSocketServer {
        return sharedInstance
    }
    
    func port() -> Int {
        return server.port
    }
    
    // MARK: - Interfaces
    
    func serverDidStop(_ server: Server, error: Error?) {
        print("[!!! SIDEWALK serverDidStop]: ", error)
    }
    
    
    func server(_ server: Server, webSocketDidConnect webSocket: WebSocket, handshake: HTTPRequest) {
        // A web socket connected, you can extract additional information from the handshake request
        print("[SIDEWALK webSocketDidConnect]: ", webSocket.remoteEndpoint?.host, webSocket.remoteEndpoint?.port)
        webSocket.send(text: "{\"msg\": \"Welcome!\"}")
    }

    func server(_ server: Server, webSocketDidDisconnect webSocket: WebSocket, error: Error?) {
      // One of our web sockets disconnected
        //TODO: reconnect if needed!
        print("[SIDEWALK webSocketDidDisconnect]: ", webSocket, error);

    }

    func server(_ server: Server, webSocket: WebSocket, didReceiveMessage message: WebSocketMessage) {
        // One of our web sockets sent us a message
        print("[SIDEWALK didReceiveMessage]: ", message);
        if let payload = message.payload.data {
            let message = try! JSONDecoder().decode(SidewalkSocketMessage.self, from: payload)
            print("SIDEWALK didReceiveMessage type:", message.type)
            if (message.type == "connected") {
                let connectedMessage = try! JSONDecoder().decode(SidewalkSocketConnectionMessage.self, from: payload)
                
                if let webview = WKWebView.findWebviewById(id: connectedMessage.connectedId) {
                    webview.sidewalkWebsocket = webSocket
                } else {
                    print("[!!! SIDEWALK WEBVIEW IS MISSING FOR ID]: ", connectedMessage.connectedId);
                }
            }
            
            //TODO: call custom message handler on the webview ---> ID required in the message
        }
    }

    func server(_ server: Server, webSocket: WebSocket, didSendMessage message: WebSocketMessage) {
        // We sent one of our web sockets a message (often you won't need to implement this one)
        print("[SIDEWALK didSendMessage]: ", message);

    }
}
