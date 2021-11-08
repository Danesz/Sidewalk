import Foundation

struct SidewalkSocketEvalMessage: Codable {
    let type: String = "eval"
    var evalutation: String
}
