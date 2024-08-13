#if canImport(HealthKit)
import Foundation
import HealthKit

public struct HealthStoreReadAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: HKObjectType

    public var status: AuthorizationStatus<HKObjectType> {
        provider
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = HKHealthStore()

    public init(subject: HKObjectType) {
        self.subject = subject
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization(toShare: nil, read: Set(arrayLiteral: subject)) { _, error in
            completion.execute(with: error)
        }
    }
}
#endif
