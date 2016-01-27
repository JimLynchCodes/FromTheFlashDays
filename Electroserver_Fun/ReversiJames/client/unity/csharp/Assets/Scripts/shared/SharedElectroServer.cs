using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;


public class SharedElectroServer : MonoBehaviour {
	
	// Reference to ElectroServer Items
	private ElectroServer _es;
	public ElectroServer es {
		set{ _es = value;}
		get{ return _es;}
	}

    private string _userName;
    public string userName
    {
        set { _userName = value; }
        get { return _userName; }
    }

    private LobbyController.AvailGame _gameToJoin;
    public LobbyController.AvailGame gameToJoin
    {
        set { _gameToJoin = value; }
        get { return _gameToJoin; }
    }
}
