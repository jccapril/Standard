//
// Created by 蒋晨成 on 2021/2/8.
//

import Foundation

enum GCD {
    case main, userInteractive, userInitiated, utility, background, queue(queue: DispatchQueue)

    var queue: DispatchQueue {
        switch self {
        case .main: return .main
        case .userInteractive: return .global(qos: .userInteractive)
        case .userInitiated: return .global(qos: .userInitiated)
        case .utility: return .global(qos: .utility)
        case .background: return .global(qos: .background)
        case .queue(let queue): return queue
        }
    }
}
