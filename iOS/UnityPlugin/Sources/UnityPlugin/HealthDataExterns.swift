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
