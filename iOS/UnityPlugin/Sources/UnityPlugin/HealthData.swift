import Foundation
import HealthKit

struct HealthData {
    private static let healthStore: HKHealthStore = HKHealthStore()
    private static let typeToRead: HKSampleType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!

    private static var sleepSamples: [HKCategorySample] = []

    static func isAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    static func requestAuth(onSuccess: @escaping SuccessBoolCallback, onError: @escaping ErrorCallback) {
        // let group = DispatchGroup()
        // group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            // let semaphore = DispatchSemaphore(value: 0)
            healthStore.requestAuthorization(toShare: nil, read: Set([typeToRead])) { (granted, error) in
                if let error = error {
                    print("requestAuthorization error:", error.localizedDescription)
                    onError(error.toInteropError())
                }
                if granted {
                    print("HealthKit authorization request was granted!")
                } else {
                    print("HealthKit authorization was not granted.")
                }
                onSuccess(granted)
                // semaphore.signal()
            }
            // semaphore.wait()
            // group.leave()
        }
        // group.wait()
    }

    static func querySleepSamples(startDateInSeconds: Double, endDateInSeconds: Double, maxNumSamples: Int, onSuccess: @escaping SuccessBoolCallback, onError: @escaping ErrorCallback) {
        let startDate = Date(timeIntervalSince1970: TimeInterval(startDateInSeconds))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endDateInSeconds))
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: typeToRead, predicate: predicate, limit: maxNumSamples, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            var success = false
            if let error = error {
                print("querySleepData error:", error.localizedDescription)
                onError(error.toInteropError())
            }
            if let samples = samples {
                print("querySleepData samples:", samples)
                sleepSamples = samples as! [HKCategorySample]
                success = true
            }
            onSuccess(success)
        }
    }

    static func getSleepSamplesCount() -> Int {
        return sleepSamples.count
    }

    static func getSleepSamplesAtIndex(index: Int) -> SleepSample {
        let sample = sleepSamples[Index(index)]
        return SleepSample(
            startDate: sample.startDate.timeIntervalSince1970,
            endDate: sample.endDate.timeIntervalSince1970,
            value: sample.value)
    }
}
