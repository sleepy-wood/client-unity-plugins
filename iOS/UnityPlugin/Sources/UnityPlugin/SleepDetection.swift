import CoreML
import CoreMotion
import Foundation

enum SleepDetection {
    private static let motionManager: CMMotionManager = .init()
    private static let activityManager: CMMotionActivityManager = .init()

    static func isAvailable() -> Bool {
        motionManager.isDeviceMotionAvailable && CMMotionActivityManager.isActivityAvailable()
    }
}
