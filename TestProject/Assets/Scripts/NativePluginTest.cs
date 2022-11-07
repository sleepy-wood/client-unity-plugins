using System;
using UnityEngine;
using NativePlugin;
using NativePlugin.HealthData;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        // just for testing purpose
        HelloTest.RunHello();
        Debug.Log("DebugLog Test");
        Debug.Log("HealthDataIsAvailable: " + HealthData.IsAvailable().ToString());
        // register event handlers
        HealthData.RequestAuthCompleted += OnRequestAuthCompleted;
        HealthData.QuerySleepSamplesCompleted += OnQuerySleepSamplesCompleted;
        HealthData.QueryActivitySamplesCompleted += OnQueryActivitySamplesCompleted;
        // if HealthData is available (not available in iPad...), request authorization
        if (HealthData.IsAvailable())
        {
            HealthData.RequestAuth();
        }
    }

    void OnRequestAuthCompleted(bool granted)
    {
        Debug.Log("Start:RequestAuthCompleted: " + granted.ToString());
        // if authorization is granted, query sleep samples
        if (granted)
        {
            HealthData.QuerySleepSamples(
                new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                DateTime.Now,
                100
            );
            HealthData.QueryActivitySamples(
                new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                DateTime.Now
            );
        }
    }

    void OnQuerySleepSamplesCompleted(SleepSample[] samples)
    {
        // if there was error, samples will be null
        if (samples != null)
        {
            Debug.Log("Start:QuerySleepSamplesCompleted: " + samples.Length.ToString());
        }
    }

    void OnQueryActivitySamplesCompleted(ActivitySample[] samples)
    {
        // if there was error, samples will be null
        if (samples != null)
        {
            Debug.Log("Start:QueryActivitySamplesCompleted: " + samples.Length.ToString());
        }
    }
}
