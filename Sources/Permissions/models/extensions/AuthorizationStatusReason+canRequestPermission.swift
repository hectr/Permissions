import Foundation

extension AuthorizationStatus.Reason {
    public var canRequestPermission: Bool {
        switch self {
        case .denied:
            return false

        case let .multiple(reasons):
            return reasons.reduce(false) { $0 || $1.canRequestPermission }

        case .notDetermined:
            return true

        case .restricted:
            return false
        }
    }
}
