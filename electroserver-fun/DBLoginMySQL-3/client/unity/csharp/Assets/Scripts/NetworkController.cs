using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class NetworkController : MonoBehaviour {

    public static string PLUGIN_NAME = "DatabasePlugin";

    private ElectroServer _es;

    public ElectroServer es
    {
        get { return _es; }
    }

    public string userName
    {
        get { return _userName; }
    }

    private string _userName;
    private string _password;

    // Server Information
    private string serverURL;
    private int serverPort;

    private bool started = false;
    private bool _isGameLevelLoaded;

    public void Awake()
    {
        Log("NetworkController Awake");

        // Allow Unity Application to run in background
        Application.runInBackground = true;

        /* 
         * Init ES and instruct ES that events will be dispatched manually
         * (which is important for Unity based project communications)
         */
        _es = new ElectroServer();
        _es.Engine.Queueing = EsEngine.QueueDispatchType.External;

        /*
         * Register event listeners for ES messaging
         */
        _es.Engine.ConnectionResponse += OnConnect;
        _es.Engine.LoginResponse += OnLogin;
        _es.Engine.PluginMessageEvent += onPluginMessageEvent;
        Log("listeners added");


        started = true;
        _isGameLevelLoaded = false;

        // Set default username
        _userName = "";
        serverURL = "127.0.0.1";
        serverPort = 9899;
    }

    public void doAddToRank(string amount)
    {
        int delta = Convert.ToInt32(amount);
        EsObject esob = new EsObject();
        esob.setString(PluginTags.ACTION, PluginTags.ADD_TO_RANK);
        esob.setInteger(PluginTags.ADD_TO_RANK, delta);

        sendToPlugin(esob);

    }

    public void doGetRank()
    {
        EsObject esob = new EsObject();
        esob.setString(PluginTags.ACTION, PluginTags.GET_RANK);

        sendToPlugin(esob);

    }

    public void doConnectAndLogin(string username, string password, string host, string port)
    {
        _userName = username;
        _password = password;
        serverURL = host;
        serverPort = Convert.ToInt32(port);

        // connect to ES5
        try
        {
            Log("Connecting to " + serverURL + ":" + port);

            log4net.Config.BasicConfigurator.Configure();

            #if UNITY_WEBPLAYER
                // Only set this for the webplayer, it breaks pc standalone
                // See http://answers.unity3d.com/questions/25122/ for details
                Security.PrefetchSocketPolicy(serverURL, serverPort);
            #endif

            /* 
             * Creates a server and server connection
             * passes server to ES for handling with logic
             * above for connection response.
             */
            Server server = new Server("default");
            server.AddAvailableConnection(new AvailableConnection(serverURL, serverPort, AvailableConnection.TransportType.BinaryTCP));
            _es.Engine.AddServer(server);
            _es.Engine.Connect();

        }
        catch (Exception ex)
        {

            Log(ex.ToString());

        }
    }

    void OnApplicationQuit()
    {
        Log("OnApplicationQuit invoked");
        if (_es != null)
        {
            try
            {
                _es.Engine.Close();
            }
            catch (Exception)
            {

                Log("Error calling OnApplicationQuit");
            }
        }

    }

    /*
     * This is the connection response handler from ES
     * it determines whether success or not and fires off
     * a login request is successful
     */
    private void OnConnect(ConnectionResponse response)
    {

        if (response.Successful)
        {

            Log("Connected");

            // Build login request properties
            LoginRequest loginRequest = new LoginRequest();

            loginRequest.UserName = _userName;
            loginRequest.Password = _password;
            Log("Sending login request");

            // Send to ES for request obj
            _es.Engine.Send(loginRequest);

        }
        else
        {

            Log("Connection Failed");

        }

    }

    /*
     * This is the login response handler from ES
     * It checks for success and if success performs
     * next step of game logic. For this example it is
     * loading a new scene where the game will happen
     */
    private void OnLogin(LoginResponse response)
    {
        EsObjectRO obj = response.EsObject;
        EsObject esob = new EsObject();
        esob.addAll(obj);
        if (esob.variableExists("Status"))
        {
            Log("LoginResponse status: " + esob.getString("Status"));
        }

        if (response.Successful)
        {

            Log("Login Successful");

            // Start Coroutine to jump to game scene
            StartCoroutine(PollGameLevelLoaded());

            // Execute level load
            Application.LoadLevel("game");


        }
        else
        {
            Log("Login Failed: " + response.Error);
        }

    }
    
    /**
     * Sends formatted EsObjects to the plugin
     */
    public void sendToPlugin(EsObject esob)
    {
        if (_es != null)
        {
            //build the request
            PluginRequest pr = new PluginRequest();
            pr.Parameters = esob;
            // since this is a server level plugin, we do not 
            // set the roomId and zoneId.
            pr.PluginName = PLUGIN_NAME;

            //send it
            _es.Engine.Send(pr);
        }
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
        Log("Plugin event: " + esob.ToString());

        //get the action which determines what we do next
        string action = esob.getString(PluginTags.ACTION);
        if (action == PluginTags.ADD_TO_RANK || action == PluginTags.GET_RANK)
        {
            updateDisplay(esob);
        }
        else
        {
            Log("Action not handled: " + action);
        }

    }

    private void updateDisplay(EsObject esob)
    {
        int rank = esob.getInteger(PluginTags.GET_RANK);

        GameObject gObj = GameObject.Find("gameScreen");
        gObj.SendMessage("onRankChange", "" + rank);
//        GameScreen gameScreen = (GameScreen)gObj.GetComponent<GameScreen>();
//        gameScreen.rank = "" + rank;
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
                Log("game level loaded");

                _isGameLevelLoaded = true;
                StopCoroutine("PollGameLevelLoaded");

            }

            yield return new WaitForSeconds(1.0F);

        }

    }

    
    private void Log(String message)
    {
        // TODO: add the log messages to the UI
        Debug.Log(message);

            GameObject gObj = GameObject.Find("statusScreen");
            if (gObj != null)
            {
                gObj.SendMessage("UpdateStatusMessage", message);
            }

    }

}
