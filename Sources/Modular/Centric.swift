//
// Created by 蒋晨成 on 2021/4/14.
//

import Foundation

public protocol Centric: TypeName {
    static var queue: DispatchQueue { get }
}

public extension Centric {
    static var mainQueue: DispatchQueue { DispatchQueue.main }
}
