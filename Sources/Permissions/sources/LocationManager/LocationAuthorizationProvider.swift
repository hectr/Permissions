import CoreLocation
import Foundation

class LocationAuthorizationProvider: NSObject, CLLocationManagerDelegate {
    typealias Handler = (Swift.Error?) -> Void
    
    private typealias ShouldRequestAuthorization = Bool
    
    let subject: LocationManagerAuthorizationSource.When
    
    var status: AuthorizationStatus<LocationManagerAuthorizationSource.When> {
        manager
            .authorizationStatus
            .toAuthorizationStatus(subject: subject, 
                                   accuracy: manager.accuracyAuthorization)
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
        notifyHandlers(error: Error.providerDeallocated)
    }
    
    func requestAuthorization(completion: @escaping Handler) {
        let shouldRequestAuthorization = appendHandler(completion)
        if shouldRequestAuthorization {
            requestAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.stopUpdatingLocation()
        notifyHandlers(error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        manager.stopUpdatingLocation()
        notifyHandlers(error: error)
    }
    
    // MARK: - Private
    
    private func appendHandler(_ handler: @escaping Handler) -> ShouldRequestAuthorization {
        lock.lock()
        let isFirstHandler = handlers.isEmpty
        handlers.append(handler)
        lock.unlock()
        return isFirstHandler
    }
    
    private func notifyHandlers(error: Swift.Error?) {
        let handlers = resetHandlers()
        for handler in handlers {
            handler(error)
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
#if !os(tvOS)
        case .always:
            manager.requestAlwaysAuthorization()
#endif
        case .inUse:
            manager.requestWhenInUseAuthorization()
            
        case .temporaryFull(let purposeKey):
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
        }
    }
}
