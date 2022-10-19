using System;
using UnityEngine;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        NativePlugin.RunHello();
        Debug.Log("DebugLog Test");
        Debug.Log("HealthDataIsAvailable: " + NativePlugin.HealthDataIsAvailable().ToString());
        NativePlugin.HealthDataRequestAuthCompleted += (granted) =>
        {
            Debug.Log("Start:HealthDataRequestAuthCompleted: " + granted.ToString());
            if (granted)
            {
                NativePlugin.HealthDataQuerySleepSamplesCompleted += (samples) =>
                {
                    Debug.Log("Start:HealthDataQuerySleepSamplesCompleted: " + samples.Length.ToString());
                };
                NativePlugin.HealthDataQuerySleepSamples(new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), DateTime.Now, 100);
            }
        };
        NativePlugin.HealthDataRequestAuth();
    }
}
