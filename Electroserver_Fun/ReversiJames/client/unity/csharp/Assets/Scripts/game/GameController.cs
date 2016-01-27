using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class GameController : MonoBehaviour {


    private ElectroServer _es;
    private Room room = null;
    private string me;
    private bool started = false;
    private string waitingMessage = "Joining Game";
    private string errorMessage = "";
    private bool inGame = false;
    private bool _isLobbyLevelLoaded = false;
    private LobbyController.AvailGame _gameToJoin;
    private int myColor = -1;
    private bool canClick = false;
    private bool showReturnToLobbyButton = true;

    private Clock clock;
    private Chip[] board;
    private Texture[] tiles;

	// Use this for initialization
	void Start () {
        Application.runInBackground = true; // Let the application be running while the window is not active.
        Debug.Log("GameController starting");

        GameObject sharedES = GameObject.Find("SharedES");
        SharedElectroServer gm = (SharedElectroServer)sharedES.GetComponent<SharedElectroServer>();
        GameObject clockGobj = GameObject.Find("Clock");
        clock = (Clock)clockGobj.GetComponent<Clock>();

        _es = gm.es;
        me = gm.userName;
        _gameToJoin = gm.gameToJoin;

        _es.Engine.JoinRoomEvent += OnJoinRoom;
        _es.Engine.CreateOrJoinGameResponse += OnCreateOrJoinGameResponse;

        /**
         * If you want to add chat in the game, you will need this line
         */
        //_es.Engine.PublicMessageEvent += OnPublicMessage;
        
        _es.Engine.ConnectionClosedEvent += OnConnectionClosedEvent;
        _es.Engine.GenericErrorResponse += onGenericErrorResponse;
        _es.Engine.PluginMessageEvent += onPluginMessageEvent;
        Debug.Log("listeners added");

        started = true;
        initBoard();
        JoinRoom();
    }

    private void initBoard()
    {
        board = new Chip[GameConstants.BOARD_SIZE * GameConstants.BOARD_SIZE];
        for (int ii = 0; ii < board.Length; ii++)
        {
            board[ii] = new Chip(ii, GameConstants.EMPTY);
        }

        tiles = new Texture[4];

        tiles[GameConstants.BLACK] = (Texture)Resources.Load("Black");
        tiles[GameConstants.WHITE] = (Texture)Resources.Load("White");
        tiles[GameConstants.EMPTY] = (Texture)Resources.Load("Empty");
        tiles[GameConstants.LEGAL] = (Texture)Resources.Load("Legal");
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
            pr.PluginName = GameConstants.PLUGIN_NAME;

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
        if (inGame)
        {
            renderGamePanel();
        }
        else
        {
            renderWaitingPanel();
        }

    }

    /**
     * Show game UI
     */
    private void renderGamePanel()
    {
        GUILayout.BeginArea(new Rect(0, 0, 600, 450));
        buildGrid();
        GUILayout.EndArea();
    }

    private void buildGrid()
    {
        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(waitingMessage);
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(errorMessage);
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        int id = 0;

        for (int ii = 0; ii < GameConstants.BOARD_SIZE; ii++)
        {
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            for (int jj = 0; jj < GameConstants.BOARD_SIZE; jj++)
            {
                Chip chip = board[id];
                Texture img = tiles[chip.getColor()];
                if (GUILayout.Button(img, GUILayout.Width(GameConstants.TILE_SIZE)))
                {
                    onTileClicked(id);
                }
                id++;
            }
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
        }

        GUILayout.FlexibleSpace();
        renderReturnToLobbyButton(); 
        GUILayout.EndVertical();
    }

    void onTileClicked(int id)
    {
        if (!canClick)
        {
            return;
        }
        Chip chip = board[id];
        bool available = (chip.getColor() == GameConstants.LEGAL);
        if (!available)
        {
            return;
        }

        sendMoveRequest(chip);

    }

    public void sendMoveRequest(Chip chip)
    {
        EsObject obj = chip.toEsObject();
        obj.setString(GameConstants.ACTION, GameConstants.MOVE_REQUEST);
        sendToPlugin(obj);
    }


    void returnToLobby()
    {
        waitingMessage = "Returning to Lobby";
        errorMessage = "";
        showReturnToLobbyButton = false;
        inGame = false;
        Debug.Log("Returning to Lobby");
        _es.Engine.JoinRoomEvent -= OnJoinRoom;
        _es.Engine.CreateOrJoinGameResponse -= OnCreateOrJoinGameResponse;

        /**
         * If you want to add chat in the game, you will need this line
         */
        //_es.Engine.PublicMessageEvent -= OnPublicMessage;

        _es.Engine.ConnectionClosedEvent -= OnConnectionClosedEvent;
        _es.Engine.GenericErrorResponse -= onGenericErrorResponse;
        _es.Engine.PluginMessageEvent -= onPluginMessageEvent;

        if (null != room)
        {
            LeaveRoomRequest lrr = new LeaveRoomRequest();
            lrr.RoomId = room.Id;
            lrr.ZoneId = room.ZoneId;
            _es.Engine.Send(lrr);
            room = null;
        }

        // Start Coroutine to jump to game scene
        StartCoroutine(PollGameLevelLoaded());

        // Execute level load
        Application.LoadLevel("lobby");

    }

    /*
     * Polls in a routine when game is loaded to instantiate
     * gameflow handler. Handled this way to mimic a handful of 
     * the classes for the AS3 version
     */
    private IEnumerator PollGameLevelLoaded()
    {

        while (!_isLobbyLevelLoaded)
        {

            if (Application.loadedLevelName == "lobby")
            {
                Debug.Log("lobby level loaded");
                waitingMessage = "lobby level loaded";

                _isLobbyLevelLoaded = true;
                StopCoroutine("PollGameLevelLoaded");

                Debug.Log("Attempting to join lobby");
                waitingMessage = "Attempting to join lobby";
            }

            yield return new WaitForSeconds(1.0F);

        }

    }

    private void renderReturnToLobbyButton()
    {
        if (showReturnToLobbyButton)
        {
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("Return to Lobby"))
            {
                returnToLobby();
            }
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
        }
    }

    private void renderWaitingPanel()
    {
        GUILayout.BeginArea(new Rect(0, 0, 600, 200));
        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(waitingMessage);
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(errorMessage);
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        renderReturnToLobbyButton();

        GUILayout.EndVertical();
        GUILayout.EndArea();

    }
	

    void OnApplicationQuit()
    {
        Debug.Log("GameController.OnApplicationQuit invoked");
        if (_es != null)
        {
            try
            {
                _es.Engine.Close();
            }
            catch (Exception)
            {

                Debug.Log("Error calling GameController.OnApplicationQuit");
            }
        }

    }

    private QuickJoinGameRequest getBasicQuickJoinRequest()
    {
        QuickJoinGameRequest qjr = new QuickJoinGameRequest();
        qjr.GameType = GameConstants.PLUGIN_NAME;
        qjr.ZoneName = GameConstants.ZONE_NAME;
        qjr.Hidden = false;
        qjr.Locked = false;
        qjr.CreateOnly = false;

        EsObject initOb = new EsObject();
        initOb.setString(GameConstants.PLAYER_NAME, me);
        initOb.setBoolean(GameConstants.AI_OPPONENT, true);

        qjr.GameDetails = initOb;

        return qjr;
    }

    private void JoinGame(int gameId)
    {
        JoinGameRequest jgr = new JoinGameRequest();
        jgr.GameId = gameId;

        _es.Engine.Send(jgr);
    }


    private void JoinRoom()
    {
        // type of request to send depends on the game to be joined
        QuickJoinGameRequest qjr = getBasicQuickJoinRequest();

        if (_gameToJoin.gameId >= 0)
        {
            JoinGame(_gameToJoin.gameId);
        }
        else if (_gameToJoin.gameId == GameConstants.PIXEL_GAME) 
        {
            qjr.CreateOnly = true;  // make a new game with AI opponent
            qjr.Hidden = true;      // don't let anybody else join it
            _es.Engine.Send(qjr);
        }
        else if (_gameToJoin.gameId == GameConstants.QUICK_JOIN)
        {
            qjr.CreateOnly = false;  // join any game, no AI opponent unless a human isn't found
            EsObject initOb = qjr.GameDetails;
            initOb.setBoolean(GameConstants.AI_OPPONENT, false);
            _es.Engine.Send(qjr);
        }
        else if (_gameToJoin.gameId == GameConstants.CREATE_NEW)
        {
            qjr.CreateOnly = true;  // make a new game and wait for human opponent
            EsObject initOb = qjr.GameDetails;
            initOb.setBoolean(GameConstants.AI_OPPONENT, false);
            initOb.setInteger(GameConstants.COUNTDOWN, GameConstants.COUNTDOWN_SECONDS_FOR_CREATE_NEW_GAME);
            _es.Engine.Send(qjr);
        }
        waitingMessage = "QuickJoinGameRequest sent for Reversi";
        Debug.Log("QuickJoinGameRequest sent for Reversi");

    }

    private void OnJoinRoom(JoinRoomEvent evt)
    {
        Debug.Log("Joined a room!");
        waitingMessage = "Joined a room!";

    	//grab and store the reference to the room you just joined
        room = _es.ManagerHelper.ZoneManager.ZoneById(evt.ZoneId).RoomById(evt.RoomId);
        waitingMessage = "Waiting for game to start";
        inGame = false;  // wait until the game starts to display the board
        sendInitMeRequest();
    }

    private void sendInitMeRequest()
    {
        EsObject obj = new EsObject();
        obj.setString(GameConstants.ACTION, GameConstants.INIT_ME);
        sendToPlugin(obj);
    }

    /**
     * Called when a plugin message arrives.
     * 
     */
    private void onPluginMessageEvent(PluginMessageEvent e)
    {
        if (e.PluginName != GameConstants.PLUGIN_NAME)
        {
            // we aren't interested, don't know how to process it
            return;
        }

        EsObject esob = e.Parameters;
        //trace the EsObject payload; comment this out after debugging finishes!
        //Debug.Log("Plugin event: " + esob.ToString());

        //get the action which determines what we do next
        string action = esob.getString(LobbyConstants.ACTION);

        if (action == GameConstants.START_GAME)
        {
            handleStartGame(esob);
        }
        else if (action == GameConstants.MOVE_RESPONSE)
        {
            handleMoveResponse(esob);
        }
        else if (action == GameConstants.MOVE_EVENT)
        {
            handleMoveEvent(esob);
        }
        else if (action == GameConstants.TURN_TIME_LIMIT)
        {
            handleTurnAnnouncement(esob);
        }
        else if (action == GameConstants.GAME_OVER)
        {
            handleGameOver(esob);
        }
        else if (action == GameConstants.INIT_ME)
        {
            // for game restarts only
            handleGameRestart(esob);
        }
        else
        {
            Debug.Log("Action not handled: " + action);
        }

    }

    public void handleGameRestart(EsObject obj)
    {
        myColor = -1;
        initBoard();
        waitingMessage = "Waiting for game to start";
        errorMessage = "";
        inGame = false;  // wait until the game starts to display the board
        sendInitMeRequest();
    }

    public void handleGameOver(EsObject obj)
    {
        audio.Play();
        canClick = false;
        showReturnToLobbyButton = true;
        String winner = obj.getString(GameConstants.WINNER, "");
        // If we want to display the individual scores, this 
        // unpacks the info and stores it in model for view to get. (JAVA version)
        //        HashMap scoresMap = new HashMap<String, Integer>();
        //        if (obj.variableExists(GameConstants.SCORE)) {
        //            EsObject[] scores = obj.getEsObjectArray(GameConstants.SCORE);
        //            for (EsObject playerObj : scores) {
        //                String name = playerObj.getString(GameConstants.PLAYER_NAME);
        //                int points = playerObj.getInteger(GameConstants.SCORE);
        //                scoresMap.put(name, points);
        //            }
        //            model.setScores(scoresMap);
        //        }

        waitingMessage = "Game Over";
        errorMessage = "Winner: " + winner;
    }


    public void handleStartGame(EsObject obj) {
        inGame = true;
        showReturnToLobbyButton = false;
        EsObject[] chips = obj.getEsObjectArray(GameConstants.CHANGED_CHIPS);
            //for (EsObject chipObj : chips) {
        for (int ii = 0; ii < chips.Length; ii++)
        {
            addOrUpdateOneChip(chips[ii]);
        }
    }

    private void addOrUpdateOneChip(EsObject chipObj)
    {
        int id = chipObj.getInteger(GameConstants.ID);
        bool isBlack = chipObj.getBoolean(GameConstants.COLOR_IS_BLACK);
        int color = GameConstants.BLACK;
        if (!isBlack)
        {
            color = GameConstants.WHITE;
        }
        Chip chip = board[id];
        chip.setColor(color);
        Debug.Log("addOrUpdateOneChip: " + id);
    }

    public void handleTurnAnnouncement(EsObject obj)
    {
        audio.Play();
        String playerName = obj.getString(GameConstants.PLAYER_NAME);
        int seconds = obj.getInteger(GameConstants.TURN_TIME_LIMIT);

        if (null != clock)
        {
            clock.SetTimer(seconds);
        }
        bool isBlack = obj.getBoolean(GameConstants.COLOR_IS_BLACK);
        int[] legalMoves = obj.getIntegerArray(GameConstants.LEGAL_MOVES);

        clearLegalMoves();
        if (playerName == (me))
        {
            // it's my turn!
            if (myColor < 0)
            {
                myColor = GameConstants.BLACK;
                if (!isBlack)
                {
                    myColor = GameConstants.WHITE;
                }
            }
            setLegalMoves(legalMoves);
            canClick = true;
            errorMessage = "";
        }
        else
        {
            canClick = false;
        }

        if (isBlack)
        {
            waitingMessage = playerName + "'s turn: Black";
        } 
        else
        {
            waitingMessage = playerName + "'s turn: White";
        } 

    }

    private void clearLegalMoves()
    {
        for (int ii = 0; ii < board.Length; ii++)
        {
            Chip chip = board[ii];
            if (chip.getColor() == GameConstants.LEGAL)
            {
                chip.setColor(GameConstants.EMPTY);
            }
        }
    }

    private void setLegalMoves(int[] legalMoves)
    {
        for (int ii = 0; ii < legalMoves.Length; ii++)
        {
            Chip chip = board[legalMoves[ii]];
            chip.setColor(GameConstants.LEGAL);
        }
    }

    public void handleMoveResponse(EsObject obj)
    {
        // only happens if there's an error
        String error = obj.getString(GameConstants.ERROR_MESSAGE);
        Debug.Log("handleMoveResponse ERROR: " + error);
        errorMessage = "ERROR: " + error;
    }

    public void handleMoveEvent(EsObject obj) {
        // only happens if it's good
        EsObject[] changedChips = obj.getEsObjectArray(GameConstants.CHANGED_CHIPS, null);
        if (changedChips != null) {
            // update the board
            for (int ii = 0; ii < changedChips.Length; ii++)
            {
                addOrUpdateOneChip(changedChips[ii]);
            }
        }
    }


    public void OnConnectionClosedEvent(ConnectionClosedEvent evt)
    {
        waitingMessage = "Connection to the server has been lost.  Refresh to continue.";
        inGame = false;
        Debug.Log(waitingMessage);
    }

    public void onGenericErrorResponse(GenericErrorResponse evt)
    {
        waitingMessage = evt.ErrorType.ToString();
        showReturnToLobbyButton = true;
        Debug.Log(waitingMessage);
    }

    public void OnCreateOrJoinGameResponse(CreateOrJoinGameResponse evt)
    {
        if (evt.Successful)
        {
            return;     // all is well, will handle the event with the join room event
        }
        waitingMessage = evt.Error.ToString();
        inGame = false;
        Debug.Log(waitingMessage);
        showReturnToLobbyButton = true;
    }
}
