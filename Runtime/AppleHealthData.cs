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
}
