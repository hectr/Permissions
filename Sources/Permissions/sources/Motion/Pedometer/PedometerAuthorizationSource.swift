import Foundation
import CoreMotion

@available(iOS 11.0, *)
public struct PedometerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        type(of: provider)
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = CMPedometer()

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.queryPedometerData(from: Date(), to: Date()) { _, error in
            completion.execute(with: error)
        }
    }
}
