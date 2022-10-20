using System;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;
using NativePlugin.IOS;
using NativePlugin.HealthData.IOS;

namespace NativePlugin.HealthData
{
    public enum SleepType : int
    {
        InBed = 0,
        AsleepUnspecified = 1,
        Awake = 2,
        AsleepCore = 3,
        AsleepDeep = 4,
        AsleepREM = 5,
    }

    public struct SleepSample
    {
        public readonly DateTime StartDate;
        public readonly DateTime EndDate;
        public readonly SleepType Type;

        public SleepSample(DateTime startDate, DateTime endDate, SleepType type)
        {
            StartDate = startDate;
            EndDate = endDate;
            Type = type;
        }
    }

    public class HealthData
    {
        public delegate void RequestAuthCompletedHandler(bool granted);
        public static event RequestAuthCompletedHandler RequestAuthCompleted;

        public delegate void QuerySleepSamplesCompletedHandler(SleepSample[] samples);
        public static event QuerySleepSamplesCompletedHandler QuerySleepSamplesCompleted;

#if UNITY_IOS
        [DllImport("__Internal")]
        private static extern bool iOS_healthDataIsAvailable();

        [DllImport("__Internal")]
        private static extern void iOS_healthDataRequestAuth(
            AppleSuccessCallback<bool> onSuccess,
            AppleErrorCallback onError
        );

        [DllImport("__Internal")]
        private static extern void iOS_healthDataQuerySleepSamples(
            double startDateInSeconds,
            double endDateInSeconds,
            int maxNumSamples,
            AppleSuccessCallback<bool> onSuccess,
            AppleErrorCallback onError
        );

        [DllImport("__Internal")]
        private static extern int iOS_healthDataGetSleepSamplesCount();

        [DllImport("__Internal")]
        private static extern AppleSleepSample iOS_healthDataGetSleepSampleAtIndex(int index);
#endif

        public static bool IsAvailable()
        {
#if UNITY_IOS
            return iOS_healthDataIsAvailable();
#else
            return false;
#endif
        }

        public static void RequestAuth()
        {
#if UNITY_IOS
            iOS_healthDataRequestAuth(AppleOnRequestAuthCompleted, AppleOnRequestAuthFailed);
#else
            Debug.Log("RequestAuth: Unsupported Platform");
#endif
        }

        [MonoPInvokeCallback(typeof(AppleSuccessCallback<bool>))]
        private static void AppleOnRequestAuthCompleted(bool granted)
        {
            Debug.Log("AppleOnRequestAuthCompleted: " + granted);
            RequestAuthCompleted?.Invoke(granted);
        }

        [MonoPInvokeCallback(typeof(AppleErrorCallback))]
        private static void AppleOnRequestAuthFailed(AppleInteropError error)
        {
            // TODO: Handle error?
        }

        public static void QuerySleepSamples(
            DateTime startDate,
            DateTime endDate,
            int maxNumSamples
        )
        {
            double startDateInSeconds = ConvertToUnixTimestamp(startDate);
            double endDateInSeconds = ConvertToUnixTimestamp(endDate);
#if UNITY_IOS
            iOS_healthDataQuerySleepSamples(
                startDateInSeconds,
                endDateInSeconds,
                maxNumSamples,
                AppleOnQuerySleepSamplesCompleted,
                AppleOnQuerySleepSamplesFailed
            );
#else
            Debug.Log("QuerySleepSamples: Unsupported Platform");
#endif
        }

        [MonoPInvokeCallback(typeof(AppleSuccessCallback<bool>))]
        private static void AppleOnQuerySleepSamplesCompleted(bool success)
        {
            Debug.Log("AppleOnQuerySleepSamplesCompleted: " + success);
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
                    Debug.Log(
                        "AppleOnQuerySleepSamplesCompleted: "
                            + startDate
                            + " - "
                            + endDate
                            + " - "
                            + type
                    );
                    res[i] = new SleepSample(startDate, endDate, type);
                }
                QuerySleepSamplesCompleted?.Invoke(res);
            }
            else
            {
                QuerySleepSamplesCompleted?.Invoke(null);
            }
        }

        [MonoPInvokeCallback(typeof(AppleErrorCallback))]
        private static void AppleOnQuerySleepSamplesFailed(AppleInteropError error)
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
}
