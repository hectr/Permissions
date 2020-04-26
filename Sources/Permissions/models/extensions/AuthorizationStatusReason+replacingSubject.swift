import Foundation

extension AuthorizationStatus.Reason {
    public func replacingSubject<S>(with newSubject: S) -> AuthorizationStatus<S>.Reason {
        switch self {
        case .denied:
            return .denied(newSubject)
            
        case let .multiple(reasons):
            return .multiple(reasons.map { $0.replacingSubject(with: newSubject) })
            
        case .notDetermined:
            return .notDetermined(newSubject)
            
        case .restricted:
            return .restricted(newSubject)
        }
    }
}
