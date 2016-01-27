package com.electrotank.electroserver5.examples.reversi;

import java.util.Random;

public class AI {
    
    private PlayerInfo pInfo;
    private Random rnd;
    
    public AI (String name) {
        pInfo = new PlayerInfo(name);
        pInfo.setIsHuman(false);
        rnd = new Random();
    }
    
    public String getName() {
        return pInfo.getPlayerName();
    }

    public PlayerInfo getPInfo() {
        return pInfo;
    }
    
    /**
     * This is a very simple AI, that just makes a random move.
     * If you have a good strategy for the AI, you could modify
     * this method, or add a method to BoardState that would choose 
     * a good move to make, and call it here.
     * 
     * Note that this doesn't use the BoardState parameter; it is 
     * there to make it easier if you make a more complicated choice.
     */
    public Chip makeMove(BoardState board, int[] legalMoves) {
        // pick random legal move
        int ptr = rnd.nextInt(legalMoves.length);
        return new Chip(legalMoves[ptr], getPInfo().getColor());
    }

}
