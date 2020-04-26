import Foundation

extension AuthorizationStatus {
    public func replacingSubject<S>(with newSubject: S) -> AuthorizationStatus<S> {
        switch self {
        case .authorized:
            return .authorized(newSubject)

        case let .unauthorized(reason):
            return .unauthorized(reason.replacingSubject(with: newSubject))
        }
    }
}
