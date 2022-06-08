//
// Created by 蒋晨成 on 2021/2/8.
//

import Darwin
import Foundation

private enum QoSClassDescription: String {
    case main = "Main"
    case userInteractive = "User Interactive"
    case userInitiated = "User Initiated"
    case `default` = "Default"
    case utility = "Utility"
    case background = "Background"
    case unspecified = "Unspecified"
    case unknown = "Unknown"
}

public extension qos_class_t {
    var description: String {
        let result: QoSClassDescription
        switch self {
        case qos_class_main(): result = .main
        case DispatchQoS.QoSClass.userInteractive.rawValue: result = .userInteractive
        case DispatchQoS.QoSClass.userInitiated.rawValue: result = .userInitiated
        case DispatchQoS.QoSClass.default.rawValue: result = .default
        case DispatchQoS.QoSClass.utility.rawValue: result = .utility
        case DispatchQoS.QoSClass.background.rawValue: result = .background
        case DispatchQoS.QoSClass.unspecified.rawValue: result = .unspecified
        default: result = .unknown
        }
        return result.rawValue
    }
}

public extension DispatchQoS.QoSClass {
    var description: String {
        let result: QoSClassDescription
        switch self {
        case DispatchQoS.QoSClass(rawValue: qos_class_main()): result = .main
        case .userInteractive: result = .userInteractive
        case .userInitiated: result = .userInitiated
        case .default: result = .default
        case .utility: result = .utility
        case .background: result = .background
        case .unspecified: result = .unspecified
        @unknown default: result = .unknown
        }
        return result.rawValue
    }
}
