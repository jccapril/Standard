//
// Created by 蒋晨成 on 2021/4/20.
//

import Foundation

public extension String {
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index ..< count]
        }
        guard length > 0 else { return "" }
        return self[safe: index ..< index.advanced(by: length)]
    }

    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }
}
