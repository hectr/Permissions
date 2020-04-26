import AVFoundation
import Foundation

public struct CaptureDeviceAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: AVMediaType

    public var status: AuthorizationStatus<AVMediaType> {
        provider
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = AVCaptureDevice.self

    public init(subject: AVMediaType) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<AVMediaType>) -> Void) {
        provider.requestAccess(for: subject) { _ in
            self.getStatus(completion: completion)
        }
    }
}
