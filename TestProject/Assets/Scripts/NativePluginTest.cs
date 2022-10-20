using System;
using UnityEngine;
using NativePlugin;
using NativePlugin.HealthData;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        HelloTest.RunHello();
        Debug.Log("DebugLog Test");
        Debug.Log("HealthDataIsAvailable: " + HealthData.IsAvailable().ToString());
        HealthData.RequestAuthCompleted += (granted) =>
        {
            Debug.Log("Start:RequestAuthCompleted: " + granted.ToString());
            if (granted)
            {
                HealthData.QuerySleepSamplesCompleted += (samples) =>
                {
                    Debug.Log("Start:QuerySleepSamplesCompleted: " + samples.Length.ToString());
                };
                HealthData.QuerySleepSamples(
                    new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                    DateTime.Now,
                    100
                );
            }
        };
        HealthData.RequestAuth();
    }
}
