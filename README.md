# Unity - Smart Watch & Health Care Integration

-   유니티에 API가 없어 직접 native와 연결
-   유구한 역사와 전통의 make build로 구성
-   C# (Unity) <-> C FFI <-> Swift (iOS)
-   사용된 iOS Framework: HealthKit, CoreMotion, CoreML

## 1. Build & Push

### Build binary

```bash
make build
```

### Push binary to dist branch

```bash
make push
```

## 2. API Usage

[`TestProject/Assets/Scripts/NativePluginTest.cs`](TestProject/Assets/Scripts/NativePluginTest.cs) 확인

### HealthData

```csharp
using NativePlugin.HealthData;
```

#### Functions

-   `bool HealthData.IsAvailable()`
-   `void HealthData.RequestAuth()`
-   `void HealthData.QuerySleepSamples(DateTime startDate, DateTime endDate, int maxNumSamples)`
-   `void HealthData.QueryActivitySamples(DateTime startDate, DateTime endDate)`

#### Events

-   `event RequestAuthCompletedHandler RequestAuthCompleted`
-   `event QuerySleepSamplesCompletedHandler QuerySleepSamplesCompleted`
-   `event QueryActivitySamplesCompletedHandler QueryActivitySamplesCompleted`

#### Delegates

-   `delegate void RequestAuthCompletedHandler(bool granted)`
-   `delegate void QuerySleepSamplesCompletedHandler(SleepSample[] samples)`
-   `delegate void QueryActivitySamplesCompletedHandler(ActivitySample[] samples)`

### SleepDetection

```csharp
using NativePlugin.SleepDetection;
```

#### Functions

-   `bool SleepDetection.IsAvailable()`
-   `SleepStatus SleepDetection.DetectSleep()`
