import Foundation
import MediaPlayer

@available(iOS 9.3, *)
public struct MediaLibraryAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: Void

    public var status: AuthorizationStatus<Void> {
        provider
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = MPMediaLibrary.self

    public init(subject: Void = Void()) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Void>) -> Void) {
        provider.requestAuthorization { _ in
            self.getStatus(completion: completion)
        }
    }
}
