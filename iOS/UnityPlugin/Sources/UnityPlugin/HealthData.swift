import Foundation
import HealthKit

struct HealthData {
    private static let healthStore: HKHealthStore = HKHealthStore()
    private static let typeToRead: HKSampleType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!

    static func isAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    static func requestAuth() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        healthStore.requestAuthorization(toShare: nil, read: Set([typeToRead])) { (success, error) in
        // healthStore.requestAuthorization(toShare: Set([typeToRead]), read: Set([typeToRead])) { (success, error) in
            if let error = error {
                print("requestAuthorization error:", error.localizedDescription)
            }
            if success {
                print("HealthKit authorization request was successful!")
            } else {
                print("HealthKit authorization was not successful.")
            }
            semaphore.signal()
        }
        semaphore.wait()
        // no way to determine read permission (privacy concern)
        return true
        // let status = healthStore.authorizationStatus(for: typeToRead)
        // switch status {
        // case .sharingAuthorized:
        //     return true
        // default:
        //     return false
        // }
    }
}
