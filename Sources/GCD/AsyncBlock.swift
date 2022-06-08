//
// Created by 蒋晨成 on 2021/2/8.
//

import Foundation

public typealias Async = AsyncBlock<Void, Void>

public struct AsyncBlock<In, Out> {
    private let block: DispatchWorkItem

    private let input: Reference<In>?
    private let output: Reference<Out>

    public var outputValue: Out? { output.value }

    private init(_ block: DispatchWorkItem, input: Reference<In>? = nil, output: Reference<Out> = Reference()) {
        self.block = block
        self.input = input
        self.output = output
    }
}

private extension AsyncBlock {
    private func chain<O>(after seconds: Double? = nil, block chainingBlock: @escaping (Out) -> O, queue: GCD) -> AsyncBlock<Out, O> {
        let reference = Reference<O>()
        let dispatchWorkItem = DispatchWorkItem(block: {
            reference.value = chainingBlock(output.value.unsafelyUnwrapped)
        })

        let queue = queue.queue
        if let seconds = seconds {
            block.notify(queue: queue) {
                let time = DispatchTime.now() + seconds
                queue.asyncAfter(deadline: time, execute: dispatchWorkItem)
            }
        } else {
            block.notify(queue: queue, execute: dispatchWorkItem)
        }

        return AsyncBlock<Out, O>(dispatchWorkItem, input: output, output: reference)
    }

    private static func async<O>(after seconds: Double? = nil, block: @escaping () -> O, queue: GCD) -> AsyncBlock<Void, O> {
        let reference = Reference<O>()
        let block = DispatchWorkItem(block: {
            reference.value = block()
        })

        if let seconds = seconds {
            let time = DispatchTime.now() + seconds
            queue.queue.asyncAfter(deadline: time, execute: block)
        } else {
            queue.queue.async(execute: block)
        }

        return AsyncBlock<Void, O>(block, output: reference)
    }
}

public extension AsyncBlock {
    @discardableResult
    func main<O>(after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .main)
    }

    @discardableResult
    func userInteractive<O>(after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .userInteractive)
    }

    @discardableResult
    func userInitiated<O>(after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .userInitiated)
    }

    @discardableResult
    func utility<O>(after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .utility)
    }

    @discardableResult
    func background<O>(after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .background)
    }

    @discardableResult
    func queue<O>(_ queue: DispatchQueue, after seconds: Double? = nil, _ chainingBlock: @escaping (Out) -> O) -> AsyncBlock<Out, O> {
        chain(after: seconds, block: chainingBlock, queue: .queue(queue: queue))
    }

    func cancel() { block.cancel() }

    @discardableResult
    func wait(seconds: Double? = nil) -> DispatchTimeoutResult {
        let timeout = seconds
            .flatMap { DispatchTime.now() + $0 }
            ?? .distantFuture
        return block.wait(timeout: timeout)
    }
}

public extension AsyncBlock {
    @discardableResult
    static func main<O>(after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        AsyncBlock.async(after: seconds, block: block, queue: .main)
    }

    @discardableResult
    static func userInteractive<O>(after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        AsyncBlock.async(after: seconds, block: block, queue: .userInteractive)
    }

    @discardableResult
    static func userInitiated<O>(after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        Async.async(after: seconds, block: block, queue: .userInitiated)
    }

    @discardableResult
    static func utility<O>(after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        Async.async(after: seconds, block: block, queue: .utility)
    }

    @discardableResult
    static func background<O>(after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        Async.async(after: seconds, block: block, queue: .background)
    }

    @discardableResult
    static func queue<O>(_ queue: DispatchQueue, after seconds: Double? = nil, _ block: @escaping () -> O) -> AsyncBlock<Void, O> {
        Async.async(after: seconds, block: block, queue: .queue(queue: queue))
    }
}
