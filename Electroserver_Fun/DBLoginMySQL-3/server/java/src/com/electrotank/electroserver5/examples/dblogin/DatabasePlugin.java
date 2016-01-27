package com.electrotank.electroserver5.examples.dblogin;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.UserServerVariableResponse;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import org.slf4j.Logger;

public class DatabasePlugin extends BasePlugin {
    
    private Controller controller;
    private Logger logger;
    private boolean useTwoStepLogin = false;
    private boolean allowRegistration = false;
    private EsObject info;

    @Override
    public void init(EsObjectRO parameters) {
        controller = (Controller) getApi().acquireManagedObject("ControllerFactory", null);
        logger = getApi().getLogger();
        
        useTwoStepLogin = parameters.getBoolean(DBLoginHandler.USE_TWO_STEP_LOGIN, useTwoStepLogin);
        allowRegistration = parameters.getBoolean(DBLoginHandler.ALLOW_REGISTRATION, allowRegistration);
        
        initInfoEsOb();
    }
    
    @Override
    public void request(String user, EsObjectRO requestParameters) {
        EsObject messageIn = new EsObject();
        messageIn.addAll(requestParameters);
        logger.debug(user + " requests: " + messageIn.toString());

        String actionTag = messageIn.getString(TransactionTags.ACTION.getTag(), "");
        
        if (actionTag.equals(TransactionTags.TAG_LOGIN.getTag())) {
            handleLoginRequest(user, messageIn);
        } else if (actionTag.equals(TransactionTags.TAG_GET_RANK.getTag())) {
            if (checkUserApprovedKickIfNot(user)) {
                handleGetRankRequest(user, messageIn, false);
            }
        } else if (actionTag.equals(TransactionTags.TAG_ADD_TO_RANK.getTag())) {
            if (checkUserApprovedKickIfNot(user)) {
                handleAddToRankRequest(user, messageIn, false);
            }
        } else if (actionTag.equals(TransactionTags.TAG_REGISTER.getTag())) {
            handleRegisterRequest(user, messageIn);
        } else {
            sendError(user, "ActionTagNotHandled", false);
        }
    }
    
    @Override
    public EsObject interop(EsObjectRO parameters) {
        EsObject messageIn = new EsObject();
        messageIn.addAll(parameters);
        logger.debug("interop requests: " + messageIn.toString());

        String actionTag = messageIn.getString(TransactionTags.ACTION.getTag(), "");
        String user = messageIn.getString(TransactionTags.TAG_USER.getTag(), "");
        if (actionTag.equals(TransactionTags.TAG_GET_RANK.getTag())) {
            return handleGetRankRequest(user, messageIn, false);
        } else if (actionTag.equals(TransactionTags.TAG_ADD_TO_RANK.getTag())) {
            return handleAddToRankRequest(user, messageIn, false);
        } else {
            return sendError(user, "ActionTagNotHandled", false);
        }
    }

    public EsObject handleGetRankRequest(String user, EsObject messageIn, boolean isInterop) {
        UserObject userInfo = controller.getUserInfo(user);
        int userRank = -1;
        if (userInfo != null) {
            userRank = userInfo.getRank();
        }
        messageIn.setInteger(TransactionTags.TAG_GET_RANK.getTag(), userRank);
        return sendAndLog("handleGetRankRequest", user, messageIn, isInterop);
    }

    public EsObject handleAddToRankRequest(String user, EsObject messageIn, boolean isInterop) {
        // default is adding 1
        int delta = messageIn.getInteger(TransactionTags.TAG_ADD_TO_RANK.getTag(), 1);
        int rank = controller.addToRank(user, delta);
        messageIn.setInteger(TransactionTags.TAG_GET_RANK.getTag(), rank);
        return sendAndLog("handleAddToRankRequest", user, messageIn, isInterop);
    }

    public void handleRegisterRequest(String user, EsObject messageIn) {
        if (!allowRegistration) {
            sendError(user, LoginResultEnum.RegistrationsNotAllowed.name(),  false);
            handleLoginRequest(user, messageIn);
            return;
        }
        String password = messageIn.getString(TransactionTags.TAG_PASSWORD.getTag(), "default");
        if (password.isEmpty()) {
            password = "default";
        }
        LoginResultEnum result = controller.registerNewUser(user, password);
        messageIn.setString(TransactionTags.TAG_STATUS.getTag(), result.name());
        if (result == LoginResultEnum.Approved) {
            // mark the user as allowed to play games and join rooms
            markUserAsApproved(user);

            // inform user
            sendAndLog("handleRegisterRequest", user, messageIn, false);
        } else {
            sendError(user, result.name(),  false);
            getApi().kickUserFromServer(user, messageIn);
        }
    }
    
    public void  handleLoginRequest(String user, EsObject messageIn) {
        if (!useTwoStepLogin) {
            // ignore this request
            return;
        }
        
        String password = messageIn.getString(TransactionTags.TAG_PASSWORD.getTag(), "default");
        if (password.isEmpty()) {
            password = "default";
        }
        UserObject userInfo = controller.getUserInfo(user);
        if (userInfo == null) {
            if (allowRegistration) {
                handleRegisterRequest(user, messageIn);
                return;
            } else {
                sendError(user, LoginResultEnum.UserNotFound.name(),  false);
                messageIn.setString(TransactionTags.TAG_STATUS.getTag(), LoginResultEnum.UserNotFound.name());
                getApi().kickUserFromServer(user, messageIn);
                return;
            }
        }
        
        if (userInfo.doesPasswordMatch(password)) {
            // mark the user as allowed to play games and join rooms
            markUserAsApproved(user);

            // inform user
            messageIn.setString(TransactionTags.TAG_STATUS.getTag(), LoginResultEnum.Approved.name());
            sendAndLog("handleLoginRequest", user, messageIn, false);
        } else {
            messageIn.setString(TransactionTags.TAG_STATUS.getTag(), LoginResultEnum.WrongPassword.name());
            sendError(user, LoginResultEnum.WrongPassword.name(),  false);
            getApi().kickUserFromServer(user, messageIn);
        }
    }
    
    public boolean checkUserApprovedKickIfNot(String user) {
        boolean approved = isUserApproved(user);
        if (!approved) {
            EsObject obj = sendError(user, "SecondStepLoginRequired", false);
            getApi().kickUserFromServer(user, obj);
        }
        return approved;
    }

    public EsObject sendError(String user, String errDescription, boolean isInterop) {
        EsObject errMessage = new EsObject();
        errMessage.setString(TransactionTags.ACTION.getTag(), TransactionTags.TAG_ERROR.getTag());
        errMessage.setString(TransactionTags.TAG_ERROR.getTag(), errDescription);
        return sendAndLog("sendError", user, errMessage, isInterop);
    }
    
    public boolean isUserApproved(String user) {
        if (!useTwoStepLogin) {
            return true;
        }
        
        UserServerVariableResponse usvr = getApi().getUserServerVariable(user,
                                                 "info");
        if (usvr == null) {
            return false;
        } else if (!usvr.isSuccess()) {
            logger.debug("Error getting UserServerVariable for " + user);
            return false;
        } else {
            EsObject value = usvr.getValue();
            if (value == null || !value.variableExists("ok")) {
                return false;
            } else {
                boolean ok = value.getBoolean("ok", false);
                return ok;
            }
        }
    }
    
    private void markUserAsApproved(String user) {
        UserServerVariableResponse usvr = getApi().setUserServerVariable(user,
                                                 "info",
                                                 info);
        if (!usvr.isSuccess()) {
            logger.debug("Error adding UserServerVariable for " + user);
        }
    }
    
    private void initInfoEsOb() {
        info = new EsObject();
        info.setBoolean("ok", true);
    }

    private EsObject sendAndLog(String from, String user, EsObject messageOut, boolean isInterop) {
        logger.debug(from + " sends message to " + user + ":" + messageOut.toString());
        if (!isInterop) {
            getApi().sendPluginMessageToUser(user, messageOut);
        }
        return messageOut;
    }

}
