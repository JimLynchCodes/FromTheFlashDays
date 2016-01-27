using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class LobbyController : MonoBehaviour {


    private ElectroServer _es;
    private Room room = null;
    //private string _userName;
    private bool started = false;
    private string waitingMessage = "Joining lobby";
    private bool inLobby = false;
    private bool _isGameLevelLoaded = false;
    private AvailGame[] playerGrid;
    private AvailGame[] fixedGrid;

	// Use this for initialization
	void Start () {
        Application.runInBackground = true; // Let the application be running while the window is not active.
        Debug.Log("LobbyController starting");
        initGrids();

        GameObject sharedES = GameObject.Find("SharedES");
        SharedElectroServer gm = (SharedElectroServer)sharedES.GetComponent<SharedElectroServer>();

        _es = gm.es;
        //_userName = gm.userName;

        _es.Engine.JoinRoomEvent += OnJoinRoom;

        /**
         * If you want to add chat in the lobby, you will need this line
         */
        //_es.Engine.PublicMessageEvent += OnPublicMessage;
        
        _es.Engine.ConnectionClosedEvent += OnConnectionClosedEvent;
        _es.Engine.GenericErrorResponse += onGenericErrorResponse;
        _es.Engine.PluginMessageEvent += onPluginMessageEvent;
        Debug.Log("listeners added");

        started = true;
        JoinRoom();
	}

    private void initGrids()
    {
        playerGrid = new AvailGame[LobbyConstants.NUM_ROWS] ;
        for (int i = 0; i < LobbyConstants.NUM_ROWS; i++)
        {
            playerGrid[i] = new AvailGame();
        }

        fixedGrid = new AvailGame[LobbyConstants.NUM_FIXED_ROWS] ;
        for (int i = 0; i < LobbyConstants.NUM_FIXED_ROWS; i++)
        {
            fixedGrid[i] = new AvailGame();
        }

        AvailGame botGame = fixedGrid[0];
        botGame.setAI();

        AvailGame quickGame = fixedGrid[1];
        quickGame.setQuickJoin();

        AvailGame createGame = fixedGrid[2];
        createGame.setCreateNew();
    }

    private void clearGames()
    {
        for (int i = 0; i < LobbyConstants.NUM_ROWS; i++)
        {
            playerGrid[i].clear();
        }
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
            pr.PluginName = LobbyConstants.PLUGIN_NAME;

            //send it
            _es.Engine.Send(pr);
        }
    }

    void FixedUpdate()
    {
        if (started)
        {
            /*
             * Dispatch events from the Electroserver instance internal event queue.
             * Being in fixed update ensures it occurs in a timely fashion independent
             * of frame rate.
             */
            _es.Engine.Dispatch();
        }
    }

    public void OnGUI()
    {
        if (inLobby)
        {
            renderLobbyPanel();
        }
        else
        {
            renderWaitingPanel();
        }

    }

    /**
     * Show buttons for each game that is available.
     */ 
    private void renderLobbyPanel()
    {
        GUILayout.BeginArea(new Rect(100, 20, 200, 600));
        buildGrid();
        GUILayout.EndArea();
    }

    private void buildGrid()
    {
        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();
        GUILayout.Label(waitingMessage);
        for (int ii = 0; ii < LobbyConstants.NUM_ROWS; ii++)
        {
            AvailGame ag = playerGrid[ii];
            if (ag.gameId >= 0)
            {
                if (GUILayout.Button(ag.name))
                {
                    attemptToJoinGame(ag);
                }
            }
        }
        for (int ii = 0; ii < LobbyConstants.NUM_FIXED_ROWS; ii++)
        {
            AvailGame ag = fixedGrid[ii];
            if (GUILayout.Button(ag.name))
            {
                attemptToJoinGame(ag);
            }
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndVertical();
    }


    void removeListeners()
    {
        _es.Engine.JoinRoomEvent -= OnJoinRoom;
        //_es.Engine.PublicMessageEvent -= OnPublicMessage;
        _es.Engine.ConnectionClosedEvent -= OnConnectionClosedEvent;
        _es.Engine.GenericErrorResponse -= onGenericErrorResponse;
        _es.Engine.PluginMessageEvent -= onPluginMessageEvent;
    }

    void attemptToJoinGame(AvailGame ag)
    {
        waitingMessage = "User clicked " + ag.name;
        removeListeners();
        inLobby = false;
        Debug.Log("User clicked " + ag.name);
        // save the info about the game to be joined
        GameObject sharedES = GameObject.Find("SharedES");
        SharedElectroServer gm = (SharedElectroServer)sharedES.GetComponent<SharedElectroServer>();
        gm.gameToJoin = ag;

        // leave the Lobby room, but don't wait for the event about it
        LeaveRoomRequest lrr = new LeaveRoomRequest();
        lrr.ZoneId = room.ZoneId;
        lrr.RoomId = room.Id;

        _es.Engine.Send(lrr);
        room = null;

        // Start Coroutine to jump to game scene
        StartCoroutine(PollGameLevelLoaded());

        // Execute level load
        Application.LoadLevel("game");
    }

    /*
     * Polls in a routine when game is loaded to instantiate
     * gameflow handler. Handled this way to mimic a handful of 
     * the classes for the AS3 version
     */
    private IEnumerator PollGameLevelLoaded()
    {

        while (!_isGameLevelLoaded)
        {

            if (Application.loadedLevelName == "game")
            {
                Debug.Log("game level loaded");
                waitingMessage = "game level loaded";

                _isGameLevelLoaded = true;
                StopCoroutine("PollGameLevelLoaded");

                Debug.Log("Attempting to join game");
                waitingMessage = "Attempting to join game";
            }

            yield return new WaitForSeconds(1.0F);

        }

    }

    private void renderWaitingPanel()
    {
        GUI.Label(new Rect(100, 116, 400, 40), waitingMessage);
    }
	

    void OnApplicationQuit()
    {
        Debug.Log("LobbyController.OnApplicationQuit invoked");
        if (_es != null)
        {
            try
            {
                _es.Engine.Close();
            }
            catch (Exception)
            {

                Debug.Log("Error calling LobbyController.OnApplicationQuit");
            }
        }

    }


    private void JoinRoom()
    {
        //request used to create a room
		QuickJoinGameRequest qjr = new QuickJoinGameRequest();
		qjr.GameType = LobbyConstants.PLUGIN_NAME;
		qjr.ZoneName = LobbyConstants.ZONE_NAME;
		qjr.Hidden = false;
		qjr.Locked = false;
		qjr.CreateOnly = false;
		
		EsObject initOb = new EsObject();
		
		qjr.GameDetails = initOb;
		
		_es.Engine.Send(qjr);

        waitingMessage = "QuickJoinGameRequest sent for lobby";

        Debug.Log("QuickJoinGameRequest sent for ReversiLobby");
    }

    private void OnJoinRoom(JoinRoomEvent evt)
    {
        Debug.Log("Joined a room!");
        waitingMessage = "Joined a room!";

        string descript = evt.RoomDescription;
        if (descript == LobbyConstants.PLUGIN_NAME)
        {
			//grab and store the reference to the room you just joined, IF it is a lobby room
            room = _es.ManagerHelper.ZoneManager.ZoneById(evt.ZoneId).RoomById(evt.RoomId);
            waitingMessage = "REVERSI LOBBY";
            inLobby = true;
        }
    }

    /**
     * Called when a plugin message arrives.
     * 
     */
    private void onPluginMessageEvent(PluginMessageEvent e)
    {
        if (e.PluginName != LobbyConstants.PLUGIN_NAME)
        {
            // we aren't interested, don't know how to process it
            return;
        }

        EsObject esob = e.Parameters;
        //trace the EsObject payload; comment this out after debugging finishes!
        //Debug.Log("Plugin event: " + esob.ToString());

        //get the action which determines what we do next
        string action = esob.getString(LobbyConstants.ACTION);
        if (action == LobbyConstants.GAMES_FOUND)
        {
            handleGamesFoundEvent(esob);
        }
        else if (action == LobbyConstants.NO_GAMES_FOUND)
        {
            handleNoGamesFoundEvent();
        }
        else
        {
            Debug.Log("Action not handled: " + action);
        }

    }

    void handleGamesFoundEvent(EsObject esob)
    {
        EsObject[] esobs = esob.getEsObjectArray(LobbyConstants.GAMES_FOUND);
        for (int ii = 0; ii < LobbyConstants.NUM_ROWS; ii++)
        {
            AvailGame ag = playerGrid[ii];
            if (ii < esobs.Length)
            {
                EsObject obj = esobs[ii];
                ag.name = obj.getString(LobbyConstants.PLAYER_NAME);
                ag.gameId = obj.getInteger(LobbyConstants.ID);
            }
            else
            {
                ag.clear();
            }
        }
    }

    void handleNoGamesFoundEvent()
    {
        clearGames();
    }

    public void OnConnectionClosedEvent(ConnectionClosedEvent evt)
    {
        waitingMessage = "Connection to the server has been lost.  Refresh to continue.";
        inLobby = false;
        Debug.Log(waitingMessage);
    }

    public void onGenericErrorResponse(GenericErrorResponse evt)
    {
        waitingMessage = evt.ErrorType.ToString();
        inLobby = false;
        Debug.Log(waitingMessage);
    }


    public class AvailGame 
    {
        public int gameId = LobbyConstants.PIXEL_GAME;
        public string name = "";

        public void clear()
        {
            gameId = LobbyConstants.PIXEL_GAME;
            name = "";
        }

        public void setAI()
        {
            name = LobbyConstants.AI_NAME;
            gameId = LobbyConstants.PIXEL_GAME;
        }

        public void setQuickJoin()
        {
            name = LobbyConstants.QUICK_JOIN_NAME;
            gameId = LobbyConstants.QUICK_JOIN;
        }

        public void setCreateNew()
        {
            name = LobbyConstants.CREATE_NEW_NAME;
            gameId = LobbyConstants.CREATE_NEW;
        }

    }

}
