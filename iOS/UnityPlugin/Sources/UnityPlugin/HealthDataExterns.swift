import Foundation
import UnityPluginStuff

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataIsAvailable")
func iOS_healthDataIsAvailable() -> Bool {
    HealthData.isAvailable()
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataRequestAuth")
func iOS_healthDataRequestAuth(
    onSuccess: @escaping SuccessBoolCallback,
    onError: @escaping ErrorCallback
) {
    HealthData.requestAuth(onSuccess: onSuccess, onError: onError)
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataQuerySleepSamples")
func iOS_healthDataQuerySleepSamples(
    startDateInSeconds: Double,
    endDateInSeconds: Double,
    maxNumSamples: Int,
    onSuccess: @escaping SuccessBoolCallback,
    onError: @escaping ErrorCallback
) {
    HealthData.querySleepSamples(
        startDateInSeconds: startDateInSeconds,
        endDateInSeconds: endDateInSeconds,
        maxNumSamples: maxNumSamples,
        onSuccess: onSuccess,
        onError: onError
    )
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataGetSleepSamplesCount")
func iOS_healthDataGetSleepSamplesCount() -> Int {
    HealthData.getSleepSamplesCount()
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataGetSleepSampleAtIndex")
func iOS_healthDataGetSleepSampleAtIndex(index: Int) -> SleepSample {
    HealthData.getSleepSampleAtIndex(index: index)
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataQueryActivitySamples")
func iOS_healthDataQueryActivitySamples(
    startDateInSeconds: Double,
    endDateInSeconds: Double,
    onSuccess: @escaping SuccessBoolCallback,
    onError: @escaping ErrorCallback
) {
    HealthData.queryActivitySamples(
        startDateInSeconds: startDateInSeconds,
        endDateInSeconds: endDateInSeconds,
        onSuccess: onSuccess,
        onError: onError
    )
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataGetActivitySamplesCount")
func iOS_healthDataGetActivitySamplesCount() -> Int {
    HealthData.getActivitySamplesCount()
}

@available(iOS 8.0, macOS 13, *)
@_cdecl("iOS_healthDataGetActivitySampleAtIndex")
func iOS_healthDataGetActivitySampleAtIndex(index: Int) -> ActivitySample {
    HealthData.getActivitySampleAtIndex(index: index)
}
