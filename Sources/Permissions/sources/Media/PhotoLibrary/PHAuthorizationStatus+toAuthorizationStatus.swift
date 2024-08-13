#if canImport(UIKit) && canImport(Photos) && !os(tvOS)
import Foundation
import Photos
import UIKit

extension PHAuthorizationStatus {
    public func toAuthorizationStatus(subject: UIImagePickerController.SourceType) -> AuthorizationStatus<UIImagePickerController.SourceType> {
        switch self {
        case .authorized:
            return .authorized(subject)

        case .denied:
            return .unauthorized(.denied(subject))

        case .notDetermined:
            return .unauthorized(.notDetermined(subject))

        case .restricted:
            return .unauthorized(.restricted(subject))

        case .limited:
            return .authorized(subject)

        @unknown default:
            assertionFailure("unknown case: \(self)")
            return .unauthorized(.notDetermined(subject))
        }
    }
}
#endif
