import CoreLocation
import Foundation

extension CLAuthorizationStatus {
    public func toAuthorizationStatus(subject: LocationManagerAuthorizationSource.When, accuracy: CLAccuracyAuthorization) -> AuthorizationStatus<LocationManagerAuthorizationSource.When> {
        switch self {
        case .notDetermined:
            return .unauthorized(.notDetermined(subject))
            
        case .restricted:
            return .unauthorized(.restricted(subject))
            
        case .denied:
            return .unauthorized(.denied(subject))
            
        case .authorizedAlways:
            guard let purposeKey = subject.fullAccuracyPurposeKey else {
                return .authorized(.inUse)
            }
            switch accuracy {
            case .fullAccuracy:
                return .authorized(.temporaryFull(purposeKey))
            case .reducedAccuracy:
#if os(tvOS)
                assertionFailure("tvOS cannot request always")
                return .authorized(.inUse)
#else
                return .authorized(.always)
#endif
            @unknown default:
                assertionFailure("unknown case: \(self)")
                return .authorized(.inUse)
            }
            
        case .authorizedWhenInUse:
            guard let purposeKey = subject.fullAccuracyPurposeKey else {
                return .authorized(.inUse)
            }
            switch accuracy {
            case .fullAccuracy:
                return .authorized(.temporaryFull(purposeKey))
            case .reducedAccuracy:
                return .authorized(.inUse)
            @unknown default:
                assertionFailure("unknown case: \(self)")
                return .authorized(.inUse)
            }
            
        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}

extension LocationManagerAuthorizationSource.When {
    var fullAccuracyPurposeKey: String? {
        switch self {
#if !os(tvOS)
        case .always:
            return nil
#endif
        case .inUse:
            return nil
        case .temporaryFull(let purposeKey): 
            return purposeKey
        }
    }
}
