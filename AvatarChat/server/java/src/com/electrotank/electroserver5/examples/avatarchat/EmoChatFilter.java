package com.electrotank.electroserver5.examples.avatarchat;

import com.electrotank.electroserver5.services.languagefilter.trie.Trie;
import java.util.ArrayList;
import java.util.List;
import java.io.InputStream;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;

/**
 * Determines a user's emotional state from public chat.
 * If multiple rooms will need this, it is best to make it a ManagedObject.
 * 
 * To add additional states, make another Trie variable, another 
 * text file in the config folder, and another EmotionState, then 
 * modify initTries and getStateForChat.
 * 
 * To add additional trigger words for an existing emotional state, 
 * simply edit the appropriate text file in the config folder.  Each 
 * trigger must be on a separate line in UTF-8 format, and lowercase.
 * This filter will not notice non-alphabetic triggers if they are not separated by 
 * white space from other characters.  That is, if you make ! a trigger
 * and somebody says "Wow!" it won't be caught, but he says "Wow !" it will.
 * If "wow" is a trigger it will be caught both ways but if the chat is "Wowzer!" it won't.
 * 
 * Triggers can't have spaces or non-printing characters.  Matching is made 
 * using ASCII characters so this might not work correctly with Unicode chat.
 */

public class EmoChatFilter {

    private Trie happyTrie = null;
    private Trie sadTrie = null;
    private Trie surprisedTrie = null;
    private Trie confusedTrie = null;
    private Logger logger;
    
    public EmoChatFilter(ClassLoader loader, Logger logger) {
        this.logger = logger;
        initTries(loader);
    }
    
    private void initTries(ClassLoader loader) {
        happyTrie = new Trie(readWordList(loader, "happy.txt"));
        sadTrie = new Trie(readWordList(loader, "sad.txt"));
        surprisedTrie = new Trie(readWordList(loader, "surprised.txt"));
        confusedTrie = new Trie(readWordList(loader, "confused.txt"));
    }

    private List<String> readWordList(ClassLoader loader, String path) {
        String input = "";
        InputStream in = null;
        List<String> wordsToBeAdded = new ArrayList<String>();
        try {
            in = loader.getResourceAsStream(path);
            input = IOUtils.toString(in, "UTF-8");
        } catch (Exception e) {
            logger.error("readWordList error reading file: ", e);
        } finally {
            // Release the connection.
            IOUtils.closeQuietly(in);
        }

        if (input == null) {
            logger.debug("found NOOOOO words");
            return null;
        }

        String[] words = input.split("\n");
        logger.debug("EmoChatFilter processing {}", path);
        logger.debug("found {} lines", words.length);

        for (String word : words) {
            String trimmedWord = word.trim();
            if (trimmedWord != null && !trimmedWord.isEmpty()) {
                // check for blanks in the line
                if (trimmedWord.contains(" ")) {
                    String[] moreWords = trimmedWord.split(" ");
                    for (String smallerWord : moreWords) {
                        String trimmedSmallerWord = smallerWord.trim();
                        if (trimmedSmallerWord != null && !trimmedSmallerWord.isEmpty()) {
                            wordsToBeAdded.add(trimmedSmallerWord.toLowerCase());
                        }
                    }
                } else {
                    wordsToBeAdded.add(trimmedWord.toLowerCase());
                }
            }
        }

        logger.debug("found {} trimmed words", wordsToBeAdded.size());

        return wordsToBeAdded;
    }
    
    public EmotionState getStateForChat(String chatline) {
        if (chatline == null || chatline.isEmpty()) {
            return EmotionState.Default;
        }
        
        List<String> stringsToSearch = formatForCheck(chatline);
 
        if (happyTrie.findAnyWord(stringsToSearch)) {
            return EmotionState.Happy;
        } else if (sadTrie.findAnyWord(stringsToSearch)) {
            return EmotionState.Sad;
        } else if (surprisedTrie.findAnyWord(stringsToSearch)) {
            return EmotionState.Surprised;
        } else if (confusedTrie.findAnyWord(stringsToSearch)) {
            return EmotionState.Confused;
        } else {
            return EmotionState.Default;
        }
    }

    /**
     * Words of the line of chat need to be added two ways: 
     * ignoring punctuation, and including it (so that the emoticons work)
     */
    private List<String> formatForCheck(String dataIn) {
        dataIn = dataIn.toLowerCase();
        String[] withPunctuation = dataIn.split(" ");
        List<String> words = new ArrayList<String>();
        for (String word : withPunctuation) {
            words.add(word);
        }
        
        // now add the words with punctuation stripped
        StringBuffer buff = new StringBuffer();
        char c;
        int i = 0;
        int dataLength = dataIn.length();

        while (i < dataLength) {
            c = dataIn.charAt(i);

            if (c >= 'a' && c <= 'z') {
                buff.append(c);
            } else if (c == ' ') {
                if (buff.length() != 0) {
                    words.add(buff.toString());
                    buff = new StringBuffer();
                }
            }

            // increment the counter to read the next character
            ++i;
        }

        if (buff.length() != 0) {
            words.add(buff.toString());
        }

        return words;
    }
       
}
