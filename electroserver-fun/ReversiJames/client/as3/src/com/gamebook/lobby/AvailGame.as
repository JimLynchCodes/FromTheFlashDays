package com.gamebook.lobby 
{
	import com.electrotank.electroserver5.api.EsObject;
	
	public class AvailGame 
	{
		
        public var gameId : int = LobbyConstants.PIXEL_GAME;
        public var name : String = "";

		public function AvailGame(obj:EsObject = null) {
			if (obj) {
				name = obj.getString(LobbyConstants.PLAYER_NAME);
				gameId = obj.getInteger(LobbyConstants.ID);
			}
		}
		
        public function clear() : void {
            gameId = LobbyConstants.PIXEL_GAME;
            name = "";
        }

        public function setAI() : void {
            name = LobbyConstants.AI_NAME;
            gameId = LobbyConstants.PIXEL_GAME;
        }

        public function setQuickJoin() : void {
            name = LobbyConstants.QUICK_JOIN_NAME;
            gameId = LobbyConstants.QUICK_JOIN;
        }

        public function setCreateNew() : void {
            name = LobbyConstants.CREATE_NEW_NAME;
            gameId = LobbyConstants.CREATE_NEW;
        }
		
	}
	
}