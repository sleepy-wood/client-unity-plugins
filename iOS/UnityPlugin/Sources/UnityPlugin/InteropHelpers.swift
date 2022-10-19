import Foundation
import UnityPluginStuff

typealias ErrorCallback = @convention(c) (InteropError) -> Void;
typealias SuccessCallback = @convention(c) () -> Void;
typealias SuccessBoolCallback = @convention(c) (Bool) -> Void;
