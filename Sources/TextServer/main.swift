import Foundation
import NIO

// source: https://rderik.com/guides/

// MARK: - Set up

// 1. create EventLoopGroup
let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

// 2. bootstrap the socket (or any IO capable resource)
// ServerBootstrap will create a listening socket that
// can be `bind` later.
let bootstrap = ServerBootstrap(group: group)
  // 2.1. Set up the ServerChannel
  // `backlog` specifies the max length of the queueu of pending connections
  .serverChannelOption(ChannelOptions.backlog, value: 256)
  .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
  
  // 2.2. Set up the closure that will be used to initialize Child channels
  .childChannelInitializer { channel in
          // 2.3. Add handlers to the pipeline
          channel.pipeline.addHandlers([
                  BackPressureHandler(),
                  UpcaseHandler(),
                  VowelsHandler(),
                  ColorHandler()
          ])
  }

  // 2.4. Set up child channel options
  .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
  .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
  .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
  
// defer { try! group.syncShutdownGracefully() }

// MARK: - Start server

let host = "::1"
let port = 8888

let channel = try bootstrap.bind(host: host, port: port).wait()

print("Server started and listening on \(channel.localAddress!)")

try channel.closeFuture.wait()

print("Server closed")
