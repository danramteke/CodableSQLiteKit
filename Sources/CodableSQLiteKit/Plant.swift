import Foundation
import NIO

struct Plant: Codable {
    let name: String
    let color: String?
}

extension Plant {
    static var tablename: String { "Plants" }
}
