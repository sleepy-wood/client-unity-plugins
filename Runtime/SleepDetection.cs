using System;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;

namespace NativePlugin.SleepDetection
{
    public enum SleepStatus : int
    {
        Unknown = -1,
        Awake = 0,
        Asleep = 1,
    }

    public static class SleepDetection
    {
#if UNITY_IOS
        [DllImport("__Internal")]
        private static extern bool iOS_sleepDetectionIsAvailable();

        [DllImport("__Internal")]
        private static extern int iOS_sleepDetectionDetectSleep();
#endif

        public static bool IsAvailable()
        {
#if UNITY_IOS
            return iOS_sleepDetectionIsAvailable();
#else
            Debug.Log("SleepDetection.IsAvailable: Unsupported Platform");
            return true;
#endif
        }

        public static SleepStatus DetectSleep()
        {
#if UNITY_IOS
            return (SleepStatus)iOS_sleepDetectionDetectSleep();
#else
            Debug.Log("SleepDetection.DetectSleep: Unsupported Platform");
            return SleepStatus.Awake;
#endif
        }
    }
}
