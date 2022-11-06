using System;
using System.Runtime.InteropServices;

namespace NativePlugin.HealthData.IOS
{
    [StructLayout(LayoutKind.Sequential)]
    public struct AppleSleepSample
    {
        public readonly double startDateInSeconds;
        public readonly double endDateInSeconds;
        public readonly int value;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct AppleActivitySample
    {
        public readonly double dateInSeconds;

        // public readonly bool isMoveMode;
        // public readonly double moveTimeInMinutes;
        // public readonly double moveTimeGoalInMinutes;
        public readonly double activeEnergyBurnedInKcal;
        public readonly double activeEnergyBurnedGoalInKcal;
        public readonly double exerciseTimeInMinutes;
        public readonly double exerciseTimeGoalInMinutes;
        public readonly double standHours;
        public readonly double standHoursGoal;
    }
}
