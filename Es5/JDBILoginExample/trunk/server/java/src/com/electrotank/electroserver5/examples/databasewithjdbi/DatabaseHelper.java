package com.electrotank.electroserver5.examples.databasewithjdbi;

import org.skife.jdbi.v2.Handle;
import org.skife.jdbi.v2.tweak.HandleCallback;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *  Static methods used for database accesses.
 * 
 */
public class DatabaseHelper {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseHelper.class);
    
    /**
     *  Executes a valid SQL string, with no checks.
     *  WARNING: If the String is constructed using String data from the client
     *  this will allow an SQL injection attack.
     */
    public static boolean executeSQL(Controller controller, final String sqlCommand) {
        try {
            controller.getDbi().withHandle(new HandleCallback<Object>() {

                @Override
                public Object withHandle(Handle handle) throws Exception {

                    handle.createStatement(sqlCommand).execute();
                    return null;
                }
            });
            return true;
        } catch (Exception exception) {
            logger.error("Error attempting to execute SQL: {} ", sqlCommand);
            return false;
        }
    }

    public static void persistToDatabase(Handle handle, UserObject userObject, PersistType type) {
        switch (type) {
            case NewUser:
                persistNewUser(handle, userObject);
                break;
            case UpdateRank:
                persistUserRank(handle, userObject);
                break;
            default:
                logger.error("Unhandled PersistType {}", type);
        }
    }

    private static void persistNewUser(Handle handle, UserObject userObject) {
        // Save the new user to the database
        String userName = userObject.getName();
        String password = userObject.getPassword();
//        logger.debug("attempting to persist {}, {}", userName, password);
        handle.createStatement("sql/AddNewUsername.sql")
                .bind("username", userName)
                .bind("password", password)
                .execute();
    }

    private static void persistUserRank(Handle handle, UserObject user) {
        int rank = user.getRank();
        String userName = user.getName();
//            logger.debug("attempting to persist rank {}, {}", userName, rank);
        handle.createStatement("sql/UpdateUserRank.sql")
                .bind("username", userName)
                .bind("rank", rank)
                .execute();
    }
}
