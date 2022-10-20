# Unity - Smart Watch & Health Care Integration

-   유니티에 API가 없어 직접 native와 연결
-   유구한 역사와 전통의 make build로 구성

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

`TestProject/Assets/Scripts/NativePluginTest.cs` 확인

### HealthData

```csharp
using NativePlugin.HealthData;
```

#### `bool HealthData.IsAvailable()`

#### `void HealthData.RequestAuth()`

#### `void HealthData.QuerySleepSamples(DateTime startDate, DateTime endDate, int maxNumSamples)`
