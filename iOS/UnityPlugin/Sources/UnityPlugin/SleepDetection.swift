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
            // TODO: 현재 10초마다 Heart Rate 가져오는데, HKObserverQuery를 사용하는게 더 나을지도
            DispatchQueue.global().async {
                let timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
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
                timer.fire()
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
        print("SleepDetector input:", "accs", accs, "hvs", hvs, "hds", hds)
        do {
            let accsArray = try MLMultiArray(shape: [1, 3] as [NSNumber], dataType: .double)
            let hvsArray = try MLMultiArray(shape: [1, nwin] as [NSNumber], dataType: .double)
            let hdsArray = try MLMultiArray(shape: [1, nwin] as [NSNumber], dataType: .double)
            for i in 0 ..< 3 {
                accsArray[[0, i] as [NSNumber]] = NSNumber(value: accs[i])
            }
            for i in 0 ..< nwin {
                hvsArray[[0, i] as [NSNumber]] = NSNumber(value: hvs[i])
                hdsArray[[0, i] as [NSNumber]] = NSNumber(value: hds[i])
            }
            let input = SleepDetectorInput(
                accs: accsArray,
                hvs: hvsArray,
                hds: hdsArray
            )
            let output = try SleepDetector(configuration: .init()).prediction(input: input)
            print("SleepDetector output:", output.out_[0] as! Double)
            return output.out_[0] as! Double > 0 ? .asleep : .awake
        } catch {
            print("SleepDetector error:", error.localizedDescription)
            return .unknown
        }
    }
}
