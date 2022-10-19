import Foundation

@_cdecl("iOS_healthDataIsAvailable")
func iOS_healthDataIsAvailable() -> Bool {
    return HealthData.isAvailable()
}

@_cdecl("iOS_healthDataRequestAuth")
func iOS_healthDataRequestAuth(onSuccess: @escaping SuccessBoolCallback, onError: @escaping ErrorCallback) {
    return HealthData.requestAuth(onSuccess: onSuccess, onError: onError)
}
