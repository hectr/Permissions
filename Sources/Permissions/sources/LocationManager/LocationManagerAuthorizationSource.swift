import Foundation

public struct LocationManagerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public enum When: Equatable {
#if !os(tvOS)
        case always
#endif
        case inUse
        case temporaryFull(String)
    }

    public static var defaultFullAccuracyPurposeKey = "default"

    public var subject: When {
        provider.subject
    }

    public var status: AuthorizationStatus<When> {
        provider.status
    }

    public var determineAlwaysPromptTimeout: TimeInterval = 40

    private let provider: LocationAuthorizationProvider

    public init(subject: When, fullAccuracyPurposeKey: String?) {
        provider = LocationAuthorizationProvider(subject: subject)
    }

    public func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<When>) -> Void) {
        switch self.subject {
#if !os(tvOS)
        case .always:
            determineAlwaysAuthorizationStatus(timeout: determineAlwaysPromptTimeout,
                                               completion: completion)
#endif
        case .inUse:
            determineInUseAuthorizationStatus(completion: completion)

        case .temporaryFull:
            determineTemporaryFullAuthorizationStatus(completion: completion)
        }
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization { error in
            completion.execute(with: error)
        }
    }

    private func determineAlwaysAuthorizationStatus(timeout: TimeInterval, completion: @escaping (AuthorizationStatus<When>) -> Void) {
        determineInUseAuthorizationStatus { status in
            switch status {
            case let .authorized(subject):
                if subject == self.subject {
                    completion(status)
                } else {
                    self.requestAuthorization(timeout: timeout) { _ in
                        self.getStatus(completion: completion)
                    }
                }

            case let .unauthorized(reason):
                self.handleUnauthorized(reason: reason, completion: completion)
            }
        }
    }

    private func determineInUseAuthorizationStatus(completion: @escaping (AuthorizationStatus<When>) -> Void) {
        getStatus { status in
            switch status {
            case .authorized:
                completion(status)

            case let .unauthorized(reason):
                self.handleUnauthorized(reason: reason, completion: completion)
            }
        }
    }

    private func determineTemporaryFullAuthorizationStatus(completion: @escaping (AuthorizationStatus<When>) -> Void) {
        getStatus { status in
            switch status {
            case .authorized:
                completion(status)

            case let .unauthorized(reason):
                self.handleUnauthorized(reason: reason, completion: completion)
            }
        }
    }

    private func handleUnauthorized(reason: AuthorizationStatus<When>.Reason, completion: @escaping (AuthorizationStatus<When>) -> Void) {
        if reason.canRequestPermission {
            self.requestAuthorization(timeout: nil) { _ in
                self.getStatus(completion: completion)
            }
        } else {
            completion(status)
        }
    }
}
