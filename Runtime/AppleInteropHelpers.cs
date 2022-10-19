using System;

namespace NativePluginStuff
{
    public delegate void AppleSuccessCallback();
    public delegate void AppleSuccessCallback<T>(T response);
    public delegate void AppleErrorCallback(AppleInteropError error);

    [StructLayout(LayoutKind.Sequential)]
    public struct AppleInteropError
    {
        public int Code;
        public string LocalizedDescription;
        public string TaskId;
    }
}
