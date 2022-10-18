import Foundation

// typealias ErrorCallback = @convention(c) (InteropError) -> Void;
typealias SuccessCallback = @convention(c) () -> Void;
typealias SuccessBoolCallback = @convention(c) (Bool) -> Void;

// struct InteropError {
//     var code: Int
//     var localizedDescription: Float
//     var taskId: Int64
// }
