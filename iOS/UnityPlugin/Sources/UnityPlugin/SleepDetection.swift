import CoreML
import CoreMotion
import Foundation
import HealthKit

enum SleepStatus: Int {
    case unknown = -1
    case awake = 0
    case asleep = 1
}

@available(iOS 13.0, macOS 13, *)
enum SleepDetection {
    private static let motionManager: CMMotionManager = .init()
    private static let activityManager: CMMotionActivityManager = .init()
    private static var stationary: Bool = true
    private static var initialized: Bool = false
    private static var acceleration: CMAcceleration = .init()
    private static var heartRateSamples: [HKQuantitySample] = []

    static func isAvailable() -> Bool {
        motionManager.isAccelerometerAvailable && CMMotionActivityManager
            .isActivityAvailable() && HealthData.isAvailable()
    }

    static func initialize() {
        if !initialized, isAvailable() {
            motionManager.accelerometerUpdateInterval = 1.0
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let error {
                    print("accelerometerUpdate error:", error.localizedDescription)
                }
                if let data {
                    // print(Date(), "accelerometerUpdate:", data)
                    acceleration = data.acceleration
                }
            }
            activityManager.startActivityUpdates(to: .main) { activity in
                if let activity {
                    // print(Date(), "accelerometerUpdate:", activity)
                    stationary = activity.stationary
                }
            }
            DispatchQueue.global().async {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
                    ) { _, samples, error in
                        if let error {
                            print("heartRateQuery error:", error.localizedDescription)
                        }
                        if let samples {
                            heartRateSamples = samples as! [HKQuantitySample]
                        }
                    }
                    HealthData.healthStore.execute(query)
                    print("heartRateQuery executed")
                }
                RunLoop.current.run()
            }
            initialized = true
            print("SleepDetection initialized")
        }
    }

    static func detectSleep() -> SleepStatus {
        if !initialized {
            print("SleepDetection not initialized")
            return .unknown
        }
        if !stationary {
            return .awake
        }
        let nwin = 5
        if heartRateSamples.count < nwin {
            print("not enough heart rate samples")
            return .unknown
        }
        var hvs: [Double] = []
        var hds: [Double] = []
        var prevd = Date().timeIntervalSince1970
        for i in 0 ..< nwin {
            let sample = heartRateSamples[i]
            let hv = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            let currd = sample.startDate.timeIntervalSince1970
            let hd = prevd - currd
            hvs.append(hv)
            hds.append(hd)
            prevd = currd
        }
        let accs = [acceleration.x, acceleration.y, acceleration.z]
        print(accs, hvs, hds)
        if let model = try? SleepDetector(configuration: .init()) {
            print("Hello")
            let input = SleepDetectorInput(
                accs: try! MLMultiArray(accs),
                hvs: try! MLMultiArray(hvs),
                hds: try! MLMultiArray(hds)
            )
            if let output = try? model.prediction(input: input) {
                print(output)
                return output.out_[0] as! Double > 0 ? .asleep : .awake
            }
        }
        return .unknown
    }
}
