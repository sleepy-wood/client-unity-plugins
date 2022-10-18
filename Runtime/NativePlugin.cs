using System.Runtime.InteropServices;
using UnityEngine;

public class NativePlugin
{
#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern void iOS_runHello();

    [DllImport("__Internal")]
    private static extern bool iOS_healthDataIsAvailable();

    [DllImport("__Internal")]
    private static extern void iOS_healthDataRequestAuth();
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
        iOS_healthDataRequestAuth();
#else
        Debug.Log("HealthDataRequestAuth: No iOS Device Found");
#endif
    }
}
