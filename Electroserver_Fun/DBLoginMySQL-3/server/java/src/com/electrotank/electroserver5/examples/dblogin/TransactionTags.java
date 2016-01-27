package com.electrotank.electroserver5.examples.dblogin;

import java.util.HashMap;
import java.util.Map;

/**
 * Contains the various message tags 
 *
 */
public enum TransactionTags {

    // Define the various transaction tags
    ACTION( "a" ),
    TAG_ADD_TO_RANK("ar"),
    TAG_ERROR("err"),
    TAG_GET_RANK("r"),
    TAG_USER("u"),
    TAG_REGISTER("n"),
    TAG_LOGIN("l"),
    TAG_PASSWORD("p"),
    TAG_STATUS("s"),
            ;

    private final String tag;

    // Contains a reference to call enums by id
    private static Map<String, TransactionTags> tagMap;

    private TransactionTags( String tag ) {
        this.tag = tag;
        registerEnum( this );
    }

    private static void registerEnum( TransactionTags type  ) {
        if ( tagMap == null ) {
            tagMap = new HashMap<String, TransactionTags>();
        }
        tagMap.put( type.tag, type );
    }

    /**
     * Gets the TransactionTags equivalent of a given String.
     *
     * @param id pointer into the enumeration
     *
     * @return enum object in this position
     */
    public static TransactionTags findEnumById( String id ) {
        return tagMap.get( id );
    }

    /**
     * Is the given String a valid id for a TransactionTags?
     *
     * @param id String in question
     *
     * @return true if a TransactionTags exists for this String
     */
    public static boolean isValidId( String id ) {
        return tagMap.containsKey( id );
    }

    public String getTag() {
        return tag;
    }

}
