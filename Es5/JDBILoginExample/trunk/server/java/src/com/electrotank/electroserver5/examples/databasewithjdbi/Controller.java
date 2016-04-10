package com.electrotank.electroserver5.examples.databasewithjdbi;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;
import org.skife.jdbi.v2.TransactionCallback;
import org.skife.jdbi.v2.TransactionStatus;

import java.util.Properties;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * Main controller for all application logic
 *
 */
public class Controller extends Thread {

    private static final Logger logger = LoggerFactory.getLogger(Controller.class);
    private final BasicDataSource dataSource;
    private final DBI dbi;
    private Map<String, UserObject> userMap;
    private final BlockingQueue<PersistObject> toPersistList = new LinkedBlockingQueue<PersistObject>();
    private boolean shuttingDown = false;

    public Controller(Properties properties) throws Exception {
        setName(getClass().getSimpleName());
        this.dataSource = newDataSource(properties);
        this.dbi = new DBI(dataSource);
        initUserMap();
    }

    /**
     *  LOGIN METHODS
     * 
     */
    public boolean registerNewUser(String username, String password) {
        UserObject thisUser = new UserObject();
        thisUser.setName(username);
        thisUser.setPassword(password);
        synchronized (this) {
            if (!doesUsernameExist(username)) {
                getUserMap().put(thisUser.getName(), thisUser);
                getToPersistList().add(new PersistObject(username, PersistType.NewUser));
                return true;
            }
        }
        return false;
    }

    public boolean doesUsernameExist(String username) {
        return getUserMap().containsKey(username);
    }

    public boolean doesPasswordMatch(String username, String password) {
        if (doesUsernameExist(username)) {
            UserObject user = getUserMap().get(username);
            if (password.equals(user.getPassword())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 
     *      RANK METHODS
     * 
     */
    public int getUserRank(String username) {
        if (doesUsernameExist(username)) {
            UserObject user = getUserMap().get(username);
            return user.getRank();
        }
        return -1;
    }

    public void addToRank(String username, int delta) {
        if (doesUsernameExist(username)) {
            UserObject user = getUserMap().get(username);
            user.addToRank(delta);
            getToPersistList().add(new PersistObject(username, PersistType.UpdateRank));
        }
    }

    /**
     *  PRIVATE METHODS
     */
    
    private void initUserMap() {
        try {
            // Look up all the users in the system
            userMap = getDbi().inTransaction(new TransactionCallback<Map<String, UserObject>>() {

                @Override
                public Map<String, UserObject> inTransaction(Handle handle, TransactionStatus status) throws Exception {
                    return loadAllUsers(handle);
                }
            });

        } catch (Throwable t) {
            t.printStackTrace();
        }

    }

    private Map<String, UserObject> loadAllUsers(Handle handle) {

        Map<String, UserObject> users = new ConcurrentHashMap<String, UserObject>();

        List<Map<String, Object>> userResults = null;
        try {
            userResults = handle.createQuery("sql/LoadAllUsers.sql").list();
        } catch (Exception e) {
            // create the user table
            logger.warn("Exception loading users table, attempting to create it");
            handle.createStatement("sql/CreateUserTable.sql").execute();
            return users;
        }

        if (null == userResults) {
            // create the user table
            logger.warn("Users table not found, attempting to create it");
            handle.createStatement("sql/CreateUserTable.sql").execute();
            return users;
        }

        // Iterate over all the entries
        for (Map<String, Object> entry : userResults) {

            // Create the item
            UserObject thisUser = new UserObject();

            // Populate it
            thisUser.setName((String) entry.get("name"));
            thisUser.setPassword((String) entry.get("pword"));
            if (null != entry.get("rank")) {
                thisUser.setRank((Integer) entry.get("rank"));
            }

            // Add it to the map
            users.put(thisUser.getName(), thisUser);
            logger.debug("Found {} in users table with password ({})",
                    thisUser.getName(), thisUser.getPassword());
        }

        return users;
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

    @Override
    public void run() {
        logger.warn("Persist to database run starting");

        while (!Thread.interrupted() && !shuttingDown) {
            List<PersistObject> events = new ArrayList<PersistObject>();

            try {
                events.add(this.getToPersistList().take());
            } catch (InterruptedException ignored) {
                break;
            }

            this.getToPersistList().drainTo(events);

            for (PersistObject event : events) {
                if (!userMap.containsKey(event.getUserName())) {
                    // user must have been deleted from userMap
                    // if you have a "delete user from database" then do it here
                    continue;
                }
                final UserObject userObject = getUserMap().get(event.getUserName());
                final PersistType type = event.getType();
                dbi.inTransaction(new TransactionCallback<Boolean>() {

                    @Override
                    public Boolean inTransaction(Handle handle, TransactionStatus status) throws Exception {
                        DatabaseHelper.persistToDatabase(handle, userObject, type);
                        return null;
                    }
                });
            }
        }

        logger.debug("Persist to database terminating");
    }

    /**
     *      OTHER PUBLIC METHODS
     * 
     */
    public void dispose() throws Exception {
        logger.warn("Controller.dispose invoked");
        shuttingDown = true;
/**
 * // shutting down a database from your application
DriverManager.getConnection(
    "jdbc:derby:sample;shutdown=true");

 */        
        logger.warn("Now attempting to close the dataSource");
        dataSource.getConnection().close();
        dataSource.close();
        logger.warn("Now trying to shut down database itself");
        DriverManager.getConnection("jdbc:derby:./db/UserInfo;shutdown=true");
    }

    public DBI getDbi() {
        return dbi;
    }

    public Map<String, UserObject> getUserMap() {
        return userMap;
    }

    public BlockingQueue<PersistObject> getToPersistList() {
        return toPersistList;
    }
    
}
