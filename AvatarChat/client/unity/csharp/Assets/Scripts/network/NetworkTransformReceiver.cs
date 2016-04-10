using UnityEngine;
using System.Collections;
using System;

using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class NetworkTransformReceiver : MonoBehaviour {
	
	public float yAdjust = 0.0f; // Ajust y position when synchronizing the local and remote models.
	public float interpolationPeriod = 0.1f;  // This value should be equal to the sendingPerion value of the Sender script
	
	private bool receiveMode = false;
	private NetworkTransform lastState; // Last received transform state
	private NetworkTransform interpolateTo = null;  // Last state we interpolate to in receiving mode.
	private NetworkTransform interpolateFrom;  // Point from which to start interpolation
	
	private int interpolationPoint = 0; // Current interpolation point
	private int maxInterpolationPoints = 0; // Maximum number of interpolation points;
	private float interpolationDelta = 0; // Delta value by which interpolate
	
	private FPSStorage fpsStorage;
	private Queue queue = new Queue();  // Queue to store transform states for interpolations
			
	// We call it on remote player to start receiving his transform
	void StartReceiving() {
		lastState = new NetworkTransform(this.gameObject);	
		fpsStorage = GameObject.Find(" FPS").GetComponent(typeof(FPSStorage)) as FPSStorage;
		receiveMode = true;
	}
	
	void Update() {
		if (receiveMode) {
			InterpolateTransform();
		}
	}
		
	//This method is called when receiving remote transform
	// We update lastState here to know last received transform state
	void ReceiveTransform(EsObject data) {
        Debug.Log("ReceiveTransform.  receiveMode = " + receiveMode.ToString());
		if (receiveMode) {

            Vector3 pos = NetworkTransform.getPlayerPosition(data);
            Quaternion rot = NetworkTransform.getPlayerRotation(data);
            lastState.InitFromValues(pos, rot);
		
			// Adding next received state to the queue	
			NetworkTransform nextState = new NetworkTransform(this.gameObject);
			nextState.InitFromValues(pos, rot);
			queue.Enqueue(nextState);
		}
	}
		
	// This method is called in every Fixed Update in receiving mode. And it does transform interpolation to the latest state.
	void InterpolateTransform() {
			// If interpolationg
			if (interpolationPoint < maxInterpolationPoints) {
				interpolationPoint++;
				float t = interpolationPoint*interpolationDelta;
				if (t>1) t=1;
				transform.position = Vector3.Lerp(interpolateFrom.position, interpolateTo.position, t);
				transform.rotation = Quaternion.Slerp(interpolateFrom.rotation, interpolateTo.rotation, t);
			}
			else {
				// Finished interpolating to the next point
				if (interpolateTo!=null) {
					// Fixing interpolation result to set transform right to the next point
					transform.position = interpolateTo.position;
					transform.rotation = interpolateTo.rotation;
				}
						
				// Take new value from queue
				if (queue.Count!=0) {
						NetworkTransform nextTransform = queue.Dequeue() as NetworkTransform;
						//Start interpolation to the next transform
						// Set new final interpolation state and reset interpolationPoint
						interpolateTo = nextTransform;
						// Set new point from which to start interpolation as current transform
						interpolateFrom = new NetworkTransform(this.gameObject);
							
						interpolationPoint = 0;
						float frameRate = fpsStorage.GetCurrentFPS();
														
						// Calculate the total number of interpolation points as number of frames during interpolationPriod
						maxInterpolationPoints = Convert.ToInt32(Math.Round(frameRate * interpolationPeriod));
											
						// Reset interpolation deltaTime
						interpolationDelta = 1.0f / Convert.ToSingle(maxInterpolationPoints);
				}
				else {
					// If queue is empty just setting the transform to the last received state
					transform.position = lastState.position;
					transform.rotation = lastState.rotation;
				}
			}	
	}
	
}
