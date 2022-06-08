//
// Created by 蒋晨成 on 2021/6/8.
//

#if canImport(Foundation)
    import Foundation

    public extension Data {
        var hexString: String {
            let hexString = map { String(format: "%02.2hhx", $0) }.joined()
            return hexString
        }
    }

#endif
