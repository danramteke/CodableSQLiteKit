import SQLiteKit
import Foundation

protocol TableIO: Codable {
  static var tablename: String { get }
  static func readAllRows(from: SQLiteConnection) -> EventLoopFuture<[Self]>
  static func writeAll(rows: [Self], to connection: SQLiteConnection, on eventLoop: EventLoop) -> EventLoopFuture<Void>
}

extension TableIO {
  static func readAllRows(from connection: SQLiteConnection) -> EventLoopFuture<[Self]> {
    connection.sql()
      .select()
      .from(Self.tablename)
      .all(decoding: Self.self)
  }

  static func writeAll(rows: [Self], to connection: SQLiteConnection, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
    do {
      return try connection
        .sql()
        .insert(into: Self.tablename)
        .models(rows)
        .run()
    } catch {
      let wrappedError = TableIOError(tableName: Self.tablename, underlying: error)
      return eventLoop.makeFailedFuture(wrappedError)
    }
  }
}

public struct TableIOError: Error, LocalizedError {
  let tableName: String
  let underlying: Error

  public var errorDescription: String? {
    "Error saving table: \(underlying.localizedDescription)"
  }
}
