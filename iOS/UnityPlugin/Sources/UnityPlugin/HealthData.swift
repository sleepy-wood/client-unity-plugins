import Foundation
import HealthKit
import UnityPluginStuff

@available(iOS 8.0, macOS 13, *)
enum HealthData {
    static let healthStore: HKHealthStore = .init()
    private static let typeToRead: [String: HKObjectType] = [
        "sleep": HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!,
        "activity": HKObjectType.activitySummaryType(),
        "heart": HKObjectType.quantityType(forIdentifier: .heartRate)!,
        "respiratory": HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
        "oxygen": HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
    ]
    private static let calander: Calendar = .current

    private static var sleepSamples: [HKCategorySample] = []
    private static var activitySamples: [HKActivitySummary] = []

    static func isAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    static func requestAuth(
        onSuccess: @escaping SuccessBoolCallback,
        onError: @escaping ErrorCallback
    ) {
        // let group = DispatchGroup()
        // group.enter()
        DispatchQueue.main.async {
            // let semaphore = DispatchSemaphore(value: 0)
            healthStore.requestAuthorization(
                toShare: nil,
                read: Set(typeToRead.values)
            ) { granted, error in
                if let error {
                    print(
                        "requestAuthorization error:",
                        error.localizedDescription
                    )
                    onError(error.toInteropError())
                }
                if granted {
                    print("HealthKit authorization request was granted!")
                    SleepDetection.initialize()
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

    static func querySleepSamples(
        startDateInSeconds: Double,
        endDateInSeconds: Double,
        maxNumSamples: Int,
        onSuccess: @escaping SuccessBoolCallback,
        onError: @escaping ErrorCallback
    ) {
        let startDate =
            Date(timeIntervalSince1970: TimeInterval(startDateInSeconds))
        let endDate =
            Date(timeIntervalSince1970: TimeInterval(endDateInSeconds))
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: true
        )
        let query = HKSampleQuery(
            sampleType: typeToRead["sleep"] as! HKSampleType,
            predicate: predicate,
            limit: maxNumSamples,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            var success = false
            if let error {
                print("querySleepData error:", error.localizedDescription)
                onError(error.toInteropError())
            }
            if let samples {
                // print("querySleepData samples:", samples)
                sleepSamples = samples as! [HKCategorySample]
                success = true
            }
            onSuccess(success)
        }
        healthStore.execute(query)
    }

    static func getSleepSamplesCount() -> Int {
        sleepSamples.count
    }

    static func getSleepSampleAtIndex(index: Int) -> SleepSample {
        let sample = sleepSamples[index]
        return SleepSample(
            startDateInSeconds: sample.startDate.timeIntervalSince1970,
            endDateInSeconds: sample.endDate.timeIntervalSince1970,
            value: Int32(sample.value)
        )
    }

    static func queryActivitySamples(
        startDateInSeconds: Double,
        endDateInSeconds: Double,
        onSuccess: @escaping SuccessBoolCallback,
        onError: @escaping ErrorCallback
    ) {
        let startDate =
            Date(timeIntervalSince1970: TimeInterval(startDateInSeconds))
        let endDate =
            Date(timeIntervalSince1970: TimeInterval(endDateInSeconds))

        let units: Set<Calendar.Component> = [.day, .month, .year, .era]
        var startDateComponents = calander.dateComponents(
            units,
            from: startDate
        )
        startDateComponents.calendar = calander
        var endDateComponents = calander.dateComponents(
            units,
            from: endDate
        )
        endDateComponents.calendar = calander

        let predicate = HKQuery.predicate(
            forActivitySummariesBetweenStart: startDateComponents,
            end: endDateComponents
        )
        let query = HKActivitySummaryQuery(
            predicate: predicate
        ) { _, samples, error in
            var success = false
            if let error {
                print("queryActivityData error:", error.localizedDescription)
                onError(error.toInteropError())
            }
            if let samples {
                // print("queryActivityData samples:", samples)
                activitySamples = samples
                success = true
            }
            onSuccess(success)
        }
        healthStore.execute(query)
    }

    static func getActivitySamplesCount() -> Int {
        activitySamples.count
    }

    static func getActivitySampleAtIndex(index: Int) -> ActivitySample {
        let sample = activitySamples[index]
        let date = calander.date(from: sample.dateComponents(for: calander))!

        // let moveUnit = HKUnit.minute()
        let energyUnit = HKUnit.kilocalorie()
        let standUnit = HKUnit.count()
        let exerciseUnit = HKUnit.minute()

        // let moveTime = sample.appleMoveTime.doubleValue(for: moveUnit)
        let energyBurned = sample.activeEnergyBurned.doubleValue(for: energyUnit)
        let exerciseTime = sample.appleExerciseTime.doubleValue(for: exerciseUnit)
        let standHours = sample.appleStandHours.doubleValue(for: standUnit)

        // let moveTimeGoal = sample.appleMoveTimeGoal.doubleValue(for: moveUnit)
        let energyBurnedGoal = sample.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
        // let exerciseTimeGoal = sample.exerciseTimeGoal?.doubleValue(for: exerciseUnit) ?? 0.0
        // let standHoursGoal = sample.standHoursGoal?.doubleValue(for: standUnit) ?? 0.0
        let exerciseTimeGoal = sample.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
        let standHoursGoal = sample.appleStandHoursGoal.doubleValue(for: standUnit)

        return ActivitySample(
            dateInSeconds: date.timeIntervalSince1970,
            // isMoveMode: sample.activityMoveMode == .appleMoveTime,
            // moveTimeInMinutes: moveTime,
            // moveTimeGoalInMinutes: moveTimeGoal,
            activeEnergyBurnedInKcal: energyBurned,
            activeEnergyBurnedGoalInKcal: energyBurnedGoal,
            exerciseTimeInMinutes: Int32(exerciseTime),
            exerciseTimeGoalInMinutes: Int32(exerciseTimeGoal),
            standHours: Int32(standHours),
            standHoursGoal: Int32(standHoursGoal)
        )
    }
}
