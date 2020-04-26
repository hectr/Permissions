import Contacts
import Foundation

@available(iOS 9.0, *)
extension CNAuthorizationStatus {
    public func toAuthorizationStatus(subject: CNEntityType) -> AuthorizationStatus<CNEntityType> {
        switch self {
        case .authorized:
            return .authorized(subject)

        case .denied:
            return .unauthorized(.denied(subject))

        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .restricted:
            return .unauthorized(.restricted(subject))

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
