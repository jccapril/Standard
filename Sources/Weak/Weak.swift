//
// Created by 蒋晨成 on 2021/2/10.
//

public struct Weak<Value: AnyObject> {
    public weak var value: Value?

    public init(_ value: Value) {
        self.value = value
    }
}

extension Weak: Equatable {
    public static func == (lhs: Weak, rhs: Weak) -> Bool {
        lhs.value === rhs.value
    }

    public static func == (lhs: Weak, rhs: Value) -> Bool {
        lhs.value === rhs
    }
}

extension Weak: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
