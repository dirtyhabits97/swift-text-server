import NIO

final class UpcaseHandler: ChannelInboundHandler {
    
    typealias InboundIn = ByteBuffer
    typealias InboundOut = [CChar]
    
    // MARK: - Methods
    
    func channelRead(
        context: ChannelHandlerContext,
        data: NIOAny
    ) {
        // `unwrapInboundIn` unwraps the data wrapped in NIOAny to
        // InboundIn.Type
        let inBuff = self.unwrapInboundIn(data)
        let str = inBuff.getString(at: 0, length: inBuff.readableBytes)
        
        let result = str?.uppercased() ?? ""
        
        let cresult = result.cString(using: .utf8) ?? []
        // `wrapInboundOut` wraps the data in NIOAny for
        // the next handler.
        context.fireChannelRead(self.wrapInboundOut(cresult))
    }
    
}
