#if canImport(HomeKit)
import Foundation
import HomeKit

class HomeManagerAuthorizationProvider: NSObject, HMHomeManagerDelegate {
    typealias Handler = (Swift.Error?) -> Void

    private typealias IsFirstHandler = Bool

    let subject: Void

    var status: AuthorizationStatus<Void> {
        manager
            .authorizationStatus
            .toAuthorizationStatus(subject: subject)
    }

    private lazy var manager: HMHomeManager = {
        let manager = HMHomeManager()
        manager.delegate = self
        return manager
    }()

    private let lock = NSRecursiveLock()

    private var handlers = [Handler]()
    private var delegateCalled = false

    init(subject: Void = Void()) {
        self.subject = subject
    }

    deinit {
        assert(handlers.isEmpty, "\(self) is being deinitialized while there are still \(handlers.count) handlers waiting to be notified")
        notifyHandlers(error: Error.providerDeallocated)
    }

    func requestAuthorization(completion: @escaping Handler) {
        let isFirstHandler = appendHandler(completion)
        let shouldRequestAuthorization = isFirstHandler && !delegateCalled
        if shouldRequestAuthorization {
            _ = manager
        } else {
            notifyHandlers(error: nil)
        }
    }

    // MARK: - HMHomeManagerDelegate

    func homeManagerDidUpdateHomes(_: HMHomeManager) {
        delegateCalled = true
        notifyHandlers(error: nil)
    }

    func homeManager(_: HMHomeManager, didUpdate _: HMHomeManagerAuthorizationStatus) {
        delegateCalled = true
        DispatchQueue
            .main
            .async { [weak self] in
                self?.notifyHandlers(error: nil)
            }
    }

    // MARK: - Private

    private func appendHandler(_ handler: @escaping Handler) -> IsFirstHandler {
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
}
#endif
