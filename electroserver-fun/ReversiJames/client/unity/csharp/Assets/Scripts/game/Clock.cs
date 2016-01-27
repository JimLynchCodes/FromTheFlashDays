using UnityEngine;
using System.Collections;

public class Clock : MonoBehaviour {

	bool isPaused = false;
	float startTime;  // in seconds
    float timeRemaining; // in seconds
    string fmt = "00.##";
	
	void Start () {
		isPaused = true;
        guiText.text = "";
	}
	
	public void SetTimer(int value) {
        startTime = Time.time + value;
        timeRemaining = value;
        isPaused = false;
	}
	
	void Update () {
		if (!isPaused)
		{
			DoCountdown();
		}
	}

    void DoCountdown()
    {
        timeRemaining = startTime - Time.time;
        if (timeRemaining < 0)
        {
            timeRemaining = 0;
            PauseClock();
            TimeIsUp();
        }
        ShowTime();
    }
	
	public void PauseClock() {
		isPaused = true;
        guiText.text = "";
    }
	
	public void UnPauseClock() {
		isPaused = false;
	}
	
	void ShowTime()
	{
        int seconds = Mathf.RoundToInt(timeRemaining);
        string timeStr = ":" + seconds.ToString(fmt);
        guiText.text = timeStr;
	}
	
	void TimeIsUp()
	{
	}
}
