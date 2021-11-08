import Foundation

struct SidewalkSocketConnectionMessage: Codable {
    let type: String = "connected"
    let connectedId: Int
}
