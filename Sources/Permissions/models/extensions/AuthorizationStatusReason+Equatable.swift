import Foundation

extension AuthorizationStatus.Reason: Equatable where Subject: Equatable {
    public static func == (lhs: AuthorizationStatus<Subject>.Reason, rhs: AuthorizationStatus<Subject>.Reason) -> Bool {
        lhs.values == rhs.values
    }

    private var values: (String, [Self]?, Subject?) {
        switch self {
        case let .denied(subject):
            return ("denied", nil, subject)

        case let .multiple(reasons):
            return ("multiple", reasons, nil)

        case let .notDetermined(subject):
            return ("notDetermined", nil, subject)

        case let .restricted(subject):
            return ("restricted", nil, subject)

        }
    }
}
