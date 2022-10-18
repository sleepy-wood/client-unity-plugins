using System.Runtime.InteropServices;

namespace NativePluginStuff {
    [StructLayout(LayoutKind.Sequential)]
    public struct AppleInteropError
    {
        public int Code;
        public string LocalizedDescription;
        public string TaskId;
    }
}
