using System;

namespace NativePluginStuff
{
    public delegate void AppleSuccessCallback();
    public delegate void AppleSuccessCallback<T>(T response);
    public delegate void AppleErrorCallback(AppleInteropError error);

    [StructLayout(LayoutKind.Sequential)]
    public struct AppleInteropError
    {
        public readonly int Code;
        public readonly string LocalizedDescription;
    }
}
