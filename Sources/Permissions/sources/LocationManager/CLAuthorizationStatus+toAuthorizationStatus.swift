import CoreLocation
import Foundation

extension CLAuthorizationStatus {
    public func toAuthorizationStatus(subject: LocationManagerAuthorizationSource.When) -> AuthorizationStatus<LocationManagerAuthorizationSource.When> {
        switch self {
        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .restricted:
            return .unauthorized(.restricted(subject))

        case .denied:
            return .unauthorized(.denied(subject))

        case .authorizedAlways:
            return .authorized(.always)

        case .authorizedWhenInUse:
            return .authorized(.inUse)

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
