using UnityEngine;

public class NativePluginTest : MonoBehaviour
{
    void Start()
    {
        NativePlugin.RunHello();
        Debug.Log("DebugLog Test");
        Debug.Log("HealthDataIsAvailable: " + NativePlugin.HealthDataIsAvailable().ToString());
        Debug.Log("HealthDataRequestAuth: " + NativePlugin.HealthDataRequestAuth().ToString());
	}
}
