import Foundation
import UnityPluginStuff

typealias ErrorCallback = @convention(c) (InteropError) -> Void
typealias SuccessCallback = @convention(c) () -> Void
typealias SuccessBoolCallback = @convention(c) (Bool) -> Void

public extension String {
    func toCharPCopy() -> UnsafeMutablePointer<Int8> {
        let utfText = (self as NSString).utf8String!
        let pointer = UnsafeMutablePointer<Int8>.allocate(capacity: (8 * self.count) + 1)
        return strcpy(pointer, utfText)
    }
}

public extension UnsafeMutablePointer<Int8> {
    func toString() -> String {
        return String(cString: self)
    }
}

public extension Error {
    func code() -> Int {
        return (self as NSError).code
    }
    func toInteropError() -> InteropError {
        return InteropError(
            code: Int32(self.code()),
            localizedDescription: self.localizedDescription.toCharPCopy())
    }
}

public extension Array {
    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Element> {
        let ptr = UnsafeMutablePointer<Element>.allocate(capacity: self.count)
        ptr.assign(from: self, count: self.count)
        return ptr
    }
}
