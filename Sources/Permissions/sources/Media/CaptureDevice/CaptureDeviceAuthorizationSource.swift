#if !os(watchOS)
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

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAccess(for: subject) { _ in
            completion.execute(with: nil)
        }
    }
}
#endif
