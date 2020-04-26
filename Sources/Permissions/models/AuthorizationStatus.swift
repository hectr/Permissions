import Foundation

public enum AuthorizationStatus<Subject> {
    public enum Reason: Swift.Error {
        case denied(Subject)
        case multiple([Reason])
        case notDetermined(Subject)
        case restricted(Subject)
    }

    case authorized(Subject)
    case unauthorized(Reason)
}
