![banner](https://github.com/sleepy-wood/client-unity-plugins/blob/main/client-unity-plugins.png)

# client-unity-plugins

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![MIT License][license-shield]][license-url]

<div align="center">
  <a href="https://github.com/sleepy-wood">
    <img src="https://github.com/sleepy-wood/client-web/blob/dev/src/assets/images/logo.png" alt="Logo" width="120" height="120">
  </a>
  <h3 align="center">Unity - Smart Watch & Health Care Integration</h3>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
    </li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

-   유니티에 API가 없어 직접 native와 연결
-   유구한 역사와 전통의 make build로 구성
-   C# (Unity) <-> C FFI <-> Swift (iOS)
-   HealthKit -> Health Data
-   HealthKit + CoreMotion + CoreML -> Sleep Detection

<!-- GETTING STARTED -->
## Getting Started

### 1. Build & Push

#### Build binary

```bash
make build
```

#### Push binary to dist branch

```bash
make push
```

### 2. API Usage

[`TestProject/Assets/Scripts/NativePluginTest.cs`](TestProject/Assets/Scripts/NativePluginTest.cs) 확인

#### HealthData

```csharp
using NativePlugin.HealthData;
```

##### Functions

- `bool HealthData.IsAvailable()`
- `void HealthData.RequestAuth()`
- `void HealthData.QuerySleepSamples(DateTime startDate, DateTime endDate, int maxNumSamples)`
- `void HealthData.QueryActivitySamples(DateTime startDate, DateTime endDate)`

##### Events

- `event RequestAuthCompletedHandler HealthData.RequestAuthCompleted`
- `event QuerySleepSamplesCompletedHandler HealthData.QuerySleepSamplesCompleted`
- `event QueryActivitySamplesCompletedHandler HealthData.QueryActivitySamplesCompleted`

##### Delegates

- `delegate void RequestAuthCompletedHandler(bool granted)`
- `delegate void QuerySleepSamplesCompletedHandler(`[`SleepSample`](Runtime/HealthData.cs#L21)`[] samples)`
- `delegate void QueryActivitySamplesCompletedHandler(`[`ActivitySample`](Runtime/HealthData.cs#L35)`[] samples)`

#### SleepDetection

```csharp
using NativePlugin.SleepDetection;
```

##### Functions

- `bool SleepDetection.IsAvailable()`
- [`SleepDetectionResult`](Runtime/SleepDetection.cs#L16)` SleepDetection.DetectSleep()`

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

[contributors-shield]: https://img.shields.io/github/contributors/sleepy-wood/client-unity-plugins.svg?style=for-the-badge
[contributors-url]: https://github.com/sleepy-wood/blocclient-unity-plugins/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/sleepy-wood/client-unity-plugins.svg?style=for-the-badge
[forks-url]: https://github.com/sleepy-wood/client-unity-plugins/network/members
[stars-shield]: https://img.shields.io/github/stars/sleepy-wood/client-unity-plugins.svg?style=for-the-badge
[stars-url]: https://github.com/sleepy-wood/client-unity-plugins/stargazers
[license-shield]: https://img.shields.io/github/license/sleepy-wood/client-unity-plugins.svg?style=for-the-badge
[license-url]: https://github.com/sleepy-wood/client-unity-plugins/blob/master/LICENSE.txt
