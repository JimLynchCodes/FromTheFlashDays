using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class StatusScreen : MonoBehaviour {

    private Vector2 scrollPosition;

    private List<String> messages = new List<String>();

    private Rect logWindow;

	public void Awake() {
		
		// Allow Unity Application to run in background
		Application.runInBackground = true;
	}

    void Start()
    {
        int top = 300;
        logWindow = new Rect(100, top, Screen.width - 200, Screen.height - top - 10);

    }
    
    public void OnGUI()
    {
            logWindow = GUI.Window(1, logWindow, ShowLogWindow, "Log");
	}

    void ShowLogWindow(int id)
    {
        GUI.SetNextControlName("scroll");
        scrollPosition = GUILayout.BeginScrollView(scrollPosition);
        foreach (string message in messages)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label(message);
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            GUILayout.Space(3);
        }

        GUILayout.EndScrollView();
    }


    // this is called to update the log window
    public void UpdateStatusMessage(String message)
    {
        Debug.Log("Status Message= " + message);
        messages.Add(message);
        scrollPosition.y = 10000000000; // To scroll down the messages window
    }
}
