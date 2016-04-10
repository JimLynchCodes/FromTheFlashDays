using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class NameBubble : MonoBehaviour {

    public GUISkin skin;

    private string str = "";   // Striing to display
    static float ON_BACK = 0.5f;
    static float AT_FEET = -0.9f;

    private float NAME_POSITION = AT_FEET;

    void OnGUI()
    {

        //if there is something to say
        if (str != "")
        {
            //Debug.Log("NameBubble.OnGUI has message to display");
            GUI.skin = skin;
            GUIContent content = new GUIContent(str);
            Vector2 textSize = skin.GetStyle("Label").CalcSize(content);
            Vector3 bubblePos = transform.position + new Vector3(0, NAME_POSITION, 0);  //We ajust world Y position here to make chat bubble near the head of the model
            Vector3 screenPos = Camera.main.WorldToScreenPoint(bubblePos);

            // We render our text only if it's in the screen view port	
            if (screenPos.x >= 0 && screenPos.x <= Screen.width && screenPos.y >= 0 && screenPos.y <= Screen.height && screenPos.z >= 0)
            {
                //Debug.Log("NameBubble.OnGui says it's in the screen view port");
                Vector2 pos = GUIUtility.ScreenToGUIPoint(new Vector2(screenPos.x, Screen.height - screenPos.y));
                GUI.Label(new Rect(pos.x - 15, pos.y, textSize.x + 15, textSize.y + 5), content);
            }
            else
            {
                //Debug.Log("NameBubble.OnGui says it is NOT in the screen view port");
                //Debug.Log("screenPos.x, y, z = " + screenPos.x + ", " + screenPos.y + ", " + screenPos.z);
                //Debug.Log("Screen.width, height = " + Screen.width + ", " + Screen.height);
            }
        }
    }

    void Update()
    {
        // Here we count the time to display the message
        //if (str != "")
        //{
            //bubbleTime += Time.deltaTime;
            //if (bubbleTime > showTime)
            //{
                //bubbleTime = 0;
                //str = "";
            //}
        //}
    }

    // Function to be called if we want to show new bubble
    void ShowName(string str)
    {
        //Debug.Log("NameBubble ShowBubble called");
        this.str = str;
    }

}

