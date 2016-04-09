package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CharChoiceButton extends Sprite
	{
		
		private var _isSelected:Boolean = false;
		private var _notSelectedImage:Image;
		private var _selectedImage:Image;
		private var _index:int;
		public var charName:String
		public var costToBuyBrains:int;
		public var costToBuyCoins:int;
		public var shortName:String;
		
		public function CharChoiceButton(index:int)
		{
			
			_index = index;
			
			switch(index)
			{
				case 0:
					charName = "Headmond X. Splodington";
					shortName = "headmond"
					_notSelectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char1ShopBtn"));
					_selectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char1ShopBtnSelected"));
					costToBuyBrains = 0;
					break;
				
				case 1:
					charName = "Olivia Swiggles"
					shortName = "olivia";
					_notSelectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char2ShopBtn"));
					_selectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char2ShopBtnSelected"));
					costToBuyBrains = 900;
					break;
				
				case 2:
					charName = "Fitness Francesca";
					shortName = "francesca";
					_notSelectedImage = new Image(Assets.getTextureAtlas(3).getTexture("FitnessGirlShopBtn"));
					_selectedImage = new Image(Assets.getTextureAtlas(3).getTexture("FitnessGirlShopBtnSelected"));
					costToBuyBrains = 1100;
					break;

				case 3:
					charName = "Tony Mazzarolli";
					shortName = "tony";
					_notSelectedImage = new Image(Assets.getTextureAtlas(3).getTexture("TonyShopBtn"));
					_selectedImage = new Image(Assets.getTextureAtlas(3).getTexture("TonyShopBtnSelected"));
					costToBuyBrains = 3100;
					break;

				default:
					charName = "Error Loading Index " + index;
						shortName = "X";
					_notSelectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char2ShopBtn"));
					_selectedImage = new Image(Assets.getTextureAtlas(3).getTexture("Char2ShopBtnSelected"));
					break;
			}
				
			
			
			addChild(_notSelectedImage);
			addChild(_selectedImage);
			
			_notSelectedImage.visible = true;
			_selectedImage.visible = false;

		}
		
		private function onTrig():void
		{
			trace("trig")
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			if (value == true)
			{
				_notSelectedImage.visible = false;
				_selectedImage.visible = true;
				
			}
			else
			{
				_notSelectedImage.visible = true;
				_selectedImage.visible = false;
				
			}
			
			_isSelected = value;
		}

	}
}