import Foundation
import CoreMotion

@available(iOS 11.0, *)
public struct MotionActivityManagerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        type(of: provider)
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = CMMotionActivityManager()

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        provider.queryActivityStarting(from: Date(), to: Date(), to: operationQueue) { _, _ in
            self.getStatus(completion: completion)
        }
    }
}
