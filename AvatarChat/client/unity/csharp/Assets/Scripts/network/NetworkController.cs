using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class NetworkController : MonoBehaviour {

    public static string PLUGIN_NAME = "AvatarChat";
    public static string EXTENSION_NAME = "AvatarChatExtension";

    private ElectroServer _es;
    private Room room = null;
    private string _userName;
    private bool started = false;
    private int as3_x = -1;
    private int as3_y = -1;
    private PlayerSpawnController playerSpawnController = null;

    // TODO: set up login screen to specify UDP port, then connect using UDP if useUDP is true
    private bool useUDP = false;


    private PlayerSpawnController getPlayerSpawnController()
    {
        if (playerSpawnController == null)
        {
            GameObject gObj = GameObject.Find("NetworkController");
            playerSpawnController = (PlayerSpawnController)gObj.GetComponent<PlayerSpawnController>();

        }
        return playerSpawnController;
    }

    /**
     * Sends formatted EsObjects to the plugin
     */
    public void sendToPlugin(EsObject esob)
    {
        if (room != null && _es != null)
        {
            //build the request
            PluginRequest pr = new PluginRequest();
            pr.Parameters = esob;
            pr.RoomId = room.Id;
            pr.ZoneId = room.ZoneId;
            pr.PluginName = PLUGIN_NAME;

            //send it
            _es.Engine.Send(pr);
        }
    }

    /**
     *  Sends a position update message to the plugin.
     */
    public void sendPositionUpdate(EsObject esob)
    {
        esob.setBoolean(PluginTags.USE_UDP, useUDP);
        sendToPlugin(esob);
    }

	void FixedUpdate() {
		if (started) {
            /*
             * Dispatch events from the Electroserver instance internal event queue.
             * Being in fixed update ensures it occurs in a timely fashion independent
             * of frame rate.
             */
            _es.Engine.Dispatch();
        }
	}
	
	
	// We start working from here
	void Start() {
		Application.runInBackground = true; // Let the application be running while the window is not active.
        Debug.Log("NetworkController starting");

        GameObject gameManager = GameObject.Find("_GameManager");
        GameManager gm = (GameManager)gameManager.GetComponent<GameManager>();
        _es = gm.es;
        _userName = gm.userName;
        gm.controller = this;

        //NOTE: if you modify this example to allow users to leave the scene without quitting the application
        //then you will need to remove the listeners before leaving the scene
        _es.Engine.JoinRoomEvent += OnJoinRoom;
        _es.Engine.PublicMessageEvent += OnPublicMessage;
        _es.Engine.ConnectionClosedEvent += OnConnectionClosedEvent;
        _es.Engine.GenericErrorResponse += onGenericErrorResponse;
        _es.Engine.PluginMessageEvent += onPluginMessageEvent;
        Log("listeners added");


        started = true;
        JoinRoom();
    }

    /**
     * Creates a CreateRoomRequest and sends to the server. If the room already exists the user will be joined to it.
     */
    private void JoinRoom()
    {
        //request used to create a room
        CreateRoomRequest crr = new CreateRoomRequest();
        crr.RoomName = "UnityAvatarChat";
        crr.ZoneName = "chat";

        // create the plugin
        PluginListEntry ple = new PluginListEntry();
        ple.ExtensionName = EXTENSION_NAME;
        ple.PluginHandle = PLUGIN_NAME;
        ple.PluginName = PLUGIN_NAME;

        List<PluginListEntry> pluginList = new List<PluginListEntry>();
        pluginList.Add(ple);

        crr.Plugins = pluginList;

        // turn off events we don't need to reduce number of socket messages
        crr.ReceivingRoomAttributeUpdates = false;
        crr.ReceivingRoomListUpdates = false;
        crr.ReceivingRoomVariableUpdates = false;
        crr.ReceivingUserListUpdates = false;   // will get these from the plugin
        crr.ReceivingUserVariableUpdates = false;
        crr.ReceivingVideoEvents = false;

        // turn on the standard chat filtering 
        crr.UsingLanguageFilter = true;
        crr.UsingFloodingFilter = true;

        //send it
        _es.Engine.Send(crr);

        Log("CreateRoomRequest sent");
    }

	
	// We should unsubscribe all delegates before quitting the application to avoid probleems.
	// Also we should Disconnect from server
	void OnApplicationQuit() {
        Debug.Log("NetworkController.OnApplicationQuit invoked");
        if (_es != null)
        {
            try
            {
                _es.Engine.Close();
            }
            catch (Exception)
            {
                
                Debug.Log("Error calling NetworkController.OnApplicationQuit");
            }
        }
        
	}


    /**
     * Fired when the JoinRoomEvent is received by the client.
     */
    private void OnJoinRoom(JoinRoomEvent evt)
    {
        Log("Joined a room!");

        //grab and store the reference to the room you just joined
        room = _es.ManagerHelper.ZoneManager.ZoneById(evt.ZoneId).RoomById(evt.RoomId);

        SendMessage("SpawnLocalPlayer", _userName);

        // ask plugin for the full user list
        sendUserListRequest();
    }


    
    private void sendUserListRequest()
    {
			EsObject esob = new EsObject();
			esob.setString(PluginTags.ACTION, PluginTags.USER_LIST_REQUEST);
			
			//send to the plugin
			sendToPlugin(esob);

    }

    private void OnPublicMessage(PublicMessageEvent evt)
    {
        string from = evt.UserName;
        string message = evt.Message;
        string hist_msg = from + ": " + message;

        // send chat message to the Chat Controller for display in chat history
        SendMessage("AddChatMessage", hist_msg);

        //Find user object with such Id
        GameObject user = null;

        if (from.Equals(_userName))
        {
            user = GameObject.Find("localPlayer");
        } 
        else
        {
            user = GameObject.Find("remote_" + from);
        }
        //If found - send him bubble message
        if (user)
        {
            //Debug.Log("OnPublicMessage attempting to show bubble");
            user.SendMessage("ShowBubble", message);
        }
        else
        {
            //Debug.Log("OnPublicMessage could not find the game object");
        }

    }

    public void SendPublicMessage(string message)
    {
        PublicMessageRequest request = new PublicMessageRequest();
        request.Message = message;
        request.RoomId = room.Id;
        request.ZoneId = room.ZoneId;

        _es.Engine.Send(request);
    }
	
    /**
     * Called when a plugin message arrives.
     * 
     */
    private void onPluginMessageEvent(PluginMessageEvent e)
    {
        if (e.PluginName != PLUGIN_NAME)
        {
            // we aren't interested, don't know how to process it
            return;
        }

        EsObject esob = e.Parameters;
        //trace the EsObject payload; comment this out after debugging finishes!
        //Log("Plugin event: " + esob.ToString());

        //get the action which determines what we do next
        string action = esob.getString(PluginTags.ACTION);
        if (action == PluginTags.POSITION_UPDATE_EVENT)
        {
            handlePositionUpdateEvent(esob);
        }
        else if (action == PluginTags.AVATAR_STATE_EVENT)
        {
            SendAnimationMessageToRemotePlayerObject(esob);
        }
        else if (action == PluginTags.USER_LIST_RESPONSE)
        {
            handleUserListResponse(esob);
        }
        else if (action == PluginTags.USER_ENTER_EVENT)
        {
            handleUserEnterEvent(esob);
        }
        else if (action == PluginTags.USER_EXIT_EVENT)
        {
            handleUserExitEvent(esob);
        }
        else
        {
            Log("Action not handled: " + action);
        }

    }

    private void handleUserEnterEvent(EsObject esob)
    {
        //Debug.Log("handleUserEnterEvent");
        string name = esob.getString(PluginTags.USER_NAME);
        GameObject obj = GameObject.Find("remote_" + name);
        if (obj == null && !name.Equals(_userName))
        {
            // need to spawn player, pick arbitrary spot and move with first position update
            esob.setInteger(PluginTags.TARGET_X, 110);
            esob.setInteger(PluginTags.TARGET_Y, 150);
            getPlayerSpawnController().UserEnterRoom(esob);

            SendMessage("AddChatMessage", name + " entered the room.");
        }
    }

    private void SendAnimationMessageToRemotePlayerObject(EsObject data)
    {
        string name = data.getString(PluginTags.USER_NAME);
        if (!name.Equals(_userName))
        {  // If it's not myself
            //Find user object with such Id
            GameObject obj = GameObject.Find("remote_" + name);
            if (obj == null)
            {
                Debug.Log("remote_" + name + " not found");
                return;
            }
            else
            {
                // send the remote player animation message
                Debug.Log("send the remote player animation message");
                string anim = data.getString(PluginTags.AVATAR_STATE_EVENT, "");
                if (anim.Length > 0)
                {
                    obj.SendMessage("PlayAnimation", anim);
                }
                else
                {
                    // this could be some other type of AVATAR_STATE_EVENT
                    // such as the one that the plugin sends that changes the 
                    // emotion of the user, for the AS3 clients.  Unity clients 
                    // currently ignore these emotion changes.
                }
            }
        }
    }

    private void handlePositionUpdateEvent(EsObject esob)
    {
        //Debug.Log("handlePositionUpdateEvent");
        string name = esob.getString(PluginTags.USER_NAME);
        if (name.Equals(_userName))
        {
            // my own position
            // unless the plugin is likely to enforce a position on me, just ignore this
        }
        else {
            // remote player position
            GameObject obj = GameObject.Find("remote_" + name);
            if (obj == null)
            {
                Debug.Log("remote_" + name + " not found");
                return;
            }
            else
            {
                // move the remote player to match
                //Debug.Log("asking remote player to move");
                obj.SendMessage("ReceiveTransform", esob);

            }
        }

    }

    private void handleUserExitEvent(EsObject esob)
    {
        //Debug.Log("handleUserExitEvent");
        string name = esob.getString(PluginTags.USER_NAME);
        getPlayerSpawnController().UserLeaveRoom(name);
        SendMessage("AddChatMessage", name + " left the room.");
    }

    private void handleUserListResponse(EsObject esob)
    {
        //Debug.Log("handleUserListResponse");
        EsObject[] players = esob.getEsObjectArray(PluginTags.USER_STATE);
        getPlayerSpawnController().SpawnRemotePlayers(players, _userName);
    }

    private void ForceSendTransform()
    {
        //Log("ForceSendTransform invoked");
            // Find local player object
            GameObject user = GameObject.Find("localPlayer");
            // Send him message
            if (user) user.SendMessage("ForceSendTransform");
    }


    private void Log(String message)
    {
        Debug.Log(message);

        // if you want to show all the log messages in the chat history window
        // uncomment the line below.  You would need to add a scroll bar though.
        //SendMessage("AddChatMessage", message);

    
    }

    public void OnConnectionClosedEvent(ConnectionClosedEvent evt)
    {
        string msg = "Connection to the server has been lost.  Refresh to continue.";
        SendMessage("AddChatMessage", msg);
        Log(msg);
    }

    public void onGenericErrorResponse(GenericErrorResponse evt)
    {
        string msg = evt.ErrorType.ToString();
        SendMessage("AddChatMessage", msg);
        Log(msg);
    }

}
