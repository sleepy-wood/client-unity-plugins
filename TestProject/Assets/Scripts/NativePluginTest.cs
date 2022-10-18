using UnityEngine;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        NativePlugin.RunHello();
        Debug.Log("DebugLog Test");
        Debug.Log("HealthDataIsAvailable: " + NativePlugin.HealthDataIsAvailable().ToString());
        NativePlugin.HealthDataRequestAuth();
	}
}
