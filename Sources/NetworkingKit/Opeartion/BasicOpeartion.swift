// adapted from: https://agostini.tech/2017/07/30/understanding-operation-and-operationqueue-in-swift/

import Foundation

public class BasicOperation: Operation {

    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override public var isExecuting: Bool {
        return state == .executing
    }

    override public var isReady: Bool {
        return super.isReady && state == .ready
    }

    override public var isFinished: Bool {
        return state == .finished
    }

    func setExecuting() {
        state = .executing
    }
    
    func setFinished() {
        state = .finished
    }

    override public func start() {
        if isCancelled {
            setFinished()
            return
        }
        main()
        setExecuting()
    }

    override public func cancel() {
        super.cancel()
        state = .finished
    }
}
