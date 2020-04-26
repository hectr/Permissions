import Foundation

extension AuthorizationStatus: Equatable where Subject: Equatable {
    public static func == (lhs: AuthorizationStatus<Subject>, rhs: AuthorizationStatus<Subject>) -> Bool {
        lhs.values == rhs.values
    }

    private var values: (String, Reason?, Subject?) {
        switch self {
        case let .authorized(subject):
            return ("authorized", nil, subject)

        case let .unauthorized(reason):
            return ("unauthorized", reason, nil)
        }
    }
}
