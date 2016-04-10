package com.electrotank.electroserver5.examples.dblogin;

import com.electrotank.electroserver5.extensions.BaseLoginEventHandler;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.LoginContext;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import org.slf4j.Logger;

public class DBLoginHandler extends BaseLoginEventHandler {

    private Controller controller;
    private Logger logger;
    /**  
     *  Should the database lookup take place during login, or 
     *  from a plugin request to a server level plugin? 
     *  Set to true for an ES5 that is likely to have dozens of users 
     *  logging on during the same minute, but then games should check 
     *  that the user has finished the login process.
     **/
    private boolean useTwoStepLogin = false;
    /**
     *  If this is true and the ES5 thinks there is already a user logged
     *  on with this username, the other user will be kicked from the server.
     *  Recommended as true when useTwoStepLogin is false.  Use false if 
     *  useTwoStepLogin is true unless the client gets the username from a cookie
     *  created when he logs on to the website (same database required).
     */
    private boolean evictGhostUsers = !useTwoStepLogin;
    /**
     *  If the username is not in the database, do we allow login and register
     *  this user?  Not allowed if useTwoStepLogin = true even if this is set to true.
     */
    private boolean allowRegistration = !useTwoStepLogin;
    public static final String USE_TWO_STEP_LOGIN = "useTwoStepLogin";
    private static final String EVICT_GHOST_USERS = "evictGhostUsers";
    public static final String ALLOW_REGISTRATION = "allowRegistration";

    @Override
    public void init(EsObjectRO parameters) {
        useTwoStepLogin = parameters.getBoolean(USE_TWO_STEP_LOGIN, useTwoStepLogin);
        evictGhostUsers = parameters.getBoolean(EVICT_GHOST_USERS, evictGhostUsers);
        allowRegistration = parameters.getBoolean(ALLOW_REGISTRATION, allowRegistration);
        controller = (Controller) getApi().acquireManagedObject("ControllerFactory", null);
        logger = getApi().getLogger();
    }

    protected final Controller getController() {
        return controller;
    }
    
    public boolean allowPluginRegistration() {
        return allowRegistration;
    }
    
    public boolean usePluginForLogin() {
        return useTwoStepLogin;
    }

    @Override
    public ChainAction executeLogin(final LoginContext context) {

        // Get the username
        String userName = context.getUserName();
        String password = context.getPassword();
        
        // The response esob can be read by the client from the LoginResponse.
        EsObject response = context.getResponseParameters();
        
        if (userName == null || userName.isEmpty()) {
            // not allowed
                response.setString(LoginResultEnum.Status.name(), LoginResultEnum.UsernameEmpty.name());
                return ChainAction.Fail;
        }
        
        // if you do not want to allow a default password, return
        // ChainAction.Fail inside this IF
        if (password == null || password.isEmpty()) {
            password = "default";
        }

        logger.debug("{} logging in with password {}", userName, password);

        // Optional information can be read from context.getRequestParameters()
        // such as avatar name or a boolean indicating that this is a new user.
        EsObjectRO request = context.getRequestParameters();

        if (useTwoStepLogin) {
            // no DB lookup here
            if (evictGhostUsers && getApi().isUserLoggedIn(userName)) {
                // we assume that this other user is a ghost.  
                // Evict doesn't really send the evicted user any message.
                getApi().evictUserFromServer(userName, response);
                return ChainAction.OkAndContinue;
            } else if (getApi().isUserLoggedIn(userName)) {
                response.setString(LoginResultEnum.Status.name(), LoginResultEnum.AlreadyLoggedOn.name());
                return ChainAction.Fail;
            }
        }

        // if !useTwoStepLogin
        if (evictGhostUsers && getApi().isUserLoggedIn(userName)) {
            // we assume that this other user is a ghost.  
            // Evict doesn't really send the evicted user any message.
            getApi().evictUserFromServer(userName, response);
        }

        logger.debug("Attempting to load user info");
        UserObject userInfo = controller.getUserInfo(userName);

        if (userInfo == null) {
            if (allowRegistration) {
                // TODO: optional, add checks here for valid userName, password
                
                logger.debug("Attempting to register user");
                
                LoginResultEnum result = controller.registerNewUser(userName, password);
                response.setString(LoginResultEnum.Status.name(), result.name());
                context.setResponseParameters(response);
                if (result == LoginResultEnum.Approved) {
                    return ChainAction.OkAndContinue;
                } else {
                    return ChainAction.Fail;
                }
            } else {
                response.setString(LoginResultEnum.Status.name(), LoginResultEnum.UserNotFound.name());
                context.setResponseParameters(response);
                return ChainAction.Fail;
            }
        }

        if (userInfo.doesPasswordMatch(password)) {
            logger.debug("{} logged in successfully", userName);
            logger.debug("{} now has rank {}", userName, userInfo.getRank());
            response.setString(LoginResultEnum.Status.name(), LoginResultEnum.Approved.name());
            context.setResponseParameters(response);
            return ChainAction.OkAndContinue;
        } else {
            logger.debug("{} failed login (password did not match)", userName);
            response.setString(LoginResultEnum.Status.name(), LoginResultEnum.WrongPassword.name());
            context.setResponseParameters(response);
            return ChainAction.Fail;
        }
    }
}
