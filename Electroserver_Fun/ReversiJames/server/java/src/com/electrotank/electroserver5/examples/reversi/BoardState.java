package com.electrotank.electroserver5.examples.reversi;

import com.electrotank.electroserver5.extensions.api.value.EsObject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

/**
 * Data structure for the state of the Reversi Board,
 * and logic for determining legality of moves.
 */
public class BoardState {

    protected int size;
    protected int[] state;
    protected HashMap<Integer, Chip> chips;
    protected static final int[] DX = {-1, 0, 1, -1, 1, -1, 0, 1};
    protected static final int[] DY = {-1, -1, -1, 0, 0, 1, 1, 1};
    protected static final int[] STARTERS = {
        3, 3, PluginConstants.BLACK,
        3, 4, PluginConstants.WHITE,
        4, 4, PluginConstants.BLACK,
        4, 3, PluginConstants.WHITE,
    };

    public BoardState(int size) {
        this.size = size;
        state = new int[size * size];
        Arrays.fill(state, -1);
        chips = new HashMap<Integer, Chip>();
        // start the game with the standard arrangement of pieces
        for (int ii = 0; ii < STARTERS.length; ii += 3) {
            Chip chip = new Chip(STARTERS[ii], STARTERS[ii + 1], STARTERS[ii + 2]);
            placeChip(chip);
        }
    }

    public int determineScore(int color) {
        int score = 0;
        for (Chip chip : chips.values()) {
            if (chip.getColor() == color) {
                score++;
            }
        }
        return score;
    }

    /**
     * Add/update a collection of Chips
     */
    public void addOrUpdateChips(Collection<Chip> updatedChips) {
        for (Chip chip : updatedChips) {
            placeChip(chip);
        }
    }

    public EsObject[] toEsObjectArray() {
        if (chips.isEmpty()) {
            return null;
        }
        EsObject[] list = new EsObject[chips.size()];
        int ptr = 0;
        for (Chip chip : chips.values()) {
            list[ptr] = chip.toEsObject();
            ptr++;
        }
        return list;
    }

    /**
     * Returns true if the Chip represents a legal move 
     */
    public boolean isLegalMove(Chip chip) {
        // disallow moves on out of bounds and already occupied spots
        if (!inBounds(chip.getX(), chip.getY()) ||
                getColor(chip.getX(), chip.getY()) != -1) {
            return false;
        }

        // determine whether this chip flips chips of the opposite color
        for (int ii = 0; ii < DX.length; ii++) {
            // look in this direction for captured pieces
            boolean sawOther = false, sawSelf = false;
            int x = chip.getX(), y = chip.getY();
            for (int dd = 0; dd < size; dd++) {
                x += DX[ii];
                y += DY[ii];

                // stop when we end up off the board
                if (!inBounds(x, y)) {
                    break;
                }

                int color = getColor(x, y);
                if (color == -1) {
                    break;
                } else if (color == 1 - chip.getColor()) {
                    sawOther = true;
                } else if (color == chip.getColor()) {
                    sawSelf = true;
                    break;
                }
            }

            // if we saw at least one other piece and one of our own, we have a
            // legal move
            if (sawOther && sawSelf) {
                return true;
            }
        }
        return false;
    }

    /**
     * Returns true if the player with the specified color has legal moves.
     */
    public boolean hasLegalMoves(int color) {
        // search every board position for a legal move
        for (int yy = 0; yy < size; yy++) {
            for (int xx = 0; xx < size; xx++) {
                if (getColor(xx, yy) != -1) {
                    continue;
                }
                Chip chip = new Chip (xx, yy, color);
                if (isLegalMove(chip)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Returns a random legal move for this color
     */
    public Chip randomLegalMove(int color) {
        // search every board position for a legal move
        for (int yy = 0; yy < size; yy++) {
            for (int xx = 0; xx < size; xx++) {
                if (getColor(xx, yy) != -1) {
                    continue;
                }
                Chip chip = new Chip (xx, yy, color);
                if (isLegalMove(chip)) {
                    return chip;
                }
            }
        }

        // return a "pass"
        return new Chip(-1, -1, color);
    }

    public int[] getAllLegalMoves(int color) {
        // search every board position for all legal move
        List<Chip> list = new ArrayList<Chip>();
        for (int yy = 0; yy < size; yy++) {
            for (int xx = 0; xx < size; xx++) {
                if (getColor(xx, yy) != -1) {
                    continue;
                }
                Chip chip = new Chip (xx, yy, color);
                if (isLegalMove(chip)) {
                    list.add(chip);
                }
            }
        }
        
        if (list.isEmpty()) {
            return null;
        }
        
        int[] result = new int[list.size()];
        for (int ii = 0; ii < list.size(); ii++) {
            Chip chip = list.get(ii);
            result[ii] = chip.getKey();
        }
        return result;
    }
    
    public List<EsObject> checkAndAddIfLegal(Chip chip) {
        if (isLegalMove(chip)) {
            return placeChipAndFlip(chip);
        }
        return null;
    }

    /**
     * Place or update a chip without doing any logic checks
     */
    public void placeChip(Chip placedChip) {
        // place the new chip
        int index = placedChip.getKey();
        state[index] = placedChip.getColor();
        chips.put(index, placedChip);
    }

    /**
     * Determines which chips should be flipped based on the placement of the
     * specified chip onto the board. The pieces in question are changed to
     * the appropriate color.  
     */
    public List<EsObject> placeChipAndFlip(Chip placedChip) {
        List<EsObject> wasFlipped = new ArrayList<EsObject>();
        List<Chip> toflip = new ArrayList<Chip>();
        placeChip(placedChip);

        // determine where this piece "captures" pieces of the opposite color
        for (int ii = 0; ii < DX.length; ii++) {
            // look in this direction for captured pieces
            int x = placedChip.getX();
            int y = placedChip.getY();
            for (int dd = 0; dd < size; dd++) {
                x += DX[ii];
                y += DY[ii];

                // stop when we end up off the board
                if (!inBounds(x, y)) {
                    break;
                }

                int color = getColor(x, y);
                if (color == -1) {
                    break;

                } else if (color == 1 - placedChip.getColor()) {
                    // add the piece at these coordinates to flip list
                    Chip chip = chips.get(getKey(x, y));
                    if (chip != null) {
                        toflip.add(chip);
                    }

                } else if (color == placedChip.getColor()) {
                    // flip all the toflip pieces because we found our pair
                    for (Chip chip : toflip) {
                        chip.setColor(color);
                        state[chip.getKey()] = color;
                        wasFlipped.add(chip.toEsObject());
                    }
                    break;
                }
            }
            toflip.clear();
        }
        return wasFlipped;
    }
    
    /**
     * So that I can print the whole board, for debugging
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (int ii = 0; ii < state.length; ii++) {
            if (ii % size == 0) {
                sb.append("\n");
            }
            sb.append(state[ii] + "\t");
        }
        return sb.toString();
    }

    protected final int getColor(int x, int y) {
        return state[y * size + x];
    }

    protected final int getKey(int x, int y) {
        return y * size + x;
    }

    protected final boolean inBounds(int x, int y) {
        return x >= 0 && y >= 0 && x < size && y < size;
    }
}
