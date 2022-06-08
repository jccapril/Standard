//
// Created by 蒋晨成 on 2021/2/8.
//

import Foundation

public struct AsyncGroup {
    private let group = DispatchGroup()

    public init() {}
}

private extension AsyncGroup {
    private func async(block: @escaping @convention(block) () -> Swift.Void, queue: GCD) {
        queue.queue.async(group: group, execute: block)
    }
}

public extension AsyncGroup {
    func enter() { group.enter() }

    func leave() { group.leave() }
}

public extension AsyncGroup {
    func main(_ block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .main)
    }

    func userInteractive(_ block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .userInteractive)
    }

    func userInitiated(_ block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .userInitiated)
    }

    func utility(_ block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .utility)
    }

    func background(_ block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .background)
    }

    func custom(queue: DispatchQueue, block: @escaping @convention(block) () -> Swift.Void) {
        async(block: block, queue: .queue(queue: queue))
    }

    @discardableResult
    func wait(seconds: Double? = nil) -> DispatchTimeoutResult {
        let timeout = seconds
            .flatMap { DispatchTime.now() + $0 }
            ?? .distantFuture
        return group.wait(timeout: timeout)
    }
}
