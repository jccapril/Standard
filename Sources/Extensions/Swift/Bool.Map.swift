//
// Created by 蒋晨成 on 2021/3/22.
//

public extension Bool {
    func map<T>(true: T, false: T) -> T {
        switch self {
        case true:
            return `true`
        case false:
            return `false`
        }
    }
}
