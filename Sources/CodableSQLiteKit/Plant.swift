import Foundation
import NIO

struct Plant: Codable {
    let name: String
    let color: String?
}

extension Plant: TableIO {
 static var tablename: String { "Plants" }
}
