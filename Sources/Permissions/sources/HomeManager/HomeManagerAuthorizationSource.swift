import Foundation

@available(iOS 13.0, *)
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

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        provider.requestAuthorization(completion: completion)
    }
}
