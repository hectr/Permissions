#if canImport(Speech)
import Foundation
import Speech

extension SFSpeechRecognizerAuthorizationStatus {
    public func toAuthorizationStatus(subject: Void = Void()) -> AuthorizationStatus<Void> {
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
