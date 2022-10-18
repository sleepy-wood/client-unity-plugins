import Foundation
import HealthKit

struct HealthData {
    private static let healthStore: HKHealthStore = HKHealthStore()
    private static let typeToRead: HKSampleType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!

    static func isAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    static func requestAuth() {
        DispatchQueue.main.async {
            healthStore.requestAuthorization(toShare: nil, read: Set([typeToRead])) { (success, error) in
                if let error = error {
                    print("requestAuthorization error:", error.localizedDescription)
                }
                if success {
                    print("HealthKit authorization request was successful!")
                } else {
                    print("HealthKit authorization was not successful.")
                }
            }
        }
    }
}
