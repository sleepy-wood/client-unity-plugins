using System;

namespace NativePluginStuff
{
    public delegate void SuccessCallback();
    public delegate void SuccessCallback<T>(T response);
    public delegate void ErrorCallback(AppleInteropError error);
}
