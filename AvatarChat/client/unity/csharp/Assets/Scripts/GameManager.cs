using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;


public class GameManager : MonoBehaviour {
	
	// Reference to Game Character
	//public GameObject gameCharacter;
	
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

    private NetworkController _controller;
    public NetworkController controller
    {
        set { _controller = value; }
        get { return _controller; }
    }
	
}
