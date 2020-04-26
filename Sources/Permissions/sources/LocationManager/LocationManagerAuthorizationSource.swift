import Foundation

public struct LocationManagerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public enum When {
        case always
        case inUse
    }

    public var subject: When {
        provider.subject
    }

    public var status: AuthorizationStatus<When> {
        provider.status
    }

    private let provider: LocationAuthorizationProvider

    public init(subject: When) {
        provider = LocationAuthorizationProvider(subject: subject)
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<When>) -> Void) {
        provider.requestAuthorization(completion: completion)
    }
}
