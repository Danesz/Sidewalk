import Foundation
import Telegraph

public protocol SidewalkSocketMessageHandler: AnyObject {
    //TODO: hide WebSocket behind the wrapper to avood brekaing the connection?
    func didReceive(message: WebSocketMessage, onSocket socket: WebSocket)
    func send(data: Data, onSocket socket: WebSocket, completionHandler: ((Any?, Error?) -> Void)?)
    func send(text: String, onSocket socket: WebSocket, completionHandler: ((Any?, Error?) -> Void)?)
}
