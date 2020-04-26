import Foundation
import HealthKit

extension HKAuthorizationStatus {
    public func toAuthorizationStatus(subject: HKObjectType) -> AuthorizationStatus<HKObjectType> {
        switch self {
        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .sharingDenied:
            return .unauthorized(.denied(subject))

        case .sharingAuthorized:
            return .authorized(subject)

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }

    public func toAuthorizationStatus(subject: HKSampleType) -> AuthorizationStatus<HKSampleType> {
        switch self {
        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .sharingDenied:
            return .unauthorized(.denied(subject))

        case .sharingAuthorized:
            return .authorized(subject)

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
