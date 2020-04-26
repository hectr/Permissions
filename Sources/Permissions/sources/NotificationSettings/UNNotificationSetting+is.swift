import Foundation
import UserNotifications

@available(iOS 10.0, *)
extension UNNotificationSetting {
    public var isDisabled: Bool {
        switch self {
        case .disabled:
            return true

        case .enabled:
            return false

        case .notSupported:
            return false

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return false
        }
    }

    public var isEnabled: Bool {
        switch self {
        case .disabled:
            return false

        case .enabled:
            return true

        case .notSupported:
            return false

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return false
        }
    }

    public var isNotSupported: Bool {
        switch self {
        case .disabled:
            return false

        case .enabled:
            return false

        case .notSupported:
            return true

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return false
        }
    }

}
