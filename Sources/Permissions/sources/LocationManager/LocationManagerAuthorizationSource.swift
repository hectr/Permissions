import Foundation

public struct LocationManagerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public enum When: Equatable, CaseIterable {
        case always
        case inUse
    }

    public var subject: When {
        provider.subject
    }

    public var status: AuthorizationStatus<When> {
        provider.status
    }

    public var determineAlwaysPromptTimeout: TimeInterval = 40

    private let provider: LocationAuthorizationProvider

    public init(subject: When) {
        provider = LocationAuthorizationProvider(subject: subject)
    }

    public func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        switch self.subject {
        case .always:
            determineAlwaysAuthorizationStatus(timeout: determineAlwaysPromptTimeout,
                                               completion: completion)

        case .inUse:
            determineInUseAuthorizationStatus(completion: completion)
        }
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization { error in
            completion.execute(with: error)
        }
    }

    private func determineAlwaysAuthorizationStatus(timeout: TimeInterval, completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
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

    private func determineInUseAuthorizationStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        getStatus { status in
            switch status {
            case .authorized:
                completion(status)

            case let .unauthorized(reason):
                self.handleUnauthorized(reason: reason, completion: completion)
            }
        }
    }

    private func handleUnauthorized(reason: AuthorizationStatus<When>.Reason, completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        if reason.canRequestPermission {
            self.requestAuthorization(timeout: nil) { _ in
                self.getStatus(completion: completion)
            }
        } else {
            completion(status)
        }
    }
}
