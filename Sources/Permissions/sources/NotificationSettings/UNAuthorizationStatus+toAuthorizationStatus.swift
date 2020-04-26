import Foundation
import StoreKit

@available(iOS 10.0, *)
extension UNAuthorizationStatus {
    public func toAuthorizationStatus(subject: UNAuthorizationOptions) -> AuthorizationStatus<UNAuthorizationOptions> {
        switch self {
        case .authorized:
            return .authorized(subject)

        case .denied:
            return .unauthorized(.denied(subject))

        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .provisional:
            return .authorized(subject)

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
