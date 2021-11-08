import Foundation

class SidewalkIdGenerator {
    private static let queue = DispatchQueue(label: "IncrementIdQueue")
    private static var _id: Int = -1
    
    static func incrementId() -> Int {
        queue.sync {
            _id += 1
            return _id
        }
    }

}
