package com.electrotank.electroserver5.examples.databasewithjdbi;

import com.electrotank.electroserver5.extensions.BaseLoginEventHandler;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.LoginContext;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import org.slf4j.Logger;

public class SimpleDBLoginHandler extends BaseLoginEventHandler {

    private Controller controller;
    private Logger logger;

    @Override
    public void init(EsObjectRO esObjectRO) {
        controller = (Controller) getApi().acquireManagedObject("ControllerFactory", null);
        logger = getApi().getLogger();
    }

    protected final Controller getController() {
        return controller;
    }

    @Override
    public ChainAction executeLogin(final LoginContext context) {

        // Get the username
        String userName = context.getUserName();
        String password = context.getPassword();
        if (password == null || password.isEmpty()) {
            password = "default";
        }

        logger.debug("{} logging in with password {}", userName, password);

        EsObject response = context.getResponseParameters();

        if (controller.doesUsernameExist(userName)) {
            if (!controller.doesPasswordMatch(userName, password)) {
                response.setString("err", "PasswordDoesNotMatch");
                logger.debug("{} failed login (password did not match)", userName);
                return ChainAction.Fail;
            } else {
                // successful login!
                if (logger.isDebugEnabled()) {
                    int rank = controller.getUserRank(userName);
                    logger.debug("{} now has rank {}", userName, rank);
                }
            }
        } else {
            // TODO: optional, add checks here for valid userName, password
            
            // register as new user
            controller.registerNewUser(userName, password);
        }

        logger.debug("{} logged in successfully", userName);
        return ChainAction.OkAndContinue;
    }
}
