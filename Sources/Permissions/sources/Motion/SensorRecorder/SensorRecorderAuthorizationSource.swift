#if canImport(CoreMotion) && !os(macOS)
import Foundation
import CoreMotion

public struct SensorRecorderAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        type(of: provider)
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = CMSensorRecorder()

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        _ = provider.accelerometerData(from: Date(), to: Date())
        completion.execute(with: nil)
    }
}
#endif
