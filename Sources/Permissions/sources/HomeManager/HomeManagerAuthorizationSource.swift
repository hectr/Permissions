#if canImport(HomeKit)
import Foundation

public struct HomeManagerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public var subject: Void {
        provider.subject
    }

    public var status: AuthorizationStatus<Void> {
        provider.status
    }

    private let provider: HomeManagerAuthorizationProvider

    public init(subject: Void = Void()) {
        provider = HomeManagerAuthorizationProvider(subject: subject)
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization { error in
            completion.execute(with: error)
        }
    }
}
#endif
