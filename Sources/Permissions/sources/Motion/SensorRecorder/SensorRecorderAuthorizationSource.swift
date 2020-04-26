import Foundation
import CoreMotion

@available(iOS 11.0, *)
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

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        _ = provider.accelerometerData(from: Date(), to: Date())
        getStatus(completion: completion)
    }
}
