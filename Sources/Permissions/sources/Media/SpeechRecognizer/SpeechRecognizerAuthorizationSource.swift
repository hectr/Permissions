#if canImport(Speech)
import Foundation
import Speech

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

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAuthorization { _ in
            completion.execute(with: nil)
        }
    }
}
#endif
