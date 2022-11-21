import CoreML
import CoreMotion
import Foundation

enum SleepDetection {
    private static let motionManager: CMMotionManager = .init()
    private static let activityManager: CMMotionActivityManager = .init()
    private static let stationary: Bool = true
    private static let initialized: Bool = false
    private static let acceleration: CMAcceleration = .init()
    private static let heartRateSamples: [Double] = []

    static func isAvailable() -> Bool {
        motionManager.isAccelerometerAvailable && CMMotionActivityManager.isActivityAvailable()
    }

    static func init() {
        if !initialized && isAvailable() && HealthData.isAvailable() {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let error {
                    print("accelerometerUpdate error:", error.localizedDescription)
                }
                if let data {
                    acceleration = data.acceleration
                }
            }
            activityManager.startActivityUpdates(to: .main) { activity in
                if let activity = activity {
                    stationary = activity.stationary
                }
            }

            HealthData.requestAuth(
                onSuccess: { granted in
                    if granted {
                        HealthData.queryHeartRateSamples(
                            startDateInSeconds: 0,
                            endDateInSeconds: 0,
                            maxNumSamples: 0,
                            onSuccess: { samples in
                                heartRateSamples = samples
                            },
                            onError: { error in
                                print("queryHeartRateSamples error:", error)
                            }
                        )
                    }
                },
                onError: { error in
                    print("requestAuth error:", error)
                }
            )
            initialized = true
        }
    }
}
