import Foundation
import Speech

@available(iOS 10.0, *)
public struct SpeechRecognizerAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        provider
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = SFSpeechRecognizer.self

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        provider.requestAuthorization { _ in
            self.getStatus(completion: completion)
        }
    }
}
