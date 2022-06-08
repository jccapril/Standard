//
// Created by 蒋晨成 on 2021/2/10.
//

import Foundation

public extension Dictionary {
    mutating func flatten<T>() where Value == T? {
        let dict = compactMapValues { $0 }
        self = dict
    }

    func flattening<T>() -> Self where Value == T? {
        let dict = compactMapValues { $0 }
        return dict
    }
}
