import SQLiteKit
import Foundation

let plants: [Plant] = [
  Plant(name: "red bean", color: "red"),
  Plant(name: "green bean", color: "green"),
  Plant(name: "black bean", color: "black"),
  Plant(name: "mushroom", color: nil)
]

let label: String = "CodableSQLiteKit"
let dbPath = "/tmp/\(label).sqlite"

let sqliteConfiguration = SQLiteConfiguration(storage: .file(path: dbPath))
let schema = #"CREATE TABLE "Plants" ("name" TEXT NOT NULL, "color" TEXT);"#

try? FileManager.default.removeItem(atPath: dbPath) // clear existing DB if exists


let context = MultiThreadedContext(numberOfThreads: 1)

try context.run { (eventLoopGroup, threadPool) in
  let eventLoop = eventLoopGroup.next()
  return SQLiteConnectionSource(configuration: sqliteConfiguration, threadPool: threadPool)
    .makeConnection(logger: Logger(label: label), on: eventLoop)
    .flatMap { (connection) -> EventLoopFuture<Void> in

      return connection.sql().execute(sql: SQLRaw(schema)) { _ in }
        .flatMapThrowing { _ in
          try connection.sql()
            .insert(into: Plant.tablename)
            .models(plants)
            .run()
        }
        .flatMap { _ in
          connection.close()
        }
    }
}

print("Hello, world!")
