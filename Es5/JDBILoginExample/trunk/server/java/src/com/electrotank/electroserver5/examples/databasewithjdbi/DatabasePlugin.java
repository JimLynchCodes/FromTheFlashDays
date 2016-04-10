package com.electrotank.electroserver5.examples.databasewithjdbi;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import org.slf4j.Logger;

public class DatabasePlugin extends BasePlugin {
    
    private Controller controller;
    private Logger logger;

    @Override
    public void init(EsObjectRO esObjectRO) {
        controller = (Controller) getApi().acquireManagedObject("ControllerFactory", null);
        logger = getApi().getLogger();
    }
    
    @Override
    public void request(String user, EsObjectRO requestParameters) {
        EsObject messageIn = new EsObject();
        messageIn.addAll(requestParameters);
        logger.debug(user + " requests: " + messageIn.toString());

        String actionTag = messageIn.getString(TransactionTags.ACTION.getTag(), "");
        if (actionTag.equals(TransactionTags.TAG_GET_RANK.getTag())) {
            handleGetRankRequest(user, messageIn, false);
        } else if (actionTag.equals(TransactionTags.TAG_ADD_TO_RANK.getTag())) {
            handleAddToRankRequest(user, messageIn, false);
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
        int userRank = controller.getUserRank(user);
        messageIn.setInteger(TransactionTags.TAG_GET_RANK.getTag(), userRank);
        return sendAndLog("handleGetRankRequest", user, messageIn, isInterop);
    }

    public EsObject handleAddToRankRequest(String user, EsObject messageIn, boolean isInterop) {
        // default is adding 1
        int delta = messageIn.getInteger(TransactionTags.TAG_ADD_TO_RANK.getTag(), 1);
        controller.addToRank(user, delta);
        int userRank = controller.getUserRank(user);
        messageIn.setInteger(TransactionTags.TAG_GET_RANK.getTag(), userRank);
        return sendAndLog("handleAddToRankRequest", user, messageIn,isInterop);
    }

    public EsObject sendError(String user, String errDescription, boolean isInterop) {
        EsObject errMessage = new EsObject();
        errMessage.setString(TransactionTags.ACTION.getTag(), TransactionTags.TAG_ERROR.getTag());
        errMessage.setString(TransactionTags.TAG_ERROR.getTag(), errDescription);
        return sendAndLog("sendError", user, errMessage, isInterop);
    }
    
    private EsObject sendAndLog(String from, String user, EsObject messageOut, boolean isInterop) {
        logger.debug(from + " sends message to " + user + ":" + messageOut.toString());
        if (!isInterop) {
            getApi().sendPluginMessageToUser(user, messageOut);
        }
        return messageOut;
    }

}
