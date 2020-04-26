import Foundation

public struct AnyAuthorizationSource<Subject>: AuthorizationSource {
    private let subjectGetter: () -> Subject
    private let determine: (@escaping (AuthorizationStatus<Subject>) -> Void) -> Void
    private let request: (@escaping (AuthorizationStatus<Subject>) -> Void) -> Void
    private let status: (@escaping (AuthorizationStatus<Subject>) -> Void) -> Void

    public var subject: Subject { subjectGetter() }

    public init<A: AuthorizationSource>(_ source: A) where A.Subject == Subject {
        subjectGetter = source._subject
        determine = source.determineAuthorizationStatus
        request = source.requestAuthorization
        status = source.getStatus
    }

    public func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        determine(completion)
    }

    public func getStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        status(completion)
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        request(completion)
    }
}

extension AuthorizationSource {
    fileprivate func _subject() -> Subject {
        subject
    }
}
