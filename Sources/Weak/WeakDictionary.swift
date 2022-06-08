//
// Created by 蒋晨成 on 2021/2/10.
//

public typealias WeakDictionary<Key, Value> = [Key: Weak<Value>] where Key: Hashable, Value: AnyObject

public extension WeakDictionary {
    mutating func flatten<T>() where Value == Weak<T>, T: AnyObject {
        self = compactMapValues {
            guard $0.value != nil else { return nil }
            return $0
        }
    }

    func flattening<T>() -> Self where Value == Weak<T>, T: AnyObject {
        compactMapValues {
            guard $0.value != nil else { return nil }
            return $0
        }
    }
}
