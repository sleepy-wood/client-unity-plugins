import Foundation

@_cdecl("iOS_runHello")
func iOS_runHello() {
    print("Hello world from iOS")
}

@_cdecl("iOS_healthDataIsAvailable")
func iOS_healthDataIsAvailable() -> Bool {
    return HealthData.isAvailable()
}

@_cdecl("iOS_healthDataRequestAuth")
func iOS_healthDataRequestAuth() -> Bool {
    return HealthData.requestAuth()
}
