//
// Created by 蒋晨成 on 2019/9/10.
// Copyright (c) 2019 蒋晨成. All rights reserved.
//

import Dispatch
import Foundation

public class DispatchTimer {
    private let internalTimer: DispatchSourceTimer

    public private(set) var isRunning = false

    public let repeats: Bool

    public typealias SwiftTimerHandler = (DispatchTimer) -> Void

    private var handler: SwiftTimerHandler

    public init(interval: DispatchTimeInterval, repeats: Bool = false, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }

        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }

    public static func repeaticTimer(interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) -> DispatchTimer {
        DispatchTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }

    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }

    // You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing,
    // even if its scheduled fire date has not arrived.
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }

    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }

    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }

    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }

    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
    }
}

// MARK: Throttle

public extension DispatchTimer {
    private static var workItems = [String: DispatchWorkItem]()

    /// The Handler will be called after interval you specified
    /// Calling again in the interval cancels the previous call
    static func debounce(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main, handler: @escaping () -> Void) {
        // if already exist
        if let item = workItems[identifier] {
            item.cancel()
        }

        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }

    /// The Handler will be called after interval you specified
    /// It is invalid to call again in the interval
    static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main, handler: @escaping () -> Void) {
        // if already exist
        if workItems[identifier] != nil {
            return
        }

        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }

    static func cancelThrottlingTimer(identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
}
