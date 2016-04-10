package com.electrotank.electroserver5.examples.dblogin;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;
import org.skife.jdbi.v2.TransactionCallback;
import org.skife.jdbi.v2.TransactionStatus;

import java.util.Properties;
import org.skife.jdbi.v2.tweak.HandleCallback;

/**
 * Main controller for all application logic
 *
 */
public class Controller {

    private static final Logger logger = LoggerFactory.getLogger(Controller.class);
    private final BasicDataSource dataSource;
    private final DBI dbi;

    public Controller(Properties properties) throws Exception {
        this.dataSource = newDataSource(properties);
        this.dbi = new DBI(dataSource);
        logger.debug("Controller init");
    }

    /**
     *  LOGIN METHODS
     * 
     */
    public LoginResultEnum registerNewUser(final String username, final String password) {
        UserObject thisUser = new UserObject();
        thisUser.setName(username);
        thisUser.setPassword(password);
        synchronized (this) {
            UserObject otherUser = getUserInfo(username);
            if (otherUser == null) {
                // register
                try {
                    getDbi().inTransaction(new TransactionCallback<Object>() {

                        @Override
                        public Object inTransaction(Handle handle, TransactionStatus status) throws Exception {
                            addNewUsername(handle, username, password);
                            return null;
                        }
                    });
                } catch (Throwable t) {
                    logger.error("Controller.registerNewUser error: ", t.getMessage());
                    t.printStackTrace();
                    return LoginResultEnum.DatabaseError;
                }

                return LoginResultEnum.Approved;
            } else if (otherUser.doesPasswordMatch(password)) {
                return LoginResultEnum.AlreadyRegistered;
            } else {
                return LoginResultEnum.UsernameTaken;
            }
        }
    }

    public UserObject getUserInfo(final String username) {
        try {
            // Look up this user's info in the database
            UserObject result = getDbi().inTransaction(new TransactionCallback<UserObject>() {

                @Override
                public UserObject inTransaction(Handle handle, TransactionStatus status) throws Exception {
                    return loadUser(handle, username);
                }
            });
            return result;

        } catch (Throwable t) {
            logger.error("Controller.getUserInfo error: ", t.getMessage());
            t.printStackTrace();
        }
        return null;
    }

    /**
     * 
     *      RANK METHODS
     * 
     */
    public int addToRank(final String username, final int delta) {
        int result = -1;
        try {
            // Look up all the users in the system
            result = getDbi().inTransaction(new TransactionCallback<Integer>() {

                @Override
                public Integer inTransaction(Handle handle, TransactionStatus status) throws Exception {
                    int rank = addToUserRank(handle, username, delta);
                    return rank;
                }
            });
        } catch (Throwable t) {
            logger.error("Controller.addToRank error: ", t.getStackTrace());
            return -1;
        }
        return result;
    }
    
    /**
     *      OTHER POSSIBLY USEFUL METHODS
     */
    
    /**
     * Executes any SQL command.  WARNING!!!!!!!!
     * Only use canned SQL here, because there is no binding, so
     * this is wide open to SQL injection attacks if a user
     * provides any part of it other than integers!
     */
    public boolean executeSQL(final String sqlCommand) {
        try {
            getDbi().withHandle(new HandleCallback<Object>() {

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

    /**
     *  PRIVATE METHODS
     */
    private UserObject loadUser(Handle handle, String username) {
        Map<String, Object> userResults = null;
        try {
            userResults = handle.createQuery("sql/LoadUser.sql")
                    .bind("username", username)
                    .first();
        } catch (Exception e) {
            // create the user table
            logger.warn("Exception loading users table, attempting to create it");
            handle.createStatement("sql/CreateUserTable.sql").execute();
            return null;
        }

        if (null == userResults) {
            logger.warn("User not found");
            return null;
        }

        // Create the item
        UserObject thisUser = new UserObject();

        // Populate it
        thisUser.setName((String) userResults.get("name"));
        thisUser.setPassword((String) userResults.get("pword"));
        if (null != userResults.get("rank")) {
            thisUser.setRank((Integer) userResults.get("rank"));
        }

        logger.debug("Found {} in users table with password ({})",
                thisUser.getName(), thisUser.getPassword());

        return thisUser;
    }

    private int addToUserRank(Handle handle, String userName, int amount) {
        handle.createStatement("sql/AddToUserRank.sql")
                .bind("username", userName)
                .bind("amount", amount)
                .execute();
        UserObject userInfo = loadUser(handle, userName);
        if (userInfo == null) {
            return -1;
        } else {
            return userInfo.getRank();
        }
    }

    private void addNewUsername(Handle handle, String userName, String password) {
        handle.createStatement("sql/AddNewUsername.sql")
                .bind("username", userName)
                .bind("password", password)
                .execute();
    }

    private BasicDataSource newDataSource(Properties properties) throws Exception {
        Properties databaseProperties = new Properties();

        for (String key : properties.stringPropertyNames()) {
            if (key.startsWith("database.")) {
                databaseProperties.setProperty(key.substring(9), properties.getProperty(key));
            }
        }

        return (BasicDataSource) BasicDataSourceFactory.createDataSource(databaseProperties);
    }

    /**
     *      OTHER PUBLIC METHODS
     * 
     */
    public void dispose() throws Exception {
        logger.warn("Controller.dispose invoked");
        logger.warn("Now attempting to close the dataSource");
        dataSource.getConnection().close();
        dataSource.close();
    }

    public DBI getDbi() {
        return dbi;
    }
}
