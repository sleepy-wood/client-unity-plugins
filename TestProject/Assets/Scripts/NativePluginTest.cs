using System;
using UnityEngine;

// using NativePlugin;
// using NativePlugin.HealthData;
using NativePlugin.SleepDetection;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        HealthDataStore.Init();
        InvokeRepeating("CheckSleep", 0, 1);
        // // just for testing purpose
        // HelloTest.RunHello();
        // Debug.Log("DebugLog Test");
        // Debug.Log("HealthDataIsAvailable: " + HealthData.IsAvailable().ToString());
        // // register event handlers
        // HealthData.RequestAuthCompleted += OnRequestAuthCompleted;
        // HealthData.QuerySleepSamplesCompleted += OnQuerySleepSamplesCompleted;
        // HealthData.QueryActivitySamplesCompleted += OnQueryActivitySamplesCompleted;
        // // if HealthData is available (not available in iPad...), request authorization
        // if (HealthData.IsAvailable())
        // {
        //     HealthData.RequestAuth();
        // }
    }

    bool once = false;

    void Update()
    {
        if (HealthDataStore.GetStatus() == HealthDataStoreStatus.Loaded && !once)
        {
            once = true;
            Debug.Log("SleepSamples: " + HealthDataStore.SleepSamples.Length);
            Debug.Log("ActivitySamples: " + HealthDataStore.ActivitySamples.Length);
            HealthReport report = HealthDataAnalyzer.GetDailyReport(
                new DateTime(2022, 10, 06, 17, 0, 0, 0, DateTimeKind.Local),
                6
            );
            Debug.Log(JsonUtility.ToJson(report, true));
        }
    }

    void CheckSleep()
    {
        if (SleepDetection.IsAvailable())
        {
            SleepDetectionResult result = SleepDetection.DetectSleep();
            Debug.Log("IsStationary: " + result.IsStationary.ToString());
            Debug.Log("AccelerationMagnitudeInG: " + result.AccelerationMagnitudeInG.ToString());
            Debug.Log(
                "HeartRateStandardDeviationInBpm: "
                    + result.HeartRateStandardDeviationInBpm.ToString()
            );
            Debug.Log("HeartRateAverageInBpm: " + result.HeartRateAverageInBpm.ToString());
            Debug.Log(
                "HeartRateIntervalStandardDeviationInSeconds: "
                    + result.HeartRateIntervalStandardDeviationInSeconds.ToString()
            );
            Debug.Log(
                "HeartRateIntervalAverageInSeconds: "
                    + result.HeartRateIntervalAverageInSeconds.ToString()
            );
            Debug.Log("NetworkOutput: " + result.NetworkOutput.ToString());
            Debug.Log("SleepState: " + result.SleepState.ToString());
        }
    }

    // void OnRequestAuthCompleted(bool granted)
    // {
    //     Debug.Log("Start:RequestAuthCompleted: " + granted.ToString());
    //     // if authorization is granted, query sleep samples
    //     if (granted)
    //     {
    //         HealthData.QuerySleepSamples(
    //             new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
    //             DateTime.Now,
    //             10000
    //         );
    //         HealthData.QueryActivitySamples(
    //             new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
    //             DateTime.Now
    //         );
    //     }
    // }

    // void OnQuerySleepSamplesCompleted(SleepSample[] samples)
    // {
    //     // if there was error, samples will be null
    //     if (samples != null)
    //     {
    //         Debug.Log("Start:QuerySleepSamplesCompleted: " + samples.Length.ToString());
    //     }
    // }

    // void OnQueryActivitySamplesCompleted(ActivitySample[] samples)
    // {
    //     // if there was error, samples will be null
    //     if (samples != null)
    //     {
    //         Debug.Log("Start:QueryActivitySamplesCompleted: " + samples.Length.ToString());
    //     }
    // }
}
