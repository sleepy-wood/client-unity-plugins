import CoreML
import CoreMotion
import Foundation
import HealthKit

enum SleepStatus {
    case unknown = -1
    case awake = 0
    case asleep = 1
}

enum SleepDetection {
    private static let motionManager: CMMotionManager = .init()
    private static let activityManager: CMMotionActivityManager = .init()
    private static let stationary: Bool = true
    private static let initialized: Bool = false
    private static let acceleration: CMAcceleration = .init()
    private static let heartRateSamples: [HKQuantityType] = []

    static func isAvailable() -> Bool {
        motionManager.isAccelerometerAvailable && CMMotionActivityManager.isActivityAvailable()
    }

    static func init() {
        if !initialized && isAvailable() && HealthData.isAvailable() {
            motionManager.accelerometerUpdateInterval = 1.0
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

            let startDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: nil,
                options: .strictStartDate
            )
            let sortDescriptor = NSSortDescriptor(
                key: HKSampleSortIdentifierStartDate,
                ascending: false
            )
            let query = HKSampleQuery(
                sampleType: HKObjectType.quantityType(forIdentifier: .heartRate)!,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { query, samples, error in
                if let error {
                    print("heartRateQuery error:", error.localizedDescription)
                }
                if let samples {
                    heartRateSamples = samples
                }
            }
            let timer = Timer(fire: Date(), interval: 10.0, repeats: true) { _ in
                print("timer fired")
                HealthData.healthStore.execute(query)
            }
            RunLoop.current.add(timer, forMode: .default)
            initialized = true
            print("SleepDetection initialized")
        }
    }

    static func detectSleepStatus() -> SleepStatus {
        if !initialized {
            print("SleepDetection not initialized")
            return .unknown
        }
        if !stationary {
            return .awake
        }
        let nwin = 5
        if heartRateSamples.count < nwin {
            return .unknown
        }
        hvs, hds = [], []
        prevd = Date().timeIntervalSince1970
        for i in 0..<nwin {
            let sample = heartRateSamples[i]
            let hv = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            let currd = sample.startDate.timeIntervalSince1970
            let hd = prevd - currd
            hvs.append(hv)
            hds.append(hd)
            prevd = currd
        }
        accs = [acceleration.x, acceleration.y, acceleration.z]
        let heartRate = heartRateSamples.first?.quantity.doubleValue(for: HKUnit(from: "count/min"))
        let model = SleepDetectionModel()
        let input = SleepDetectionModelInput(
            acceleration_x: acceleration.x,
            acceleration_y: acceleration.y,
            acceleration_z: acceleration.z,
            heart_rate: heartRate
        )
        let output = try? model.prediction(input: input)
        print(output)
        return output?.classLabel == "asleep" ? .asleep : .awake
    }
}
