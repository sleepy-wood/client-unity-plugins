using System.Runtime.InteropServices;
using UnityEngine;
using NativePluginStuff;
using AOT;

public class NativePlugin
{
    public delegate void HealthDataRequestAuthCompletedHandler(bool granted);
    public static event HealthDataRequestAuthCompletedHandler HealthDataRequestAuthCompleted;

    public delegate void HealthDataRequestSleepSamplesCompletedHandler(SleepSample[]? samples);
    public static event HealthDataRequestSleepSamplesCompletedHandler HealthDataRequestSleepSamplesCompleted;

#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern void iOS_runHello();

    [DllImport("__Internal")]
    private static extern bool iOS_healthDataIsAvailable();

    [DllImport("__Internal")]
    private static extern void iOS_healthDataRequestAuth(AppleSuccessCallback<bool> onSuccess, AppleErrorCallback onError);

    [DllImport("__Internal")]
    private static extern void iOS_healthDataQuerySleepSamples(double startDateInSeconds, double endDateInSeconds, int maxNumSamples, AppleSuccessCallback<bool> onSuccess, AppleErrorCallback onError);

    [DllImport("__Internal")]
    private static extern int iOS_healthDataGetSleepSamplesCount();

    [DllImport("__Internal")]
    private static extern AppleSleepSample iOS_healthDataGetSleepSampleAtIndex(int index);
#endif

    public static void RunHello()
    {
#if UNITY_IOS
        iOS_runHello();
#else
        Debug.Log("RunHello: No iOS Device Found");
#endif
    }

    public static bool HealthDataIsAvailable()
    {
#if UNITY_IOS
        return iOS_healthDataIsAvailable();
#else
        return false;
#endif
    }

    public static void HealthDataRequestAuth()
    {
#if UNITY_IOS
        iOS_healthDataRequestAuth(AppleOnHealthDataRequestAuthCompleted, AppleOnHealthDataRequestAuthErrored);
#else
        Debug.Log("HealthDataRequestAuth: No iOS Device Found");
#endif
    }

    [MonoPInvokeCallback(typeof(AppleSuccessCallback<bool>))]
    private static void AppleOnHealthDataRequestAuthCompleted(bool granted)
    {
        Debug.Log("AppleOnHealthDataRequestAuthCompleted: " + granted);
        HealthDataRequestAuthCompleted?.Invoke(granted);
    }

    [MonoPInvokeCallback(typeof(AppleErrorCallback))]
    private static void AppleOnHealthDataRequestAuthFailed(AppleInteropError error)
    {
        // TODO: Handle error?
    }

    public static void HealthDataQuerySleepSamples(DateTime startDate, DateTime endDate, int maxNumSamples)
    {
        double startDateInSeconds = ConvertToUnixTimestamp(startDate);
        double endDateInSeconds = ConvertToUnixTimestamp(endDate);
#if UNITY_IOS
        iOS_healthDataQuerySleepSamples(startDateInSeconds, endDateInSeconds, maxNumSamples, AppleOnHealthDataQuerySleepSamplesCompleted, AppleOnHealthDataQuerySleepSamplesFailed);
#else
        Debug.Log("HealthDataQuerySleepSamples: No iOS Device Found");
#endif
    }

    [MonoPInvokeCallback(typeof(AppleSuccessCallback<bool>))]
    private static void AppleOnHealthDataQuerySleepSamplesCompleted(bool success)
    {
        Debug.Log("AppleOnHealthDataQuerySleepSamplesCompleted");
        if (success)
        {
            int numSamples = iOS_healthDataGetSleepSamplesCount();
            SleepSample[] res = new SleepSample[numSamples];
            for (int i = 0; i < numSamples; i++)
            {
                AppleSleepSample sample = iOS_healthDataGetSleepSampleAtIndex(i);
                DateTime startDate = ConvertFromUnixTimestamp(sample.startDateInSeconds);
                DateTime endDate = ConvertFromUnixTimestamp(sample.endDateInSeconds);
                SleepType type = (SleepType)sample.value;
                Debug.Log("AppleOnHealthDataQuerySleepSamplesCompleted: " + startDate + " - " + endDate + " - " + type);
                res[i] = new SleepSample(startDate, endDate, type);
            }
            HealthDataQuerySleepSamplesCompleted?.Invoke(res);
        }
        else
        {
            HealthDataQuerySleepSamplesCompleted?.Invoke(null);
        }
    }

    [MonoPInvokeCallback(typeof(AppleErrorCallback))]
    private static void AppleOnHealthDataQuerySleepSamplesFailed(AppleInteropError error)
    {
        // TODO: Handle error?
    }

    public static DateTime ConvertFromUnixTimestamp(double timestamp)
    {
        DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        return origin.AddSeconds(timestamp);
    }

    public static double ConvertToUnixTimestamp(DateTime date)
    {
        DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        TimeSpan diff = date.ToUniversalTime() - origin;
        return diff.TotalSeconds;
    }
}
