//
// Created by 蒋晨成 on 2021/2/9.
//

import Foundation

public protocol Localizable: AnyObject, TypeName {
    static var tableName: String { get }
    static var bundle: Bundle { get }

    static func localizedString(key: String, tableName: String, comment: String) -> String
}

public extension Localizable {
    static var tableName: String { typeName }

    static func localizedString(key: String, tableName: String = tableName, comment: String = "") -> String {
        NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: comment)
    }
}
