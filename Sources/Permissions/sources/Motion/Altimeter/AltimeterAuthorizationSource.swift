import Foundation
import CoreMotion

@available(iOS 11.0, *)
public struct AltimeterAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        type(of: provider)
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = CMAltimeter()

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        provider.startRelativeAltitudeUpdates(to: operationQueue) { _, _ in
            self.provider.stopRelativeAltitudeUpdates()
            self.getStatus(completion: completion)
        }
    }
}
