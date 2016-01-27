using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameScreen : MonoBehaviour {

    private NetworkController controller;
    private string _rank = "0";
    private string amount = "1";

    // We start working from here
    void Start()
    {
        Application.runInBackground = true; // Let the application be running while the window is not active.
        Debug.Log("GameScreen starting");

        GameObject gObj = GameObject.Find("NetworkController");
        controller = (NetworkController)gObj.GetComponent<NetworkController>();
        controller.doGetRank();
    }
    
    public void OnGUI()
    {
			renderGamePanel();
    }

    private void onSubmit()
    {
        controller.doAddToRank(amount);
    }

    public void onRankChange(string rank)
    {
        _rank = rank;
    }
    
    private void renderGamePanel()
    {
        int labelX = 100;
        int textfieldX = 200;

        GUI.Label(new Rect(labelX, 116, 300, 20), "The rank associated with your username is loaded ");
        GUI.Label(new Rect(labelX, 136, 300, 20), "from the database and shown.  Increase it here.");
        GUI.Label(new Rect(labelX, 176, 100, 20), "Increase rank: ");
        amount = GUI.TextField(new Rect(textfieldX, 176, 200, 20), amount, 25);

        string username = controller.userName;
        GUI.Label(new Rect(labelX, 206, 100, 20), username + "'s rank: ");
        _rank = GUI.TextField(new Rect(textfieldX, 206, 200, 20), _rank, 25);

        if (GUI.Button(new Rect(textfieldX, 236, 100, 24), "Add to Rank"))
        {
			try {
                onSubmit();
			} catch (Exception ex){
			
				Debug.Log(ex.ToString());
			
			}
		}
		
	}
	
}
