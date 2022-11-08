using System;
using System.Collections.Generic;
using UnityEngine;

namespace NativePlugin.HealthData.Mock
{
    [Serializable]
    public struct MockSleepSample
    {
        public readonly double startDateInSeconds;
        public readonly double endDateInSeconds;
        public readonly int value;
    }

    [Serializable]
    public struct MockActivitySample
    {
        public readonly double dateInSeconds;

        // public readonly bool isMoveMode;
        // public readonly double moveTimeInMinutes;
        // public readonly double moveTimeGoalInMinutes;
        public readonly double activeEnergyBurnedInKcal;
        public readonly double activeEnergyBurnedGoalInKcal;
        public readonly int exerciseTimeInMinutes;
        public readonly int exerciseTimeGoalInMinutes;
        public readonly int standHours;
        public readonly int standHoursGoal;
    }

    // https://stackoverflow.com/questions/36239705/serialize-and-deserialize-json-and-json-array-in-unity
    public static class JsonHelper
    {
        public static T[] FromJson<T>(string json)
        {
            json = "{\"Items\":" + json + "}";
            Wrapper<T> wrapper = JsonUtility.FromJson<Wrapper<T>>(json);
            return wrapper.Items;
        }

        [Serializable]
        private class Wrapper<T>
        {
            public T[] Items;
        }
    }

    public static class MockHealthData
    {
        public static bool IsAvailable()
        {
            return true;
        }

        public static bool RequestAuth()
        {
            return true;
        }

        public static SleepSample[] QuerySleepSamples(
            DateTime startDate,
            DateTime endDate,
            int maxNumSamples
        )
        {
            TextAsset mockSleepJson = Resources.Load<TextAsset>("mockSleep");
            MockSleepSample[] mockSleepSamples = JsonHelper.FromJson<MockSleepSample>(
                mockSleepJson.text
            );
            List<SleepSample> sleepSamples = new List<SleepSample>();
            for (int i = 0; i < mockSleepSamples.Length; i++)
            {
                MockSleepSample sample = mockSleepSamples[i];
                DateTime sDate = HealthUtils.ConvertFromUnixTimestamp(sample.startDateInSeconds);
                DateTime eDate = HealthUtils.ConvertFromUnixTimestamp(sample.endDateInSeconds);
                SleepType type = (SleepType)sample.value;
                if (sDate >= startDate && eDate <= endDate)
                {
                    sleepSamples.Add(new SleepSample(sDate, eDate, type));
                }
                if (sleepSamples.Count >= maxNumSamples)
                {
                    break;
                }
            }
            return sleepSamples.ToArray();
        }

        public static ActivitySample[] QueryActivitySamples(DateTime startDate, DateTime endDate)
        {
            TextAsset mockActivityJson = Resources.Load<TextAsset>("mockActivity");
            MockActivitySample[] mockActivitySamples = JsonHelper.FromJson<MockActivitySample>(
                mockActivityJson.text
            );
            List<ActivitySample> activitySamples = new List<ActivitySample>();
            for (int i = 0; i < mockActivitySamples.Length; i++)
            {
                MockActivitySample sample = mockActivitySamples[i];
                DateTime date = HealthUtils.ConvertFromUnixTimestamp(sample.dateInSeconds);
                if (date >= startDate && date <= endDate)
                {
                    activitySamples.Add(
                        new ActivitySample(
                            date,
                            sample.activeEnergyBurnedInKcal,
                            sample.activeEnergyBurnedGoalInKcal,
                            sample.exerciseTimeInMinutes,
                            sample.exerciseTimeGoalInMinutes,
                            sample.standHours,
                            sample.standHoursGoal
                        )
                    );
                }
            }
            return activitySamples.ToArray();
        }
    }
}
