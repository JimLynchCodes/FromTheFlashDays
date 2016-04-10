using UnityEngine;
using System.Collections;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class PlayerSpawnController : MonoBehaviour {

	public Transform localPlayerObject; 
	public Transform remotePlayerPrefab;
	public Transform[] spawnPoints;
	
	private static System.Random random = new System.Random();
    
	private void SpawnLocalPlayer(string name) {
        Debug.Log("SpawnLocalPlayer invoked");
		int n = spawnPoints.Length;
		Transform spawnPoint = spawnPoints[random.Next(n)];
		localPlayerObject.transform.position = spawnPoint.transform.position;
		localPlayerObject.transform.rotation = spawnPoint.transform.rotation;
		localPlayerObject.SendMessage("StartSending");  // Start sending our transform to other players
        localPlayerObject.SendMessage("ForceSendTransform"); // make sure we send our first position update
        localPlayerObject.SendMessage("ShowName", name);  // show my own name
    }
	
	//Get the remote user list and spawn all remote players that have already joinded before us
	public void SpawnRemotePlayers(EsObject[] list, string myname) {
        Debug.Log("SpawnRemotePlayers");
        Debug.Log("my name = " + myname);
        foreach (EsObject obj in list)
        {
            String thisPlayer = getPlayerName(obj);
            Debug.Log("processing " + thisPlayer);
            Debug.Log("obj = " + obj.ToString());
            if (!myname.Equals(thisPlayer))
            {
                Debug.Log("need to spawn remote");
                SpawnRemotePlayer(obj);
            }
        }
	}

    private string getPlayerName(EsObject obj)
    {
        return obj.getString(PluginTags.USER_NAME);
    }

    private void SpawnRemotePlayer(EsObject obj)
    {
        Debug.Log("SpawnRemotePlayer");
		// Just spawn remote player at a very remote point
        Debug.Log("getting position");
        Vector3 pos = NetworkTransform.getPlayerPosition(obj);
        Debug.Log("getting rotation");
        Quaternion rot = NetworkTransform.getPlayerRotation(obj);
        //Give remote player a name like "remote_<id>" to easily find him then
        Debug.Log("getting player name");

        string name = getPlayerName(obj);

        // belt and suspenders section
        GameObject gobj = GameObject.Find("remote_" + name);
        if (gobj != null)
        {
            return;     // already spawned this user
        }
        // end belt and suspenders section

        Debug.Log("name is " + name);


        UnityEngine.Object remotePlayer = Instantiate(remotePlayerPrefab, pos, rot);
		
        remotePlayer.name = "remote_" + name;
		
		//Start receiving trasnform synchronization messages
		(remotePlayer as Component).SendMessage("StartReceiving");

        // show the remote player's name
        (remotePlayer as Component).SendMessage("ShowName", name);
				
	}

    public void UserEnterRoom(EsObject obj)
    {
		//When remote user enters our room we spawn his object.
        Debug.Log("UserEnterRoom");
        SpawnRemotePlayer(obj);
	}
	
	public void UserLeaveRoom(string userName) {
		//Just destroy the corresponding object
        GameObject obj = GameObject.Find("remote_" + userName);
		if (obj!=null) Destroy(obj);
	}

    private EsObject remoteUser = null;

    // I don't understand why this is here - see what happens if it's removed???
	void FixedUpdate() {
		if (remoteUser!=null) {
			SpawnRemotePlayer(remoteUser);
			remoteUser = null;	
		}
	}
	
		
	
}
