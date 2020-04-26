import Foundation
import Photos
import UIKit

public struct PhotoLibraryAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: UIImagePickerController.SourceType

    public var status: AuthorizationStatus<UIImagePickerController.SourceType> {
        provider
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = PHPhotoLibrary.self

    public init(subject: UIImagePickerController.SourceType) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<UIImagePickerController.SourceType>) -> Void) {
        provider.requestAuthorization { _ in
            self.getStatus(completion: completion)
        }
    }
}
