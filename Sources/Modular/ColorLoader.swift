//
// Created by 蒋晨成 on 2021/4/21.
//

import Foundation
import UIKit

public protocol ColorLoader: AnyObject {
    static var bundle: Bundle { get }
    static func color(name: String) -> UIColor
}

public extension ColorLoader {
    @available(iOS 11.0, *)
    static func color(name: String) -> UIColor {
        guard let color = UIColor(named: name, in: bundle, compatibleWith: nil) else {
            fatalError("\(name) color not found in \(bundle)")
        }
        return color
    }
}
