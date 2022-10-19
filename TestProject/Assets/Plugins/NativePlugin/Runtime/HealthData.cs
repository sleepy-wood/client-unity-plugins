using System;

namespace NativePluginStuff
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
}
