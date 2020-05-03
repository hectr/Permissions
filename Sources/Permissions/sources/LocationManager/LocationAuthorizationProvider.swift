import CoreLocation
import Foundation

class LocationAuthorizationProvider: NSObject, CLLocationManagerDelegate {
    typealias Handler = (Swift.Error?) -> Void

    private typealias ShouldRequestAuthorization = Bool

    let subject: LocationManagerAuthorizationSource.When

    var status: AuthorizationStatus<LocationManagerAuthorizationSource.When> {
        type(of: manager)
            .authorizationStatus()
            .toAuthorizationStatus(subject: subject)
    }

    private let manager = CLLocationManager()
    private let lock = NSRecursiveLock()

    private var handlers = [Handler]()

    init(subject: LocationManagerAuthorizationSource.When) {
        self.subject = subject
        super.init()
        manager.delegate = self
    }

    deinit {
        assert(handlers.isEmpty, "\(self) is being deinitialized while there are still \(handlers.count) handlers waiting to be notified")
        notifyHandlers()
    }

    func requestAuthorization(completion: @escaping Handler) {
        let shouldRequestAuthorization = appendHandler(completion)
        if shouldRequestAuthorization {
            requestAuthorization()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        notifyHandlers()
    }

    // MARK: - Private

    private func appendHandler(_ handler: @escaping Handler) -> ShouldRequestAuthorization {
        lock.lock()
        let isFirstHandler = handlers.isEmpty
        handlers.append(handler)
        lock.unlock()
        return isFirstHandler
    }

    private func notifyHandlers() {
        let handlers = resetHandlers()
        for handler in handlers {
            handler(nil)
        }
    }

    private func resetHandlers() -> [Handler] {
        lock.lock()
        let handlers = self.handlers
        self.handlers = []
        lock.unlock()
        return handlers
    }

    private func requestAuthorization() {
        switch subject {
        case .always:
            manager.requestAlwaysAuthorization()

        case .inUse:
            manager.requestWhenInUseAuthorization()
        }
    }
}
