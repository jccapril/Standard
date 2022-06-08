//
// Created by 蒋晨成 on 2021/2/20.
//

import Foundation

public class SwiftCountDownTimer {
    private let internalTimer: DispatchTimer

    private var leftTimes: Int

    private let originalTimes: Int

    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void

    public init(interval: DispatchTimeInterval, times: Int, queue: DispatchQueue = .main, handler: @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void) {
        leftTimes = times
        originalTimes = times
        self.handler = handler
        internalTimer = DispatchTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        internalTimer.rescheduleHandler { [weak self] _ in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes -= 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }

    public func start() {
        internalTimer.start()
    }

    public func suspend() {
        internalTimer.suspend()
    }

    public func reCountDown() {
        leftTimes = originalTimes
    }
}
