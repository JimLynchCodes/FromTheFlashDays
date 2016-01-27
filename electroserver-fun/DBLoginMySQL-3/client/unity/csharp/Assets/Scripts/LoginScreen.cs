using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LoginScreen : MonoBehaviour {

    private string host = "127.0.0.1";
    private string port = "9899";

	// User Information
	private string _userName = "";
    private string _password = "";
	
	public void Awake() {
		
		// Allow Unity Application to run in background
		Application.runInBackground = true;
	}
	
	public void OnGUI() {
			renderLoginPanel();
	}

    private void onSubmit()
    {
        GameObject gObj = GameObject.Find("NetworkController");
        NetworkController controller = (NetworkController)gObj.GetComponent<NetworkController>();
        controller.doConnectAndLogin(_userName, _password, host, port);
    }
	
	private void renderLoginPanel() {
        int labelX = 100;
        int textfieldX = 200;

        GUI.Label(new Rect(labelX, 116, 100, 20), "Username: ");
        _userName = GUI.TextField(new Rect(textfieldX, 116, 200, 20), _userName, 25);

        GUI.Label(new Rect(labelX, 146, 100, 20), "Password: ");
        _password = GUI.TextField(new Rect(textfieldX, 146, 200, 20), _password, 25);

        GUI.Label(new Rect(labelX, 176, 100, 20), "Host: ");
        host = GUI.TextField(new Rect(textfieldX, 176, 200, 20), host, 25);

        GUI.Label(new Rect(labelX, 206, 100, 20), "Port: ");
        port = GUI.TextField(new Rect(textfieldX, 206, 200, 20), port, 25);

        if (GUI.Button(new Rect(textfieldX, 236, 100, 24), "Login"))
        {
			try {
                onSubmit();
			} catch (Exception ex){
			
				Debug.Log(ex.ToString());
			
			}
		}
		
	}
	
}
