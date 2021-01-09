import Foundation
import NIO
struct MultiThreadedContext {
  let numberOfThreads: Int
  init(numberOfThreads: Int) {
    self.numberOfThreads = numberOfThreads
  }

  func run(block: (EventLoopGroup, NIOThreadPool) -> (EventLoopFuture<Void>)) throws {
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: self.numberOfThreads)
    let threadPool = NIOThreadPool(numberOfThreads: self.numberOfThreads)
    threadPool.start()

    let shutdownCallback: (Error?) -> Void = { error in
      if let error = error {
        print(error)
      } else {
        print("finished without error")
      }
    }

    defer {
      threadPool.shutdownGracefully(shutdownCallback)
      eventLoopGroup.shutdownGracefully((shutdownCallback))
    }

    let signal = block(eventLoopGroup, threadPool)
    try signal.wait()
  }

}
