import Foundation
import UnityPluginStuff

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_sleepDetectionIsAvailable")
func iOS_sleepDetectionIsAvailable() -> Bool {
    SleepDetection.isAvailable()
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_sleepDetectionDetectSleep")
func iOS_sleepDetectionDetectSleep() -> Int32 {
    Int32(SleepDetection.detectSleep().rawValue)
}
