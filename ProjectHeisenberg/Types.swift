import Foundation

typealias VoidHandler = (() -> Void)
typealias Handler<T> = ((_ value: T) -> Void)
typealias OptionalErrorHandler = Handler<Error?>
typealias BoolHandler = Handler<Bool>

func delayedCall(_ delayInSeconds: Double = 0.0, closure: @escaping () -> Void) {
    let delayInMilliSeconds = Int(delayInSeconds * 1_000)
    let nanoseconds = DispatchTime.now() + DispatchTimeInterval.milliseconds(delayInMilliSeconds)
    DispatchQueue.main.asyncAfter(deadline: nanoseconds, execute: closure)
}

struct Axis: OptionSet {
    let rawValue: Int

    static let horizontal = Axis(rawValue: 1 << 0)
    static let vertical = Axis(rawValue: 1 << 1)
    
    static let both: Axis = [.horizontal, .vertical]
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    var opposite: Axis {
        let vertical = contains(.vertical)
        let horizontal = contains(.horizontal)
        guard !vertical || !horizontal  else { fatalError("No opposite axis! both axii already specified")}
        
        return vertical ? .horizontal : .vertical
    }
    
    @discardableResult func `do`<Type>(_ isHandler: (() -> Type)? = nil, `if` axis: Axis, `else` isntHandler: (() -> Type)? = nil) -> Type? {
        assert(axis != .both, "You cant specify both axii")
        return self == axis ? isHandler?() : isntHandler?()
    }
}

enum DownloadError: Error {
    case jsonParsingError
}
