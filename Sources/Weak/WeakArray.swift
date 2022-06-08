//
// Created by 蒋晨成 on 2021/2/10.
//

public typealias WeakArray<Element> = [Weak<Element>] where Element: AnyObject

public extension RangeReplaceableCollection where Index == Int {
    mutating func flatten<T>() where Element == Weak<T>, T: AnyObject {
        for (index, element) in enumerated() where element.value == nil {
            remove(at: index)
        }
    }
}
