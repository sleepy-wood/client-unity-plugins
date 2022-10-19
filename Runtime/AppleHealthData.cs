using System;
using System.Runtime.InteropServices;

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

    [StructLayout(LayoutKind.Sequential)]
    public struct AppleSleepSample
    {
        public readonly double startDateInSeconds;
        public readonly double endDateInSeconds;
        public readonly int value;
    }
}
