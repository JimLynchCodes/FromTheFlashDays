using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Net;

/*
 * These are the ElectroServer Imports 
 */
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;
using log4net;

public class Main : MonoBehaviour {

    private string host = "127.0.0.1";
    private int port = 9899;

    private System.Random rnd = new System.Random();

    // Server Information
    public string serverURL;
	public string serverPort;
	
	private ElectroServer _es;
	
	// User Information
	private string _userName;
	
	private bool _renderLogin;
	private bool _renderWaiting;
	public bool renderWaiting {
		set{ _renderWaiting = value;}
	}

	private bool _isGameLevelLoaded;
	
	public void Awake() {
		
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
		
		// Set default username
		_userName = "";
        serverURL = host;
        serverPort = "" + port;
		
		_renderLogin = true;
		_renderWaiting = false;
		
	}
	
	/*
	 * This is the connection response handler from ES
	 * it determines whether success or not and fires off
	 * a login request is successful
	 */
	private void OnConnect(ConnectionResponse response){
	
		if (response.Successful){
			
			Debug.Log("Connected");
			
			// Build login request properties
			LoginRequest loginRequest = new LoginRequest();
            if (_userName.Length < 1)
            {
                // to handle cases where the user just clicks Connect without entering a username
                _userName = "user_" + rnd.Next(10000);
            }

            GameObject gameManager = GameObject.Find("_GameManager");
            GameManager gm = (GameManager)gameManager.GetComponent<GameManager>();
            gm.es = _es;
            gm.userName = _userName;
            Debug.Log("Sending login request");

            loginRequest.UserName = _userName;
			loginRequest.Password = "noPassword";
			
			// Send to ES for request obj
			_es.Engine.Send(loginRequest);
			
		} else {
			
			Debug.Log("Connection Failed");
			
		}
	
	}

    void OnApplicationQuit()
    {
        Debug.Log("Main.OnApplicationQuit invoked");
        if (_es != null)
        {
            try
            {
                _es.Engine.Close();
            }
            catch (Exception)
            {

                Debug.Log("Error calling Main.OnApplicationQuit");
            }
        }

    }
    
    /*
     * This is the login response handler from ES
     * It checks for success and if success performs
     * next step of game logic. For this example it is
     * loading a new scene where the game will happen
     */
	private void OnLogin(LoginResponse response){
		
		if(response.Successful){
			
			Debug.Log("Login Successful");
			
			// Start Coroutine to jump to game scene
			StartCoroutine(PollGameLevelLoaded());	
			
			// Toggle some GUI states for built-in GUI
			_renderLogin = false;
			_renderWaiting = true;

			// Execute level load
			Application.LoadLevel("AvatarChat");

			
		} else {
			Debug.Log("Login Failed: " + response.Error);
		}
		
	}
	
	/*
	 * Polls in a routine when game is loaded to instantiate
	 * gameflow handler. Handled this way to mimic a handful of 
	 * the classes for the AS3 version
	 */
	private IEnumerator PollGameLevelLoaded(){
		
		while(!_isGameLevelLoaded){
			
			if (Application.loadedLevelName == "AvatarChat"){
                Debug.Log("AvatarChat level loaded");
			
				_isGameLevelLoaded = true;
				StopCoroutine("PollGameLevelLoaded");

                Debug.Log("Attempting to join room");
			}
			
			yield return new WaitForSeconds(1.0F);
			
		}
		
	}
	
	public void OnGUI() {
		
			renderLoginPanel();
		
	}

    /**
     * Converts a hostname to an IP address.  Only needed for web player's PreFetch line,
     * and not even needed then if you hard code the IP address instead of a hostname.
     */
    private string getIP(string host)
    {
            return Dns.GetHostAddresses(host)[0].ToString();
    }
	
	private void renderLoginPanel() {
        int labelX = 100;
        int textfieldX = 200;

        GUI.Label(new Rect(labelX, 116, 100, 20), "Username: ");
        _userName = GUI.TextField(new Rect(textfieldX, 116, 200, 20), _userName, 25);

        GUI.Label(new Rect(labelX, 146, 100, 20), "Host: ");
        serverURL = GUI.TextField(new Rect(textfieldX, 146, 200, 20), serverURL, 25);

        GUI.Label(new Rect(labelX, 176, 100, 20), "Port: ");
        serverPort = GUI.TextField(new Rect(textfieldX, 176, 200, 20), serverPort, 25);

        if (GUI.Button(new Rect(textfieldX, 206, 100, 24), "Login"))
        {
			try {
				Debug.Log("Attempting to connect...");
				
                // comment this out for production, since it adds a lot of logging lines
				//log4net.Config.BasicConfigurator.Configure();

                #if UNITY_WEBPLAYER
                Security.PrefetchSocketPolicy(getIP(serverURL), Convert.ToInt32(serverPort));
                #endif

                /* 
				 * Creates a server and server connection
				 * passes server to ES for handling with logic
				 * above for connection response.
				 */
				Server server = new Server("default");
				server.AddAvailableConnection(new AvailableConnection(serverURL, Convert.ToInt32(serverPort), AvailableConnection.TransportType.BinaryTCP));
				_es.Engine.AddServer(server);
				_es.Engine.Connect();
				
			} catch (Exception ex){
			
				Debug.Log(ex.ToString());
			
			}
		}
		
	}
	
	private void renderWaitingPanel() {
        Debug.Log("renderWaitingPanel start");

		GUILayout.BeginArea( new Rect(Screen.width/2-150, Screen.height/2-100, 300, 200), "", "box");
		GUILayout.BeginVertical();
		GUILayout.Label("Waiting Area (players for game):");

    	GUILayout.BeginScrollView (new Vector2(), GUILayout.Width(290), GUILayout.Height(100));
    
    	GUILayout.EndScrollView ();
		GUILayout.EndVertical();
		
		GUILayout.EndArea();
        Debug.Log("renderWaitingPanel end");
		
	}
	
	/*
	 * Makes ES dispatch events, etc. on
	 * regular basis. This is key to working
	 * with ES in Unity.
	 */
	public void FixedUpdate () {
		_es.Engine.Dispatch();
	}
	
}
