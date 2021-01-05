import NIO

final class ColorHandler: ChannelInboundHandler {
    
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer
    
    func channelRead(
        context: ChannelHandlerContext,
        data: NIOAny
    ) {
        let inBuff = self.unwrapInboundIn(data)
        let str = inBuff.getString(at: 0, length: inBuff.readableBytes) ?? ""
        
        // use escape sequences
        // https://en.wikipedia.org/wiki/ANSI_escape_code
        // "\u{1B}[32m\(str)\u{1B}[0m"
        let result = "\u{1B}[32m\(str)\u{1B}[0m"
        
        var buff = context.channel.allocator.buffer(capacity: result.count)
        buff.writeString(result)
        
        // write to the socket directly
        // This is the last Handler, so no need to use `fireChannelRead`
        context.write(self.wrapInboundOut(buff), promise: nil)
    }
    
}

