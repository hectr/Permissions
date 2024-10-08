#if canImport(HomeKit)
import Foundation
import HomeKit

extension HMHomeManagerAuthorizationStatus {
    public func toAuthorizationStatus(subject: Void = Void()) -> AuthorizationStatus<Void> {
        if contains(.restricted) {
            return .unauthorized(.restricted(subject))
        } else if contains(.authorized) {
            return .authorized(subject)
        } else if contains(.determined) {
            return .unauthorized(.denied(subject))
        } else {
            assert(self == HMHomeManagerAuthorizationStatus(), "unknown option: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
#endif
