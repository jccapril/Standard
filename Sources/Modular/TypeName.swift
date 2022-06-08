//
// Created by 蒋晨成 on 2020/6/10.
// Copyright (c) 2020 蒋晨成. All rights reserved.
//

public protocol TypeName {
    static var typeName: String { get }

    var typeName: String { get }
}

public extension TypeName {
    static var typeName: String { String(describing: self) }
    var typeName: String { String(describing: self) }
}
