import Foundation

public final class ExpirableCompletion<Success> {
    private let lock = NSLock()
    private let operationQueue: OperationQueue

    private var completion: ((Result<Success, Swift.Error>) -> Void)?

    public init(timeout: TimeInterval?, operationQueue: OperationQueue, completion: @escaping (Result<Success, Swift.Error>) -> Void) {
        self.operationQueue = operationQueue
        self.completion = completion
        if let timeout = timeout {
            expireAfterDelay(timeout)
        }
    }

    private func expireAfterDelay(_ delay: TimeInterval) {
        DispatchQueue
            .global()
            .asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.execute(with: Result.failure(Error.operationTimedOut))
            }
    }

    public func execute(with result: Result<Success, Swift.Error>) {
        guard completion != nil else {
            return
        }
        lock.lock()
        if let block = completion {
            completion = nil
            operationQueue.addOperation {
                block(result)
            }
        }
        lock.unlock()
    }
}

extension ExpirableCompletion where Success == Void {
    public func execute(with failure: Swift.Error?) {
        if let failure = failure {
            execute(with: Result.failure(failure))
        } else {
            execute(with: Result.success(Void()))
        }
    }
}
