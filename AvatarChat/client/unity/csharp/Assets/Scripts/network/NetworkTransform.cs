using UnityEngine;
using System.Collections;
using System;

using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

// We use this class here to store and work with transform states
public class NetworkTransform {
		
		public Vector3 position;
		public Quaternion rotation;
		private GameObject obj;
        private NetworkController controller = null;

        // only needed if there are AS3 clients in the same room
        public static int MIN_AS3_X = 55;
        public static int MAX_AS3_X = 740;
        public static int MIN_AS3_Y = 0;
        public static int MAX_AS3_Y = 230;
        public static int AS3_MULTIPLIER = 8;
        public static int AS3_PANEL_HEIGHT = 380;
		
		public NetworkTransform(GameObject obj) {
			this.obj = obj;
			InitFromCurrent();
		}

        private NetworkController getNetworkController() 
        {
            if (controller != null)
            {
                return controller;
            } else {
                Debug.Log("NetworkTransform is initializing controller");
                GameObject gameManager = GameObject.Find("_GameManager");
                GameManager gm = (GameManager)gameManager.GetComponent<GameManager>();
                controller = gm.controller;
                return controller;
            }
        }
				
		// Updates last state to the current transform state if the current state was changed and return true if so or false if not
		public bool UpdateIfDifferent() {
			if (obj.transform.position != this.position || obj.transform.rotation!=this.rotation) {
				InitFromCurrent();
				return true;
			}
			else {
				return false;
			}
		}


        // map the Unity position x to the AS3 position X
        // only needed if there are AS3 clients in the same room
        private int getAS3positionX()
        {
            int as3x = (int)(AS3_MULTIPLIER * this.position.x);
            as3x = Mathf.Max(as3x, MIN_AS3_X);
            as3x = Mathf.Min(as3x, MAX_AS3_X);
            return as3x;
        }

        // map the Unity position z to the AS3 position Y
        // only needed if there are AS3 clients in the same room
        private int getAS3positionY()
        {
            int as3y = (int)(AS3_PANEL_HEIGHT - AS3_MULTIPLIER * this.position.z);
            as3y = Mathf.Max(as3y, MIN_AS3_Y);
            as3y = Mathf.Min(as3y, MAX_AS3_Y);
            return as3y;
        }

        // Send transform to all other users
		public void DoSend() {
            EsObject data = new EsObject();
            data.setString(PluginTags.ACTION, PluginTags.POSITION_UPDATE_REQUEST);

            // set the X, Y coords that AS3 clients will see, which are integers and just vert, horiz.
            // only needed if there are AS3 clients in the same room
            //data.setInteger(PluginTags.TARGET_X, getAS3positionX());  // uncomment if AS3 clients will be in the room
            //data.setInteger(PluginTags.TARGET_Y, getAS3positionY());  // uncomment if AS3 clients will be in the room

            // set the position and rotation coords that Unity clients will use
            data.setFloat(PluginTags.POSITION_X, this.position.x);
            data.setFloat(PluginTags.POSITION_Y, this.position.y);
            data.setFloat(PluginTags.POSITION_Z, this.position.z);
            data.setFloat(PluginTags.ROTATION_X, this.rotation.x);
            data.setFloat(PluginTags.ROTATION_Y, this.rotation.y);
            data.setFloat(PluginTags.ROTATION_Z, this.rotation.z);
            data.setFloat(PluginTags.ROTATION_W, this.rotation.w);

            //Debug.Log("NetworkTransform.DoSend");

            NetworkController nc = getNetworkController();
            if (nc != null)
            {
                nc.sendToPlugin(data);
            }
            else
            {
                Debug.Log("DoSend can't send because controller is null");
            }

		}
		
		public void InitFromValues(Vector3 pos, Quaternion rot) {
			this.position = pos;
			this.rotation = rot;
		}
		
		// To compare with Unity transform and itself
		public override bool Equals(System.Object obj)
    	{
        	if (obj == null)
        	{
           	 	return false;
        	}
        	
	        Transform t = obj as Transform;
	        NetworkTransform n = obj as NetworkTransform;
	        
	        if (t!=null) {
	        	return (t.position == this.position && t.rotation==this.rotation);
	        }
	        else if (n!=null) {
	        	return (n.position == this.position && n.rotation==this.rotation);
	        }
	        else {
	        	return false;
	        }	        	
	   	}

		
		private void InitFromCurrent() {
			this.position = obj.transform.position;
			this.rotation = obj.transform.rotation;	
		}
		
		private void InitFromGiven(Transform trans) {
			this.position = trans.position;
			this.rotation = trans.rotation;	
		}

        public static Vector3 getPlayerPosition(EsObject data)
        {
            if (data.variableExists(PluginTags.POSITION_X))
            {
                return new Vector3(Convert.ToSingle(data.getFloat(PluginTags.POSITION_X)),
                                            //Convert.ToSingle(data.getFloat(PluginTags.POSITION_Y)) + 1.0f,
                                            1.0f,
                                            Convert.ToSingle(data.getFloat(PluginTags.POSITION_Z))
                                            );
            }
            else
            {
                // only needed if there are AS3 clients in the same room, or for user enters room
                return new Vector3(getUnityPostionXfromAS3(data), 1.0f, getUnityPostionZfromAS3(data));
            }
        }

        public static Quaternion getPlayerRotation(EsObject data)
        {
            if (data.variableExists(PluginTags.POSITION_X))
            {
                return new Quaternion(Convert.ToSingle(data.getFloat(PluginTags.ROTATION_X)),
                                        Convert.ToSingle(data.getFloat(PluginTags.ROTATION_Y)),
                                        Convert.ToSingle(data.getFloat(PluginTags.ROTATION_Z)),
                                        Convert.ToSingle(data.getFloat(PluginTags.ROTATION_W))
                                        );
            }
            else
            {
                // only needed if there are AS3 clients in the same room, or for user enters room
                return new Quaternion(0, 0, 0, 1);
            }

        }

        // only needed if there are AS3 clients in the same room
        public static float getUnityPostionXfromAS3(EsObject data)
        {
            float targetX = data.getInteger(PluginTags.TARGET_X);
            return targetX / AS3_MULTIPLIER;
        }

        // only needed if there are AS3 clients in the same room
        public static float getUnityPostionZfromAS3(EsObject data)
        {
            float targetY = data.getInteger(PluginTags.TARGET_Y);
            targetY = (AS3_PANEL_HEIGHT - targetY);
            return targetY / AS3_MULTIPLIER;
        }


}

