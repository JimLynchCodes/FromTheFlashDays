using UnityEngine;
using System.Collections;

public class DontDestroy : MonoBehaviour {

	public void Awake () {
		DontDestroyOnLoad(gameObject.transform);	
	}
	
}
