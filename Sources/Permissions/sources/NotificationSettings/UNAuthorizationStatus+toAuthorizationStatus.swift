import Foundation
import StoreKit

@available(iOS 10.0, *)
extension UNAuthorizationStatus {
    public func toAuthorizationStatus(subject: UNAuthorizationOptions,
                                      disabled: [UNAuthorizationOptions],
                                      enabled: [UNAuthorizationOptions],
                                      notSupported: [UNAuthorizationOptions]) -> AuthorizationStatus<UNAuthorizationOptions> {
        switch self {
        case .authorized:
            return .authorized(enabled.toOptionSet())

        case .denied:
            var reasons = [AuthorizationStatus<UNAuthorizationOptions>.Reason]()
            if !disabled.isEmpty {
                let optionSet = disabled.toOptionSet()
                reasons.append(.denied(optionSet))
            }
            if !notSupported.isEmpty {
                let optionSet = notSupported.toOptionSet()
                reasons.append(.restricted(optionSet))
            }
            if reasons.isEmpty {
                return .unauthorized(.denied(UNAuthorizationOptions()))
            } else if reasons.count == 1, let reason = reasons.first {
                return .unauthorized(reason)
            } else {
                return .unauthorized(.multiple(reasons))
            }

        case .notDetermined:
            let affectedSubjects = subject.toArray().removing(disabled).removing(enabled).removing(notSupported)
            return .unauthorized(.notDetermined(affectedSubjects.toOptionSet()))

        case .provisional:
            return .authorized(enabled.toOptionSet())

        @unknown default:
            assertionFailure("unknown case: \(self)")
            let affectedSubjects = subject.toArray().removing(disabled).removing(enabled).removing(notSupported)
            return .unauthorized(.notDetermined(affectedSubjects.toOptionSet()))
        }
    }
}
