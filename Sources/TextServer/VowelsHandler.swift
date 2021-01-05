import NIO

final class VowelsHandler: ChannelInboundHandler {
    
    typealias InboundIn = [CChar]
    typealias InboundOut = ByteBuffer
    
    // MARK: - Methods
    
    func channelRead(
        context: ChannelHandlerContext,
        data: NIOAny
    ) {
        let inBuff = self.unwrapInboundIn(data)
        let str = String(cString: inBuff)
        
        let vowels: Set<Character> = [
            "a","e","i","o","u",
            "A", "E", "I", "O", "U"
        ]
        let result = String(str.map { vowels.contains($0) ? Character("*") : $0 })
        
        var buffOut = context.channel.allocator.buffer(capacity: result.count)
        buffOut.writeString(result)
        
        context.fireChannelRead(self.wrapInboundOut(buffOut))
    }
    
    func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }
    
    func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("error: ", error)
        
        context.close(promise: nil)
    }
    
}
