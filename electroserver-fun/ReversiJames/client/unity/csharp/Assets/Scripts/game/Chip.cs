using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using System;
using Electrotank.Electroserver5.Api;
using Electrotank.Electroserver5.Core;

public class Chip 
{
    private int color;
    private int x;  // row
    private int y;  // col
    private int key;

    public Chip()
    {
    }

    public Chip(int id, int color)
    {
        key = id;
        y = id / GameConstants.BOARD_SIZE;
        x = id % GameConstants.BOARD_SIZE;
        this.color = color;
    }

    public Chip(int row, int col, int color)
    {
        this.x = row;
        this.y = col;
        this.color = color;
        key = y * GameConstants.BOARD_SIZE + x;
    }

    public int getKey()
    {
        return key;
    }

    public int getX()
    {
        return x;
    }

    public void setX(int x)
    {
        this.x = x;
    }

    public int getY()
    {
        return y;
    }

    public void setY(int y)
    {
        this.y = y;
    }

    public int getColor()
    {
        return color;
    }

    public void setColor(int color)
    {
        this.color = color;
    }

    public bool isColorBlack()
    {
        return color == GameConstants.BLACK;
    }

    public void flip()
    {
        if (color != -1)
        {
            color = 1 - color;
        }
    }

    public EsObject toEsObject()
    {
        EsObject obj = new EsObject();
        obj.setInteger(GameConstants.ID, key);
        obj.setBoolean(GameConstants.COLOR_IS_BLACK, isColorBlack());
        return obj;
    }

}
