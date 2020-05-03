import Foundation

public struct AnyAuthorizationStatusSource<Subject>: AuthorizationStatusSource {
    private let statusGetter: () -> AuthorizationStatus<Subject>
    private let subjectGetter: () -> Subject

    public var status: AuthorizationStatus<Subject> { statusGetter() }
    public var subject: Subject { subjectGetter() }

    public init<A: AuthorizationStatusSource>(_ source: A) where A.Subject == Subject {
        statusGetter = source._status
        subjectGetter = source._subject
    }
}

extension AuthorizationStatusSource {
    fileprivate func _status() -> AuthorizationStatus<Subject> {
        status
    }

    fileprivate func _subject() -> Subject {
        subject
    }
}
