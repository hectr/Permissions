import Foundation
import UserNotifications

public struct NotificationSettingsAuthorizationSource: AuthorizationSource {
    private typealias GetAuthorizedOptionsCompletion = (
        _ status: UNAuthorizationStatus,
        _ disabled: [UNAuthorizationOptions],
        _ enabled: [UNAuthorizationOptions],
        _ notSupported: [UNAuthorizationOptions]
    ) -> Void
    
    public let subject: UNAuthorizationOptions

    private let provider = UNUserNotificationCenter.current()

    public init(subject: UNAuthorizationOptions) {
        assert(subject.toArray().toOptionSet() == subject, "unsupported option: \(subject)")
        self.subject = subject
    }

    public func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<UNAuthorizationOptions>) -> Void) {
        getStatus { status in
            switch status {
            case .authorized:
                completion(status)

            case let .unauthorized(reason):
                if reason.canRequestPermission {
                    self.requestAuthorization(timeout: nil) { error in
                        self.getStatus(completion: completion)
                    }
                } else {
                    completion(status)
                }
            }
        }
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization(options: subject) { _, error in
            completion.execute(with: error)
        }
    }

    public func getStatus(completion: @escaping (AuthorizationStatus<UNAuthorizationOptions>) -> Void) {
        getAuthorizedOptions { status, disabled, enabled, notSupported in
            self.operationQueue.addOperation {
                let authorizationStatus = status.toAuthorizationStatus(subject: self.subject,
                                                                       disabled: disabled,
                                                                       enabled: enabled,
                                                                       notSupported: notSupported)
                completion(authorizationStatus)
            }
        }
    }

    private func getAuthorizedOptions(completion: @escaping GetAuthorizedOptionsCompletion) {
        provider.getNotificationSettings { settings in
            let subjectSettings = settings.settings(for: self.subject)
            let disabled = subjectSettings
                .filter { $0.1.isDisabled }
                .map { $0.0 }
            let enabled = subjectSettings
                .filter { $0.1.isEnabled }
                .map { $0.0 }
            let notSupported = subjectSettings
                .filter { $0.1.isNotSupported }
                .map { $0.0 }
            completion(settings.authorizationStatus, disabled, enabled, notSupported)
        }
    }
}
