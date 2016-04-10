using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;


public class ChatController : MonoBehaviour {
	
	public GUISkin skin;
	
	private Vector2 scrollPosition;
	
	private List<String> messages = new List<String>();
	
	private Rect chatWindow;
	private string userMessage = "";
	
	private bool typingMessage = false;
	private bool sendingMessage = false;
    private NetworkController controller = null;
		
		
	void Start() {
		chatWindow = new Rect(Screen.width-290, Screen.height - 250, 280, 240);
	}


	void OnGUI() {
		GUI.skin = skin;
		
		if (EnterPressed()) {
			if (!typingMessage) {
				 typingMessage = true;
			}
			else {
				// Send message
	   	    	if (userMessage.Length > 0) {
					AddMyChatMessage(userMessage);
					userMessage = "";
				}
				typingMessage = false;
			}
			Event.current.Use();	 
		}	
		
		chatWindow = GUI.Window (1, chatWindow, ShowChatWindow, "Chat");
	}
	
	private bool EnterPressed() {
		return (Event.current.type == EventType.keyDown && Event.current.character == '\n');
	}
	
	void ShowChatWindow(int id) {	
		GUI.SetNextControlName("scroll"); 
		scrollPosition = GUILayout.BeginScrollView (scrollPosition);
		foreach(string message in messages) {
			GUILayout.BeginHorizontal();
			GUILayout.Label(message);
			GUILayout.FlexibleSpace();
			GUILayout.EndHorizontal();
			GUILayout.Space(3);
		}
				
	    GUILayout.EndScrollView();
	   	if (!typingMessage) {
	   		 GUI.FocusControl("scroll");
	   	}
	   	
	   	GUI.SetNextControlName("text"); 
	   	userMessage = GUILayout.TextField(userMessage);
	   	if (typingMessage) {
	   		 GUI.FocusControl("text");
		}
		
		GUILayout.Label("Press Enter to type and again to send");
	}
	
	private void AddMyChatMessage(String message) {
        // just send to plugin, and wait for the message to be broadcast before adding to history
		SendChatMessage(message);
	}
	
	// This method to be called when remote chat message is received
	void AddChatMessage(String message) {
		messages.Add(message);
		scrollPosition.y = 10000000000; // To scroll down the messages window
	}
		
	// Send the chat message to all other users
	private void SendChatMessage(String message) {
        getNetworkController().SendPublicMessage(message);
	}

    private NetworkController getNetworkController()
    {
        if (controller != null)
        {
            return controller;
        }
        else
        {
            //Debug.Log("ChatController is initializing network controller");
            GameObject gameManager = GameObject.Find("_GameManager");
            GameManager gm = (GameManager)gameManager.GetComponent<GameManager>();
            controller = gm.controller;
            return controller;
        }
    }

}
