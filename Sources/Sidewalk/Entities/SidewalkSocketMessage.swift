import Foundation

struct SidewalkSocketMessage: Codable {
    var type: String
    // TODO: check for custom message handler - we will need the ID if we want to bidirectional communication (e.g. async-await for JS evaluation)
    //let connectedId: Int
}
