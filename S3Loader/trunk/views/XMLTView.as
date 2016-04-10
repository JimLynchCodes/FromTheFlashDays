package com.fs.edu.xml_tut.views
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	
	public class XMLTView extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		private var _xmlUrlLoader:URLLoader;
		private var _xmlData:XML;
		private var _xmlPath:URLRequest;
		private var _imageLoader:Loader;
		private var _imagePath:URLRequest;
		private var _loadedBytesTF:TextField;
		private var _totalBytesTF:TextField;
		private var _box:Sprite;
		private var _loadXmlBtn:SimpleButton;
		private var _loadImageBtn:SimpleButton;
		private var _loadSwfBtn:SimpleButton;
		private var _xmlLoader2:URLLoader;
		private var _xmlData2:XML;
		private var _xmlRequest2:URLRequest;
		private var _imgLoader2:Loader;
		private var _imagePathRequest2:URLRequest;
		private var _loadedImage:Loader;
		private var _xmlTF:TextField;
		private var _downArrowBtn:SimpleButton;
		private var _upArrowBtn:SimpleButton;
		private var _currentArrow:String;
		private var _swfLoader:Loader;
		private var _swfPathRequest:URLRequest;
		private var _loadedSwf:MovieClip = null;
		private var _loadedSwfPlaying:Boolean = false;;
		private var _xmlLoaded:Boolean;
		private var _getStringsBtn:SimpleButton;
		private var _lineString:String;
		private var _begNameValueIndex:int;
		private var _endNameValueIndex:int;
		private var _nameValue:Object;
		private var _i:uint;
		private var _imageIsVisible:Boolean;
		private var _loaderContext:LoaderContext;
		
		
		public function XMLTView(model:Object, controller:Object, stage:Object)
		{

			_model = model;			
			_controller = controller;
			_stage = stage;
			
			init();
			
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("Main View Initialized.");
			
			_stage.addChild(_box);
			_box.x = 5
			_box.y = 5
				
//			beginXmlParsing();
			
		}
		
		private function beginXmlParsing():void
		{
			
				// add the URL loader that you send the path o the xml
			_xmlUrlLoader = new URLLoader();
				// the xml data itself (assigned to output of loading the path)
			_xmlData = new XML();
			
				// xml path
//			---------------------------------------------------------------------------
			
				
		/**
				// load xml file from the tutorial website					
			_xmlPath = new URLRequest("http://www.kirupa.com/net/files/sampleXML.xml");
				
//		**/
			
		/**	
				// laod xml file from my website
			_xmlPath = new URLRequest("http://www.goldenliongames.com/xml.html");
			
//		**/	
			
//		/**	
				// laod xml file from my repository
//			_xmlPath = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/sampleXmlFile.xml");
			
//		**/	
			
		/**	
				// load xml file from server
			_xmlPath = new URLRequest("sampleXmlFile.xml");
			
//		**/	
			
		/**	
				// load xml file from S3
			_xmlPath = new URLRequest("sampleXmlFile.xml");
			
//		**/	
			
			
			
			
			
			
//			---------------------------------------------------------------------------			
			
			
				// listen for when the xml is done being loaded
			_xmlUrlLoader.addEventListener(Event.COMPLETE, onXmlDoneBeingLoaded);
			
				// don't forget to say "Load!"
			_xmlUrlLoader.load(_xmlPath);
			
			
				// now load an image
			
				// intantiate a new loader
			_imageLoader = new Loader();
			
			
			
				// specify the path to it
//			_imagePath = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/brain.png");
			
				// add a listener for when it is complete
				// NOTE: add listeners to "loader.contentLoaderInfo" and not just the loader for image & swf files!
			
			
			_imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onImageLoadProgress);
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageDoneBeingLoaded);
			
				//load it up
			_imageLoader.load(_imagePath);
			
		}		
		
		protected function onImageLoadProgress(event:ProgressEvent):void
		{
			_loadedBytesTF.text = "Loaded: " + Math.floor(event.bytesLoaded) + " KB ";
			_totalBytesTF.text = "Loaded: " + Math.floor(event.bytesLoaded) + " KB ";
			
			
			
		}
		
		protected function onImageDoneBeingLoaded(event:Event):void
		{
			
			_stage.addChild(_imageLoader);
			_imageLoader.x = 100;
			_imageLoader.y = 20;
			
//			var _loadedImage:BitmapData = _imageLoader.content as BitmapData;
//			
//			_stage.addChild(_loadedImage);
			
//			trace("complete");
			
			
			
		}		
		
		protected function onXmlDoneBeingLoaded(event:Event):void
		{
			trace("	xml done   ");
			
			_xmlData = new XML( event.target.data );
			
			trace(_xmlData);
			
		}
		
		
		private function assignVars():void
		{
			_configu = _model.configu;
			
			var _boxClass:Class = getDefinitionByName("Box") as Class;
			_box = new _boxClass() as Sprite;
			
			_loadXmlBtn = _box["loadXmlBtn"];
			_loadImageBtn = _box["loadImageBtn"];
			_loadSwfBtn = _box["loadSwfBtn"];
			
			_xmlTF = _box["xmlTF"];
			
			_upArrowBtn = _box["upArrowBtn"];
			_downArrowBtn = _box["downArrowBtn"];
			
			_getStringsBtn = _box["getStringsBtn"];
			
			
		}
		
		
		private function addListeners():void
		{
			
			_model.addEventListener(_configu.KEYBOARD_CHANGE, keyboardChangeHandler);
			_model.addEventListener(_configu.MOUSE_CLICK_CHANGE, mouseChangeHandler);
			
			_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_loadXmlBtn.addEventListener(MouseEvent.CLICK, onLoadXmlBtnClick);
			_loadImageBtn.addEventListener(MouseEvent.CLICK, onLoadImageBtnClick);
			_loadSwfBtn.addEventListener(MouseEvent.CLICK, onLoadSwfBtnClick);
			
			_getStringsBtn.addEventListener(MouseEvent.CLICK, ongetStringsBtnClick);
			
			_upArrowBtn.addEventListener(MouseEvent.MOUSE_DOWN, onArrowBtnDown);
			_downArrowBtn.addEventListener(MouseEvent.MOUSE_DOWN, onArrowBtnDown);
			
			
		}
		
		
		protected function ongetStringsBtnClick(event:MouseEvent):void
		{
			if (_xmlLoaded == true)
			{
				
				var theSprites:XMLList = _xmlData..lineObject

				trace(theSprites);
				
				//--------------------------------------
				//	create the rectangles
				//--------------------------------------
				
				_i = 0;
				_xmlTF.text = "";
				
				for each ( var _lineXml:XML in theSprites)
				{
					_i++;
					trace(_lineXml);
					
					_lineString = _lineXml.toXMLString();
					
					_begNameValueIndex = _lineString.indexOf('\"') + 1;
					_endNameValueIndex = _lineString.indexOf('\"', ( _begNameValueIndex + 1));
					_nameValue = _lineString.substring(_begNameValueIndex, _endNameValueIndex);
					
					trace("String " + _i + " : " + _nameValue);
					
					
					_xmlTF.text += "String " + _i + " : " + _nameValue + "\n";
						
//					trace("_lineString " + _lineString);
				}
				
				
			}
			
		}
		
		
		protected function onArrowBtnDown(event:MouseEvent):void
		{
			trace("mouse down");
			switch(event.currentTarget.name)
			{
				 case "upArrowBtn":
					 	_currentArrow = "up";
					 break;
				
				 case "downArrowBtn":
						_currentArrow = "down";
					 break;
				
				
			}
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, onArrowBtnUp);
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrameWhileHoldingArrow);
				
			_xmlTF.scrollV = _xmlTF.scrollV + _model.configu.SCROLL_SPEED;
		}
		

		protected function onEnterFrameWhileHoldingArrow(event:Event):void
		{
			if (_currentArrow == "up")
			{
				_xmlTF.scrollV = _xmlTF.scrollV - _model.configu.SCROLL_SPEED;
			}
			
			else if (_currentArrow == "down")
			{
				_xmlTF.scrollV = _xmlTF.scrollV + _model.configu.SCROLL_SPEED;
			}
		}		
		
		
		protected function onArrowBtnUp(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onArrowBtnUp);
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameWhileHoldingArrow);
			
		}		
		
		
		protected function onLoadSwfBtnClick(event:MouseEvent):void
		{
			if (_loadedSwf == null)
			{
				trace("here");
				_swfLoader = new Loader();
				trace(_swfLoader);
				
					// load from my beanstalk
//				_swfPathRequest = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/dumb_rect.swf");
				
					// load from server
//				_swfPathRequest = new URLRequest("dumb_rect.swf");
				
				
					// load from s3
				_swfPathRequest = new URLRequest("https://s3.amazonaws.com/xmlFiles/Rect3.swf");
				
				trace(_swfPathRequest);
				
				
				_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoadComplete);
				//
				//			
//				var content1: LoaderContext = new LoaderContext();//Then to check out secure link checkPolicyFile property can be set to true.
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.securityDomain = SecurityDomain.currentDomain;
//				content1.checkPolicyFile = true;
					
				_swfLoader.load(_swfPathRequest, loaderContext);	
					
				
//				_swfLoader.load(_swfPathRequest);
			}
			
			if (_loadedSwfPlaying == true && _loadedSwf != null)
			{
				trace(_loadedSwfPlaying)
				_stage.removeChild(_loadedSwf);
				_loadedSwfPlaying = false;
				
			}
			
			else if (_loadedSwfPlaying == false && _loadedSwf != null)
			{
				trace(_loadedSwfPlaying)
				_stage.addChild(_loadedSwf);
				_loadedSwfPlaying = true;
				
			}
			
		
		}

		
		protected function onSwfLoadComplete(event:Event):void
		{
			
				_loadedSwf = event.target.content
				
				trace(event.target.content);
				
				_stage.addChild(_loadedSwf);
				_loadedSwfPlaying = true;
				trace("_loadedSwf.x " + _loadedSwf.x);
				trace("_loadedSwf.y " + _loadedSwf.y);
				
				_loadedSwf.y = -50;
			
		}		
		
		protected function onLoadImageBtnClick(event:MouseEvent):void
		{
			
			if (_loadedImage == null)
			{
				
				trace("clicked");
				_imgLoader2 = new Loader();		
				
				
				// load from my beanstalk
//				_imagePathRequest2 = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/brain.png");
				
//				_imagePathRequest2 = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/brain.png");
				
				
					// load from server folder
//				_imagePathRequest2 = new URLRequest("brain.png");
				
					// load from s3
				_imagePathRequest2 = new URLRequest("https://s3.amazonaws.com/xmlFiles/first/brain.png");
					
				
				_imgLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onImg2Loaded);	
				
				_imgLoader2.load(_imagePathRequest2);
				
				_imageIsVisible = true;
				
				
				
			}
			
			else
			{
				if (_imageIsVisible == true)
				{
					_imageIsVisible = false;
					_loadedImage.visible = false;
				}
				
				else if (_imageIsVisible == false)
				{
					_loadedImage.visible = true;
					_imageIsVisible = true;
				}
				
				
			}
			

		}
		
		protected function onImg2Loaded(event:Event):void
		{
			
			_loadedImage =_imgLoader2;
			trace(_loadedImage);
			trace(_imgLoader2);
			_stage.addChild(_loadedImage);
			
			_loadedImage.x = 100;
			_loadedImage.y = 100;
			
		}		
		
		protected function onLoadXmlBtnClick(event:MouseEvent):void
		{
			
			trace("clicked");
			_xmlLoader2 = new URLLoader();		
			_xmlData2 = new XML();
			
			
	/**		
				// load from my beanstalk
			_xmlRequest2 = new URLRequest("https://golden-lion-games.svn.beanstalkapp.com/xmlnewguy/trunk/sampleXmlFile.xml");
//	**/
			
				// load from tmc server
				// put the xml in the same publish path as the document fla
			
			
				

				// load from server
//			_xmlRequest2 = new URLRequest("sampleXmlFile.xml");	
			
				// load from s3
			_xmlRequest2 = new URLRequest("https://s3.amazonaws.com/xmlFiles/first/explosion_guy.xml");	
			
			
			
			_xmlLoader2.addEventListener(Event.COMPLETE, onXmlLoaded);	
			
			_xmlLoader2.load(_xmlRequest2);
				
		}	
		
		protected function onXmlLoaded(event:Event):void
		{
			_xmlData = new XML(event.target.data);
			trace(_xmlData);
			
			_xmlTF.text = "";
			_xmlTF.text += _xmlData;
			_xmlLoaded = true;
			
			
		}		
		
		private function addedToStageHandler(event:Event):void
		{
			trace("Main view added to stage.");
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			_stage.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function keyDownHandler(event:KeyboardEvent):void
		{

			_controller.processKeyPress(event);
			
		}
		
		
		private function onMouseClick(m:MouseEvent):void
		{

			_controller.processMouseClick(m);
		
		}
		
		
		private function keyboardChangeHandler(event:Event):void
		{

			trace("the " + _model.keyDirection + "key")
			
			
		}
		
		
		private function mouseChangeHandler(e:Event):void
		{

			trace(_model.clicks + " clicks");
			
			
			
		}
		
		
		
	}
}