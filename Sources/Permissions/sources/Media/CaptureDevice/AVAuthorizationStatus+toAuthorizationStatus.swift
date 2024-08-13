#if !os(watchOS)
import AVFoundation
import Foundation

extension AVAuthorizationStatus {
    public func toAuthorizationStatus(subject: AVMediaType) -> AuthorizationStatus<AVMediaType> {
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
#endif
