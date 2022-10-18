import Foundation
import HealthKit

struct HealthData {
    private static let healthStore: HKHealthStore = HKHealthStore()
    private static let typeToRead: HKSampleType? =  HKSampleType.categoryType(forIdentifier: .sleepAnalysis)

    static func isAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    static func requestAuth() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        healthStore.requestAuthorization(toShare: nil, read: Set([typeToRead!])) { (success, error) in
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
