import Foundation
import UnityPluginStuff

@_cdecl("iOS_healthDataIsAvailable")
func iOS_healthDataIsAvailable() -> Bool {
    return HealthData.isAvailable()
}

@_cdecl("iOS_healthDataRequestAuth")
func iOS_healthDataRequestAuth(onSuccess: @escaping SuccessBoolCallback, onError: @escaping ErrorCallback) {
    return HealthData.requestAuth(onSuccess: onSuccess, onError: onError)
}

@_cdecl("iOS_healthDataQuerySleepSamples")
func iOS_healthDataQuerySleepSamples(startDateInSeconds: Double, endDateInSeconds: Double, maxNumSamples: Int, onSuccess: @escaping SuccessBoolCallback, onError: @escaping ErrorCallback) {
    return HealthData.querySleepSamples(startDateInSeconds: startDateInSeconds, endDateInSeconds: endDateInSeconds, maxNumSamples: maxNumSamples, onSuccess: onSuccess, onError: onError)
}

@_cdecl("iOS_healthDataGetSleepSamplesCount")
func iOS_healthDataGetSleepSamplesCount() -> Int {
    return HealthData.getSleepSamplesCount()
}

@_cdecl("iOS_healthDataGetSleepSamplesAtIndex")
func iOS_healthDataGetSleepSamplesAtIndex(index: Int) -> SleepSample {
    return HealthData.getSleepSamplesAtIndex(index: index)
}
