using System.Runtime.InteropServices;
using UnityEngine;

public class NativePlugin
{
#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern void iOS_runHello();
#endif

    public static void runHello()
    {
#if UNITY_IOS
        iOS_runHello();
#else
        Debug.Log("No iOS Device Found");
#endif
    }
}
