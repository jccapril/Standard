//
// Created by 蒋晨成 on 2021/2/8.
//

import Foundation

public enum Apply {}

public extension Apply {
    static func userInteractive(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.userInteractive.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }

    static func userInitiated(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.userInitiated.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }

    static func utility(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.utility.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }

    static func background(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.background.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }

    static func custom(queue: DispatchQueue, iterations: Int, block: @escaping (Int) -> Void) {
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
}
