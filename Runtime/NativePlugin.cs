using System.Runtime.InteropServices;
using UnityEngine;
using NativePluginStuff;
using AOT;

public class NativePlugin
{
    public delegate void HealthDataRequestAuthCompletedHandler(bool granted);
    public static event HealthDataRequestAuthCompletedHandler HealthDataRequestAuthCompleted;

#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern void iOS_runHello();

    [DllImport("__Internal")]
    private static extern bool iOS_healthDataIsAvailable();

    [DllImport("__Internal")]
    private static extern void iOS_healthDataRequestAuth(AppleSuccessCallback<bool> onSuccess, AppleErrorCallback onError);
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
    private static void AppleOnHealthDataRequestAuthErrored(AppleInteropError error)
    {
    }
}
