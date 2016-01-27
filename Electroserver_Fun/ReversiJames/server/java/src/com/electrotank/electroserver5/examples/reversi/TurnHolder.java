package com.electrotank.electroserver5.examples.reversi;

import java.util.Random;
import java.util.ArrayList;
import java.util.List;

/** 
 * Manages players taking turns.  Will work for games with more than 2 players, too.
 * NOTE: This class as is does not support removal of players.
 * In Reversi.announcePlayerTurn, we use a loop to find the next turn holder.
 * If the player has already left the room, we skip immediately to the next player.
 */
public class TurnHolder {

    private List<String> players = new ArrayList<String>();
    private int ptr = 0;

    public boolean isEmpty() {
        return players.isEmpty();
    }
    
    /** Clears all players from the TurnHolder object. */
    public void clear() {
        players.clear();
        ptr = 0;
    }

    /**
     * Adds a player to the set of players, if that player is not already listed.
     *
     * @param playerName name of the player
     */
    public void add( String playerName ) {
        if ( !players.contains( playerName ) ) {
            players.add( playerName );
        }
    }

    /**
     * Gets the name of the player who currently holds the turn.
     * Does not change the current turn holder.
     *
     * @return playerName
     */
    public String getTurnHolder() {
        if (players.size() < 1) {
            return null;
        }
        return players.get( ptr );
    }

    /**
     * Changes the current turn holder to the next player,
     * then returns that player's name.
     *
     * @return playerName, after incrementing the pointer
     */
    public String nextPlayer() {
        if (players.size() < 1) {
            return null;
        }
        ptr = ( ptr + 1 ) % players.size();
        return players.get( ptr );
    }

    /**
     * Changes the current turn holder to a random player,
     * then returns that player's name.
     *
     * @return playerName, after setting the pointer randomly
     */
    public String pickRandomPlayer() {
        if (players.size() < 1) {
            return null;
        }
        Random rnd = new Random();
        ptr = 0;
        ptr = rnd.nextInt( players.size() );
        return getTurnHolder();
    }

    /**
     * Gets a list of all player names, as a List of Strings.
     *
     * @return player list
     */
    public List<String> getPlayers() {
        return players;
    }

    public boolean isNewRound() {
        return ptr == 0;
    }
    
    public int size() {
        return players.size();
    }
    
}
