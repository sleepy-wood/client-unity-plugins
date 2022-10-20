import Foundation
import UnityPluginStuff

typealias ErrorCallback = @convention(c) (InteropError) -> Void
typealias SuccessCallback = @convention(c) () -> Void
typealias SuccessBoolCallback = @convention(c) (Bool) -> Void

public extension String {
    func toCharPCopy() -> UnsafeMutablePointer<Int8> {
        let utfText = (self as NSString).utf8String!
        let pointer = UnsafeMutablePointer<Int8>
            .allocate(capacity: (8 * count) + 1)
        return strcpy(pointer, utfText)
    }
}

public extension UnsafeMutablePointer<Int8> {
    func toString() -> String {
        String(cString: self)
    }
}

public extension Error {
    func code() -> Int {
        (self as NSError).code
    }

    func toInteropError() -> InteropError {
        InteropError(
            code: Int32(code()),
            localizedDescription: localizedDescription.toCharPCopy()
        )
    }
}

public extension Array {
    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Element> {
        let ptr = UnsafeMutablePointer<Element>.allocate(capacity: count)
        ptr.assign(from: self, count: count)
        return ptr
    }
}
