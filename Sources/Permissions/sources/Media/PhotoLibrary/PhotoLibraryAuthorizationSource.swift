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

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization { _ in
            completion.execute(with: nil)
        }
    }
}
