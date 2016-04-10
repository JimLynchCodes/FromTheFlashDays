using UnityEngine;
using System.Collections;
using System;

using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class AnimationSynchronizer : MonoBehaviour {
	
	private bool sendMode = false;
	private bool receiveMode = false;
	private string lastState = "idle";
    private NetworkController controller;

    NetworkController getNetworkController()
    {
        if (controller == null)
        {
            GameObject gObj = GameObject.Find("NetworkController");
            controller = (NetworkController)gObj.GetComponent<NetworkController>();
        }
        return controller;
    }
			
	// We call it on local player to start sending animation messages
	void StartSending() {
		sendMode = true;
		receiveMode = false;		
	}
	
	// We call it on remote player model to start receiving animation messages
	void StartReceiving() {
		sendMode = false;
		receiveMode = true;
		animation.Play(lastState);
	}

	
	void PlayAnimation(string message) {
        if (message.Equals("jump_pose"))
        {
            Debug.Log("PlayAnimation: " + message);
            Debug.Log("sendMode? " + sendMode);
            Debug.Log("receiveMode? " + receiveMode);
            SendMessage("ApplyJumping");
        }
		if (sendMode) {
			//if the new state differs, send animation message to other clients
			if (lastState!=message) {
				lastState = message;
				SendAnimationMessage(message);
			}			
		}
		else if (receiveMode) {
			// Just play this animation
			animation.CrossFade(message);	
		}
	}	
	
	void SendAnimationMessage(string message) {
        EsObject data = new EsObject();
        data.setString(PluginTags.ACTION, PluginTags.AVATAR_STATE_REQUEST);
        data.setString(PluginTags.AVATAR_STATE_EVENT, message);
        getNetworkController().sendToPlugin(data);
	}
}
