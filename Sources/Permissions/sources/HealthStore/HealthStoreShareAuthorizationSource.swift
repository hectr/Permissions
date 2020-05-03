import Foundation
import HealthKit

public struct HealthStoreShareAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: HKSampleType

    public var status: AuthorizationStatus<HKSampleType> {
        provider
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = HKHealthStore()

    public init(subject: HKSampleType) {
        self.subject = subject
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization(toShare: Set(arrayLiteral: subject), read: nil) { _, error in
            completion.execute(with: error)
        }
    }
}
