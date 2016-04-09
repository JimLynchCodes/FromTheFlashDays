(function (lib, img, cjs) {

var p; // shortcut to reference prototypes

// library properties:
lib.properties = {
	width: 160,
	height: 600,
	fps: 24,
	color: "#FFFFFF",
	manifest: [
		{src:"images/Image.png", id:"Image"},
		{src:"images/Image_1.png", id:"Image_1"},
		{src:"images/Mesh.png", id:"Mesh"},
		{src:"images/Path_11.png", id:"Path_11"},
		{src:"images/Path_15.png", id:"Path_15"},
		{src:"images/Path_18_1.png", id:"Path_18_1"},
		{src:"images/Path_1_3.png", id:"Path_1_3"},
		{src:"images/Path_2_4.png", id:"Path_2_4"},
		{src:"images/Diamond1.png", id:"Diamond1"},
		{src:"images/Explosion1spritesheet.png", id:"Explosion1spritesheet"},
		{src:"images/guybodyimage.png", id:"guybodyimage"},
		{src:"images/HeadExploderBackground.png", id:"HeadExploderBackground"},
		{src:"images/USGS19LandInundation.png", id:"USGS19LandInundation"}
	]
};

// stage content:
(lib.HEbanner = function(mode,startPosition,loop) {
	this.initialize(mode,startPosition,loop,{});

	// timeline functions:
	this.frame_0 = function() {
		//stage = new createjs.Stage(canvas);
		
		this.explodeBtn.addEventListener("click", onClicked);
		explosion = this.explosion;
		
		//this.explosion.addEventListener("click", onClicked);
		this.explosion.stop();
		this.titleText.wordwrap = true;
		
		_charHead = this.charHead;
		var tl = new TimelineMax();
		tl.to(this.titleText, .5, {rotation:360, onComplete:onSpinDelay});
		//TweenMax.to(_charHead, 2, {y:400, visibility:false});
		tl.to(this.titleText, 1, {scaleX:1.3, scaleY:1.3});
		tl.to(this.titleText, 1, {scaleX:1.1, scaleY:1.1});
		//stage.enableMouseOver();
		this.explodeBtn.cursor = 'text';
		
		var clickTextTl = new TimelineMax();
		clickTextTl.to(this.clickText, 2, {y:"-=20"});
		clickTextTl.to(this.clickText, 2, {y:"+=20"});
		clickTextTl.repeat(50);
		
		function onClicked(){
			console.log("clicked");
			explosion.play();
			//_charHead.style.display = 'none';
			// _charHead.alpha = 0; 
			_charHead.visible = false;
			
		}
		
		function onSpinDelay()
		{
			console.log("On spin delay");
		}
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Layer 1
	this.clickText = new lib.ClickText();
	this.clickText.setTransform(153.2,485.2,1,1,0,0,0,73.2,56.6);

	this.titleText = new lib.TitleText();
	this.titleText.setTransform(80,60.1,1,1,0,0,0,79.1,45);

	this.explodeBtn = new lib.ExplodeBtn();
	this.explodeBtn.setTransform(140,583.6,0.704,0.704,0,0,0,178.2,71.5);
	new cjs.ButtonHelper(this.explodeBtn, 0, 1, 1);

	this.text = new cjs.Text("Click the button to make his head explode!", "bold 19px 'Lithos Pro Regular'", "#77FFAD");
	this.text.textAlign = "center";
	this.text.lineHeight = 19;
	this.text.lineWidth = 207;
	this.text.setTransform(440.7,290.2);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.text},{t:this.explodeBtn},{t:this.titleText},{t:this.clickText}]}).wait(1));

	// Explosion Anim
	this.explosion = new lib.ExplosionMc();
	this.explosion.setTransform(83.4,178.7,1,1,0,0,0,131,130);

	this.timeline.addTween(cjs.Tween.get(this.explosion).wait(1));

	// CharHead
	this.charHead = new lib.CharHead();
	this.charHead.setTransform(94.2,165,1,1,0,0,0,46.5,63.5);

	this.timeline.addTween(cjs.Tween.get(this.charHead).wait(1));

	// CharBody
	this.instance = new lib.TonyBody();
	this.instance.setTransform(89.7,-299.4);

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	// FlashAICB
	this.instance_1 = new lib.HeadExploderBackground();

	this.timeline.addTween(cjs.Tween.get(this.instance_1).wait(1));

}).prototype = p = new cjs.MovieClip();
p.nominalBounds = new cjs.Rectangle(76.9,300,551.3,820);


// symbols:
(lib.Image = function() {
	this.initialize(img.Image);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,164,224);


(lib.Image_1 = function() {
	this.initialize(img.Image_1);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,4731,4732);


(lib.Mesh = function() {
	this.initialize(img.Mesh);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,35,50);


(lib.Path_11 = function() {
	this.initialize(img.Path_11);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,82,59);


(lib.Path_15 = function() {
	this.initialize(img.Path_15);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,209,309);


(lib.Path_18_1 = function() {
	this.initialize(img.Path_18_1);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,34,132);


(lib.Path_1_3 = function() {
	this.initialize(img.Path_1_3);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,86,72);


(lib.Path_2_4 = function() {
	this.initialize(img.Path_2_4);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,151,214);


(lib.Diamond1 = function() {
	this.initialize(img.Diamond1);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,72,72);


(lib.Explosion1spritesheet = function() {
	this.initialize(img.Explosion1spritesheet);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,2048,1536);


(lib.guybodyimage = function() {
	this.initialize(img.guybodyimage);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,228,384);


(lib.HeadExploderBackground = function() {
	this.initialize(img.HeadExploderBackground);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,160,600);


(lib.USGS19LandInundation = function() {
	this.initialize(img.USGS19LandInundation);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,72,72);


(lib.TonyBody = function() {
	this.initialize();

	// Layer 1
	this.instance = new lib.guybodyimage();
	this.instance.setTransform(-81,491.9,0.579,0.579);

	this.addChild(this.instance);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-81,491.9,132,222.3);


(lib.TitleText = function() {
	this.initialize();

	// Layer 1
	this.tf = new cjs.Text("Head Exploder!", "32px 'Hobo Std'", "#FFFFFF");
	this.tf.name = "tf";
	this.tf.textAlign = "center";
	this.tf.lineHeight = 34;
	this.tf.lineWidth = 154;
	this.tf.setTransform(77.1,0);
	this.tf.shadow = new cjs.Shadow("rgba(0,0,0,1)",0,0,4);

	this.addChild(this.tf);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-4,-4,170,102);


(lib.ExplosionMc = function(mode,startPosition,loop) {
	this.initialize(mode,startPosition,loop,{});

	// timeline functions:
	this.frame_24 = function() {
		this.stop();
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).wait(24).call(this.frame_24).wait(1));

	// explosion
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-306.6,-96.1)).s().p("AvAvAIeBAAIAAeBI+BAAg");
	this.shape.setTransform(129.8,134.7,1.141,1.141);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-686,-96.1)).s().p("AtePBIAA+BIa9AAIAAeBg");
	this.shape_1.setTransform(120.3,127.7,1.141,1.141);

	this.shape_2 = new cjs.Shape();
	this.shape_2.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1079.8,-96.1)).s().p("Au5PBIAA+BIdzAAIAAeBg");
	this.shape_2.setTransform(134.1,138.1,1.141,1.141);

	this.shape_3 = new cjs.Shape();
	this.shape_3.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1461.4,-93.1)).s().p("At7OiIAA9DIb3AAIAAdDg");
	this.shape_3.setTransform(128.9,127.7,1.141,1.141);

	this.shape_4 = new cjs.Shape();
	this.shape_4.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-304.3,-284.6)).s().p("AvXOcIAA82IevgBIAAc3g");
	this.shape_4.setTransform(139.3,127.8,1.141,1.141);

	this.shape_5 = new cjs.Shape();
	this.shape_5.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-693.6,-286.1)).s().p("AuqOqIAA82IR9AAIAAgdILYAAIAAdTg");
	this.shape_5.setTransform(127.3,122.6,1.141,1.141);

	this.shape_6 = new cjs.Shape();
	this.shape_6.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1079.8,-286.1)).s().p("Au5OqIAA9TIdzAAIAAdTg");
	this.shape_6.setTransform(132.4,131.2,1.141,1.141);

	this.shape_7 = new cjs.Shape();
	this.shape_7.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1461.4,-286.1)).s().p("At7PnIAA/OIb3AAIAAfOg");
	this.shape_7.setTransform(125.5,138.1,1.141,1.141);

	this.shape_8 = new cjs.Shape();
	this.shape_8.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-305.8,-476.2)).s().p("AvIPfIAA+9IeQAAIABe9g");
	this.shape_8.setTransform(130.7,140.7,1.141,1.141);

	this.shape_9 = new cjs.Shape();
	this.shape_9.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-684.5,-480)).s().p("AupPnIAA/NIUyAAIAAAeIIiAAIAAevg");
	this.shape_9.setTransform(127.2,139.9,1.141,1.141);

	this.shape_10 = new cjs.Shape();
	this.shape_10.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1079.8,-480)).s().p("Au5PnIAA/NIdzAAIAAfNg");
	this.shape_10.setTransform(134.1,138.1,1.141,1.141);

	this.shape_11 = new cjs.Shape();
	this.shape_11.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1462.1,-488.3)).s().p("At0NYIAA6vIbpAAIAAAQIAACmIAAX5g");
	this.shape_11.setTransform(121.1,120,1.141,1.141);

	this.shape_12 = new cjs.Shape();
	this.shape_12.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1541.6,-394.4)).s().p("AhZBSIAAijICzAAIAACjg");
	this.shape_12.setTransform(232.5,33.6,1.141,1.141);

	this.shape_13 = new cjs.Shape();
	this.shape_13.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-305.1,-672.4)).s().p("AvPO6IAA9zIbpAAIAAA9IC2AAIAAc2g");
	this.shape_13.setTransform(131.6,124.3,1.141,1.141);

	this.shape_14 = new cjs.Shape();
	this.shape_14.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-684.5,-679.9)).s().p("AuqPJIAA+RIR9AAIAAAeILYAAIAAdzg");
	this.shape_14.setTransform(134.1,138.1,1.141,1.141);

	this.shape_15 = new cjs.Shape();
	this.shape_15.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1080.5,-675.4)).s().p("AuxO6IAA9zIdjAAIAAdzg");
	this.shape_15.setTransform(128.1,131.2,1.141,1.141);

	this.shape_16 = new cjs.Shape();
	this.shape_16.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1461.4,-673.9)).s().p("At7PnIAA/NIb3AAIAAfNg");
	this.shape_16.setTransform(134.1,138.1,1.141,1.141);

	this.shape_17 = new cjs.Shape();
	this.shape_17.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-304.3,-867.7)).s().p("AvXPnIAA/NIXJAAIAAAeIHmAAIAAevg");
	this.shape_17.setTransform(141.1,139.9,1.141,1.141);

	this.shape_18 = new cjs.Shape();
	this.shape_18.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-687.5,-872.3)).s().p("AvIQUIAA/NIdUAAIAAhbIA9AAMAAAAgog");
	this.shape_18.setTransform(130.7,134.7,1.141,1.141);

	this.shape_19 = new cjs.Shape();
	this.shape_19.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1079.8,-870.7)).s().p("Au5PnIAA/NIR9AAIAAA9IL2AAIAAeQg");
	this.shape_19.setTransform(134.1,131.2,1.141,1.141);

	this.shape_20 = new cjs.Shape();
	this.shape_20.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1461.4,-873.8)).s().p("At7PnIAA/NIb3AAIAAfNg");
	this.shape_20.setTransform(127.2,139.8,1.141,1.141);

	this.shape_21 = new cjs.Shape();
	this.shape_21.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-305.1,-1066.8)).s().p("AvPPBIAA+BIefAAIAAeBg");
	this.shape_21.setTransform(131.6,138.1,1.141,1.141);

	this.shape_22 = new cjs.Shape();
	this.shape_22.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-692,-1067.2)).s().p("Av1O9IAA9DIeRAAIAAg2IBaAAIAAd5g");
	this.shape_22.setTransform(139.3,124.7,1.141,1.141);

	this.shape_23 = new cjs.Shape();
	this.shape_23.graphics.bf(img.Explosion1spritesheet, null, new cjs.Matrix2D(0.757,0,0,0.757,-1039.7,-1048)).s().p("AhDMEInkAAIAAAAIAA4HIRQAAIAADUIiKAAIAAUzIniAAg");
	this.shape_23.setTransform(91.8,107,1.141,1.141);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[]}).to({state:[{t:this.shape}]},1).to({state:[{t:this.shape_1}]},1).to({state:[{t:this.shape_2}]},1).to({state:[{t:this.shape_3}]},1).to({state:[{t:this.shape_4}]},1).to({state:[{t:this.shape_5}]},1).to({state:[{t:this.shape_6}]},1).to({state:[{t:this.shape_7}]},1).to({state:[{t:this.shape_8}]},1).to({state:[{t:this.shape_9}]},1).to({state:[{t:this.shape_10}]},1).to({state:[{t:this.shape_12},{t:this.shape_11}]},1).to({state:[{t:this.shape_13}]},1).to({state:[{t:this.shape_14}]},1).to({state:[{t:this.shape_15}]},1).to({state:[{t:this.shape_16}]},1).to({state:[{t:this.shape_17}]},1).to({state:[{t:this.shape_18}]},1).to({state:[{t:this.shape_19}]},1).to({state:[{t:this.shape_20}]},1).to({state:[{t:this.shape_21}]},1).to({state:[{t:this.shape_22}]},1).to({state:[{t:this.shape_23}]},1).to({state:[]},1).wait(1));

}).prototype = p = new cjs.MovieClip();
p.nominalBounds = null;


(lib.ExplodeBtn = function() {
	this.initialize();

	// Layer 1
	this.text = new cjs.Text("Explode", "bold 56px 'Lithos Pro Regular'", "#FFFFFF");
	this.text.textAlign = "center";
	this.text.lineHeight = 56;
	this.text.lineWidth = 273;
	this.text.setTransform(91.7,20.8,0.625,0.625);

	this.shape = new cjs.Shape();
	this.shape.graphics.f().s("#2CBB00").ss(9,1,0,13).p("AzipTMAnFAAAQDtAAAADtIAALNQAADtjtAAMgnFAAAQjtAAAAjtIAArNQAAjtDtAAg");
	this.shape.setTransform(93,37.3,0.625,0.625);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.lf(["#76D700","#539F00"],[0,1],-148.7,0,148.8,0).s().p("AziJUQjtAAABjtIAArNQgBjtDtAAMAnFAAAQDsAAAADtIAALNQAADtjsAAg");
	this.shape_1.setTransform(93,37.3,0.625,0.625);

	this.addChild(this.shape_1,this.shape,this.text);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-4.5,-4.5,195,83.7);


(lib.ClickText = function() {
	this.initialize();

	// FlashAICB
	this.shape = new cjs.Shape();
	this.shape.graphics.f().s("#231F20").p("AAShoQAJAAAAAEQAAACgKAXQgKAbAAAWQAAAZAEAhQAAADgPAAQgIAAgIgoQgHgmAAgZQAAgcAEgFQABgDAJAAgAgbBOQAAgLAIgJQAJgIAKAAQAKAAAJAIQAIAIAAAMQAAALgIAIQgJAIgKAAQgLAAgIgIQgIgIAAgLg");
	this.shape.setTransform(46.9,65.6);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.f("#77CEDE").s().p("AgTBhQgHgIgBgLQABgLAHgJQAJgIAKAAQAKAAAJAIQAJAIgBAMQABALgJAIQgJAIgKAAQgKAAgJgIgAgUgFQgHgmAAgZQABgcADgFQABgDAKAAIAeAAQAJAAAAAEIgKAZQgJAbgBAWQAAAZAFAhQAAADgQAAQgIAAgIgog");
	this.shape_1.setTransform(46.9,65.6);

	this.shape_2 = new cjs.Shape();
	this.shape_2.graphics.f().s("#231F20").p("AgGBqQgWAAgOgTQgQgUAAgkQAAglAWgbQASgXASAAQADAAAFADQAFADABAAQAGAAAAgNQAAgLgDgMQgDgMAAgEQAAgDAIAAIAaAAQAMAAgBB6QABBZgJAAgAAZANQAAgcgFgKQgDgHgIAAQgJAAgLANQgNARAAAcQAAAQAGAMQAHAQAMAAQASAAAEgWQACgHAAgcg");
	this.shape_2.setTransform(35.7,65.1);

	this.shape_3 = new cjs.Shape();
	this.shape_3.graphics.f("#77CEDE").s().p("AgGBqQgWAAgOgTQgQgUAAgkQAAglAWgbQASgXASAAQADAAAFADIAGADQAGAAAAgNQAAgLgDgMIgDgQQAAgDAIAAIAaAAQAMAAgBB6QABBZgJAAgAgLgTQgNARAAAcQAAAQAGAMQAHAQAMAAQASAAAEgWQACgHAAgcQAAgcgFgKQgDgHgIAAQgJAAgLANg");
	this.shape_3.setTransform(35.7,65.1);

	this.shape_4 = new cjs.Shape();
	this.shape_4.graphics.f().s("#231F20").p("AADgUQAHgCADgCQADgCAAgFQAAgJgIgGQgHgFgHAAQgPAAgGALQgGALAAAAQgGAAgFgGQgGgHAAgIQAAgOANgIQANgIASAAQAoAAANAjQAGAQAABPQAAALACAPQAAAGguAAQg/AAAAguQAAgWATgPQARgQAVgDgAATAVQAAgKgBgCQgCgHgIAAQgJAAgJAIQgKAJAAALQAAAKAIAGQAHAGAJAAQAKAAADgFQACgEAAgLg");
	this.shape_4.setTransform(22.6,67.6);

	this.shape_5 = new cjs.Shape();
	this.shape_5.graphics.f("#77CEDE").s().p("Ag2AkQAAgXATgPQARgPAVgEIAKgCQADgDAAgFQAAgKgIgFQgHgFgHAAQgPAAgGALIgGAKQgGABgFgHQgGgGAAgIQAAgNANgJQANgJASAAQAoABANAiQAGARAABOQAAAMACAOQAAAGguABQg/AAAAgugAgKAKQgKAJAAALQAAAKAIAGQAHAGAJAAQAKAAADgFQACgEAAgLIAAgLIgBgMQgCgHgIAAQgJAAgJAIg");
	this.shape_5.setTransform(22.6,67.6);

	this.shape_6 = new cjs.Shape();
	this.shape_6.graphics.f().s("#231F20").p("Ag5AGQAAgpAVgZQATgWAZAAQAVAAAOALQAPAMAAAWQAAAegoANQgmAOAAAJQAAAJALAGQAJAGAJAAQAZAAAMgQQAFgIADgIQAEAAAAAPQAAAXgQAOQgPANgXAAQgeAAgQgXQgPgVAAghgAgYgQQAAAFAFAAQAugKAAgNQAAgIgHgGQgGgFgIAAQgMAAgJANQgJALAAANg");
	this.shape_6.setTransform(9.5,67.8);

	this.shape_7 = new cjs.Shape();
	this.shape_7.graphics.f("#77CEDE").s().p("AgqA8QgPgVAAghQAAgpAVgZQATgWAZAAQAVAAAOALQAPAMAAAWQAAAegoANQgmAOAAAJQAAAJALAGQAJAGAJAAQAZAAAMgQQAFgIADgIQAEAAAAAPQAAAXgQAOQgPANgXAAQgeAAgQgXgAgPgoQgJALAAANQAAAFAFAAQAugKAAgNQAAgIgHgGQgGgFgIAAQgMAAgJANg");
	this.shape_7.setTransform(9.5,67.8);

	this.shape_8 = new cjs.Shape();
	this.shape_8.graphics.f().s("#231F20").p("AgNhpQAEAAAAAFQAAACgFAQQgFASAAAMQAAAIAFAAQADAAAIgGQAJgGAKAAQAoAAAABLQAAAZgDAcQgDAigGAAIgaAAQgJAAAAgDQANgzAAgiQAAgZgFgKQgEgJgKAAQgYAAAAA3QAAAeADAWQABAMACAJQAAAEgIAAIgYAAQgGAAgBgJQgBgMAAhRQAAhtAPAAg");
	this.shape_8.setTransform(-3.6,65.1);

	this.shape_9 = new cjs.Shape();
	this.shape_9.graphics.f("#77CEDE").s().p("AASBqQgJAAAAgDQANgzAAgiQAAgZgFgKQgEgJgKAAQgYAAAAA3QAAAeADAWIADAVQAAAEgIAAIgYAAQgGAAgBgJQgBgMAAhRQAAhtAPAAIAbAAQAEAAAAAFIgFASQgFASAAAMQAAAIAFAAQADAAAIgGQAJgGAKAAQAoAAAABLQAAAZgDAcQgDAigGAAg");
	this.shape_9.setTransform(-3.6,65.1);

	this.shape_10 = new cjs.Shape();
	this.shape_10.graphics.f().s("#231F20").p("Ag2AnQAAgIAEgKQADgJABAAQABAAAIATQAMATAXAAQAHAAAGgFQAHgFAAgIQAAgKgggQQgigNAAgcQAAgWAQgNQAPgMATAAQAUAAAQAKQANAIAAAGQAAAEgIAKQgIALgEAAQgBAAgJgKQgIgKgNAAQgFAAgGADQgGADAAAFQAAAKAjATQAlARAAAcQAAAYgSAOQgQANgWAAQgVAAgPgLQgRgNAAgUg");
	this.shape_10.setTransform(-24.2,67.8);

	this.shape_11 = new cjs.Shape();
	this.shape_11.graphics.f("#77CEDE").s().p("AglBIQgQgNAAgUQgBgIAEgKQADgJACAAQAAAAAJATQAMATAVAAQAIAAAFgFQAIgFAAgIQAAgKgggQQghgNgBgcQABgWAPgNQAOgMAUAAQAVAAAPAKQANAIAAAGQAAAEgIAKQgIALgFAAIgJgKQgIgKgNAAQgFAAgFADQgHADABAFQAAAKAiATQAkARAAAcQAAAYgRAOQgQANgVAAQgWAAgPgLg");
	this.shape_11.setTransform(-24.2,67.8);

	this.shape_12 = new cjs.Shape();
	this.shape_12.graphics.f().s("#231F20").p("AgShYQAAgIAGgFQAGgEAGAAQAIAAAFAEQAGAFAAAIQAAAIgGAEQgFAFgIAAQgGAAgGgFQgGgEAAgIgAgHBqQgKAAgBgIQgCgLAAhAQAAg3ADgNQABgHAIAAIAMAAQAHAAACABQABAAAAADQAAACgBAOQgCAOAAAQQAAA9AKApQAAAFgEABQgBAAgIAAg");
	this.shape_12.setTransform(-34,65.1);

	this.shape_13 = new cjs.Shape();
	this.shape_13.graphics.f("#77CEDE").s().p("AAIBqIgPAAQgKAAgBgIQgCgLAAhAQAAg3ADgNQABgHAIAAIAMAAIAJABQAAAAAAAAQABAAAAABQAAAAAAABQAAAAAAABIgBAQQgCAOAAAQQAAA9AKApQAAAFgEABIgJAAgAgMhMQgGgEAAgIQAAgIAGgFQAGgEAGAAQAIAAAFAEQAGAFAAAIQAAAIgGAEQgFAFgIAAQgGAAgGgFg");
	this.shape_13.setTransform(-34,65.1);

	this.shape_14 = new cjs.Shape();
	this.shape_14.graphics.f().s("#231F20").p("AgNhpQAEAAAAAFQAAACgFAQQgFASAAAMQAAAIAFAAQACAAAJgGQAKgGAJAAQATAAAKAQQALASAAApQAAAZgDAcQgDAigFAAIgbAAQgIAAAAgDQAMgzAAgiQAAgZgFgKQgEgJgKAAQgYAAAAA3QAAAeADAWQABAMACAJQAAAEgIAAIgZAAQgFAAgBgJQgBgMAAhRQAAhtAPAAg");
	this.shape_14.setTransform(-44,65.1);

	this.shape_15 = new cjs.Shape();
	this.shape_15.graphics.f("#77CEDE").s().p("AASBqQgIAAgBgDQANgzAAgiQAAgZgFgKQgEgJgKAAQgYAAAAA3QAAAeADAWIACAVQAAAEgGAAIgZAAQgGAAgBgJQgBgMAAhRQABhtAOAAIAbAAQAEAAAAAFIgEASQgGASAAAMQAAAIAFAAQADAAAIgGQAKgGAJAAQATAAAJAQQAMASAAApQAAAZgDAcQgDAigGAAg");
	this.shape_15.setTransform(-44,65.1);

	this.shape_16 = new cjs.Shape();
	this.shape_16.graphics.f().s("#231F20").p("Ag5AGQAAgpAVgZQATgWAZAAQAVAAAPALQAPANAAAVQAAAegoANQgnAOAAAJQAAAJALAGQAJAGAKAAQAZAAALgQQAGgIACgIQAFAAAAAPQAAAXgQAOQgPANgYAAQgdAAgRgXQgPgVAAghgAgXgQQAAAFAEAAQAvgKAAgNQAAgIgHgGQgGgFgIAAQgMAAgKANQgIALAAANg");
	this.shape_16.setTransform(36.2,36.8);

	this.shape_17 = new cjs.Shape();
	this.shape_17.graphics.f("#77CEDE").s().p("AgqA8QgQgVABghQAAgpAUgZQAUgWAYAAQAWAAAOALQAPANAAAVQABAegoANQgnAOAAAJQAAAJALAGQAJAGAKAAQAYAAAMgQQAGgIACgIQAEAAAAAPQAAAXgQAOQgPANgXAAQgdAAgRgXgAgPgoQgJALABANQgBAFAFAAQAugKABgNQgBgIgGgGQgHgFgIAAQgLAAgKANg");
	this.shape_17.setTransform(36.2,36.8);

	this.shape_18 = new cjs.Shape();
	this.shape_18.graphics.f().s("#231F20").p("AgGBqQgWAAgOgTQgQgUAAgkQAAglAWgbQASgXASAAQADAAAFADQAFADABAAQAGAAAAgNQAAgLgDgMQgDgMAAgEQAAgDAIAAIAaAAQAMAAgBB6QABBZgJAAgAAZANQAAgcgFgKQgDgHgIAAQgJAAgLANQgNARAAAcQAAAQAGAMQAHAQAMAAQASAAAEgWQACgHAAgcg");
	this.shape_18.setTransform(22.7,34.1);

	this.shape_19 = new cjs.Shape();
	this.shape_19.graphics.f("#77CEDE").s().p("AgGBqQgWAAgOgTQgQgUAAgkQAAglAWgbQASgXASAAQADAAAFADIAGADQAGAAAAgNQAAgLgDgMIgDgQQAAgDAIAAIAaAAQAMAAgBB6QABBZgJAAgAgLgTQgNARAAAcQAAAQAGAMQAHAQAMAAQASAAAEgWQACgHAAgcQAAgcgFgKQgDgHgIAAQgJAAgLANg");
	this.shape_19.setTransform(22.7,34.1);

	this.shape_20 = new cjs.Shape();
	this.shape_20.graphics.f().s("#231F20").p("Ag9AAQAAggAPgXQARgbAdAAQAeAAARAbQAPAXAAAgQAAAogUAXQgSAUgYAAQgXAAgSgUQgUgXAAgogAAfgFQAAgSgGgNQgJgRgQAAQgPAAgJARQgGANAAASQAAARAGANQAJARAPAAQARAAAIgRQAGgNAAgRg");
	this.shape_20.setTransform(9.4,36.8);

	this.shape_21 = new cjs.Shape();
	this.shape_21.graphics.f("#77CEDE").s().p("AgpA/QgUgXAAgoQAAggAPgXQARgbAdAAQAeAAARAbQAPAXAAAgQAAAogUAXQgSAUgYAAQgXAAgSgUgAgYgkQgGANAAASQAAARAGANQAJARAPAAQARAAAIgRQAGgNAAgRQAAgSgGgNQgJgRgQAAQgPAAgJARg");
	this.shape_21.setTransform(9.4,36.8);

	this.shape_22 = new cjs.Shape();
	this.shape_22.graphics.f().s("#231F20").p("AgNBqQgGAAgBgqQAAgsAAgDQAAgqABgXQACg5AHAAIAWAAQAKAAAAAFQAAABgFAaQgGAiAAAmQAAApAFAjQACARADALQAAADgJAAg");
	this.shape_22.setTransform(-0.2,34.1);

	this.shape_23 = new cjs.Shape();
	this.shape_23.graphics.f("#77CEDE").s().p("AgNBqQgGAAgBgqIAAgvIABhBQABg5AIAAIAVAAQAKAAAAAFIgEAbQgGAiAAAmQAAApAFAjQACARACALQAAADgJAAg");
	this.shape_23.setTransform(-0.2,34.1);

	this.shape_24 = new cjs.Shape();
	this.shape_24.graphics.f().s("#231F20").p("AAbgXQAAgMgJgIQgIgIgKAAQgNAAgEAHQgGAKAAAiQAAARALAAQAPAAAMgNQAMgLAAgQgAguBSQgGAAgCgFQgDgHAAgdIAAhIQAAgmAIgGQAFgFAiAAQBEAAAAA1QAAAbgWAYQgUAZgQAAQgCAAgJgLQgJgJAAAAQgCAAAAAJQAAARAFAXQAAAEgIAAg");
	this.shape_24.setTransform(-10,36.6);

	this.shape_25 = new cjs.Shape();
	this.shape_25.graphics.f("#77CEDE").s().p("AguBRQgGABgCgFQgDgHAAgdIAAhIQAAgmAIgGQAFgGAiAAQBEAAAAA2QAAAbgWAYQgUAZgQAAQgCAAgJgLIgJgKQgCABAAAIQAAASAFAXQAAAEgIgBgAgRgsQgGAKAAAiQAAARALgBQAPABAMgNQAMgLAAgRQAAgMgJgHQgIgIgKAAQgNAAgEAHg");
	this.shape_25.setTransform(-10,36.6);

	this.shape_26 = new cjs.Shape();
	this.shape_26.graphics.f().s("#231F20").p("AAcBQQgFAAgBgBQgCgBAAgEQAAgVgKgSQgIgPgFAAQgFAAgHANQgHAQAAATQAAAIgBACQgCACgHAAIgPAAQgGAAgBgBQgCgBAAgGQAAgaAPgYQAOgTAAgDQgGgJgHgKQgNgVAAgdQAAgHACgBQABgCAHAAIATAAQAFAAAAABQADABAAADQAAAVAHAQQAGANAFAAQAEAAAEgKQAHgMABgVQACgJAAgBQABgCAIAAIAMAAQAHAAABACQADABAAAGQAAAYgOAVQgIALgHAJQAAABARATQARAVAAAfQAAAJgCACQgBACgHAAg");
	this.shape_26.setTransform(-23.3,36.8);

	this.shape_27 = new cjs.Shape();
	this.shape_27.graphics.f("#77CEDE").s().p("AAcBPIgGAAQgCgBAAgEQAAgVgKgTQgIgOgFAAQgFAAgHANQgHAQAAATQAAAIgBABQgCACgHAAIgPAAIgHAAQgCgBAAgHQAAgZAPgYQAOgTAAgDIgNgTQgNgWAAgcQAAgHACgBQABgCAHAAIATAAIAFABQADABAAADQAAAVAHAPQAGAOAFAAQAEAAAEgKQAHgMABgVIACgKQABgCAIAAIAMAAQAHAAABACQADABAAAGQAAAYgOAVIgPAUIARAUQARAVAAAfQAAAJgCACQgBACgHgBg");
	this.shape_27.setTransform(-23.3,36.8);

	this.shape_28 = new cjs.Shape();
	this.shape_28.graphics.f().s("#231F20").p("AgYgQQAAAFAFAAQAugKAAgNQAAgIgHgGQgGgFgIAAQgMAAgJANQgJALAAANgAg5AGQAAgpAVgZQATgWAZAAQAVAAAOALQAPAMAAAWQAAAegoANQgmAOAAAJQAAAJALAGQAJAGAJAAQAZAAAMgQQAGgQACAAQAEAAAAAPQAAAXgQAOQgPANgXAAQgeAAgQgXQgPgVAAghg");
	this.shape_28.setTransform(-36.4,36.8);

	this.shape_29 = new cjs.Shape();
	this.shape_29.graphics.f("#77CEDE").s().p("AgqA8QgPgVAAghQAAgpAVgZQATgWAZAAQAVAAAOALQAPAMAAAWQAAAegoANQgmAOAAAJQAAAJALAGQAJAGAJAAQAZAAAMgQQAGgQACAAQAEAAAAAPQAAAXgQAOQgPANgXAAQgeAAgQgXgAgPgoQgJALAAANQAAAFAFAAQAugKAAgNQAAgIgHgGQgGgFgIAAQgMAAgJANg");
	this.shape_29.setTransform(-36.4,36.8);

	this.shape_30 = new cjs.Shape();
	this.shape_30.graphics.f().s("#231F20").p("Ag9AAQAAggAPgXQARgbAdAAQAeAAARAbQAPAXAAAgQAAAogUAXQgSAUgYAAQgXAAgSgUQgUgXAAgogAAfgFQAAgSgGgNQgJgRgQAAQgPAAgJARQgGANAAASQAAARAGANQAJARAPAAQARAAAIgRQAGgNAAgRg");
	this.shape_30.setTransform(35.3,5.8);

	this.shape_31 = new cjs.Shape();
	this.shape_31.graphics.f("#77CEDE").s().p("AgpA/QgUgXAAgoQAAggAPgXQARgbAdAAQAeAAARAbQAPAXAAAgQAAAogUAXQgSAUgYAAQgXAAgSgUgAgYgkQgGANAAASQAAARAGANQAJARAPAAQARAAAIgRQAGgNAAgRQAAgSgGgNQgJgRgQAAQgPAAgJARg");
	this.shape_31.setTransform(35.3,5.8);

	this.shape_32 = new cjs.Shape();
	this.shape_32.graphics.f().s("#231F20").p("AAYheQAAAIgHASQAAAHAFAAIAJgBQAHAAACAFQABACAAAIQAAANgFAAQgHgCgFAAQgJAAgDALQgBAGAAATQAAApAHAYQADALAEAGQAAADgPAHQgOAIgEAAQgGAAgEgeQgCgVAAgTQABgoAAgFQAAgMAAgCQgBgHgIAAQgCAAgDABQgDACgBAAQgDAAAAgIQAAgNAEgEQADgEAIAAIAEABQAFAAADgHQAAgCACgMQABgGANgGQAMgFAGAAQADAAAAAFg");
	this.shape_32.setTransform(23.9,4.2);

	this.shape_33 = new cjs.Shape();
	this.shape_33.graphics.f("#77CEDE").s().p("AgSBGQgCgVAAgTIABguIAAgMQgBgIgIAAIgFABIgEACQgDAAAAgIQAAgNAEgFQADgDAIAAIAEABQAFAAADgIIACgNQABgGANgGQAMgEAGAAQADgBAAAGQAAAGgHASQAAAIAFAAIAJgBQAHAAACAFQABADAAAHQAAANgFAAQgHgCgFAAQgJAAgDALQgBAGAAATQAAApAHAXQADAMAEAGQAAACgPAIQgOAHgEAAQgGABgEgeg");
	this.shape_33.setTransform(23.9,4.2);

	this.shape_34 = new cjs.Shape();
	this.shape_34.graphics.f().s("#231F20").p("AgxBqQgFAAgCgqQAAgsAAgDQAAgqABgXQACg5AHAAIAbAAQAGAAAAAFQgCAKgDAOQgEAdgBAoQAAASAEAAQAHAAALgSQALgVAAgTQAAgEACAAQAAgBAGAAIAPAAQAHAAAAAAQAEABAAAFQAAAVgOAVQgHAIgHAKQAAACAHAGQAJAHAFAHQAUAYAAAnQAAAFgDACQgBAAgHAAIgUAAQgFAAgCgBQgCgBAAgGQAAgXgJgVQgIgSgFAAQgEAAgFAEQgGAEAAAIQAAAeAGAVQAAADgGAAg");
	this.shape_34.setTransform(6.3,3.2);

	this.shape_35 = new cjs.Shape();
	this.shape_35.graphics.f("#77CEDE").s().p("AAaBqQgFAAgCgBQgCgBAAgGQAAgXgJgVQgIgSgFAAQgEAAgFAEQgGAEAAAIQAAAeAGAVQAAADgGAAIgdAAQgFAAgCgqIAAgvIABhBQACg5AHAAIAbAAQAGAAAAAFIgFAYQgEAdgBAoQAAASAEAAQAHAAALgSQALgVAAgTQAAgBAAgBQAAAAAAgBQABAAAAgBQAAAAABAAIAGgBIAPAAIAHAAQAEABAAAFQAAAVgOAVIgOASQAAACAHAGQAJAHAFAHQAUAYAAAnQAAAFgDACIgIAAg");
	this.shape_35.setTransform(6.3,3.2);

	this.shape_36 = new cjs.Shape();
	this.shape_36.graphics.f().s("#231F20").p("Ag1AIQAAgjARgZQAUgeAgAAQAQAAALAIQALAHAAALQAAAHgEAHQgFAIgGAAQgBAAgGgJQgGgKgMAAQgPAAgKAUQgIAQAAARQAAAUAJAMQAJANAPAAQARAAAKgMQAFgHAEgGQADAAAAAPQAAAWgNANQgNANgXAAQgbAAgQgYQgOgVAAgeg");
	this.shape_36.setTransform(-6.9,5.8);

	this.shape_37 = new cjs.Shape();
	this.shape_37.graphics.f("#77CEDE").s().p("AgnA7QgOgVAAgeQAAgjARgZQAUgeAgAAQAQAAALAIQALAHAAALQAAAHgEAHQgFAIgGAAQgBAAgGgJQgGgKgMAAQgPAAgKAUQgIAQAAARQAAAUAJAMQAJANAPAAQARAAAKgMIAJgNQADAAAAAPQAAAWgNANQgNANgXAAQgbAAgQgYg");
	this.shape_37.setTransform(-6.9,5.8);

	this.shape_38 = new cjs.Shape();
	this.shape_38.graphics.f().s("#231F20").p("AgRhYQAAgIAGgFQAFgEAGAAQAIAAAFAEQAGAFAAAIQAAAIgGAEQgFAFgIAAQgGAAgFgFQgGgEAAgIgAgHBqQgKAAgBgIQgCgLAAhAQAAg4ADgMQABgHAIAAIAMAAQAHAAACABQACAAAAADQAAACgCAOQgBAOAAAQQAAA9AJApQAAAFgEABQgBAAgIAAg");
	this.shape_38.setTransform(-16.2,3.2);

	this.shape_39 = new cjs.Shape();
	this.shape_39.graphics.f("#77CEDE").s().p("AAIBqIgPAAQgKAAgBgIQgCgLAAhAQAAg4ADgMQABgHAIAAIAMAAIAJABQABAAAAAAQAAAAAAABQABAAAAABQAAAAAAABIgCAQQgBAOAAAQQAAA9AJApQAAAFgEABIgJAAgAgLhMQgGgEAAgIQAAgIAGgFQAFgEAGAAQAIAAAFAEQAGAFAAAIQAAAIgGAEQgFAFgIAAQgGAAgFgFg");
	this.shape_39.setTransform(-16.2,3.2);

	this.shape_40 = new cjs.Shape();
	this.shape_40.graphics.f().s("#231F20").p("AgNBqQgFAAgCgqQgBgsAAgDQAAgpABgYQADg5AHAAIAVAAQALAAAAAFQgDAKgCARQgGAiAAAmQAAApAFAjQACARADALQAAADgKAAg");
	this.shape_40.setTransform(-22.4,3.2);

	this.shape_41 = new cjs.Shape();
	this.shape_41.graphics.f("#77CEDE").s().p("AgNBqQgFAAgCgqIgBgvIABhBQADg5AHAAIAVAAQALAAAAAFIgFAbQgGAiAAAmQAAApAFAjQACARADALQAAADgKAAg");
	this.shape_41.setTransform(-22.4,3.2);

	this.shape_42 = new cjs.Shape();
	this.shape_42.graphics.f().s("#231F20").p("AhIAFQAAgqAXghQAagkAoAAQAVAAAPAIQAUAKAAASQAAAXgaAAQgDAAgDgMQgEgMgSAAQgYAAgOAXQgMATAAAbQAAAeATATQANAQAUAAQAZAAANgSQAGgKACgJQADAAABALQACAIAAAEQAAAbgTAQQgSAPgbAAQgmAAgWggQgVgcAAgqg");
	this.shape_42.setTransform(-34.1,3.4);

	this.shape_43 = new cjs.Shape();
	this.shape_43.graphics.f("#77CEDE").s().p("AgzBLQgVgcAAgqQAAgqAXghQAagkAoAAQAVAAAPAIQAUAKAAASQAAAXgaAAQgDAAgDgMQgEgMgSAAQgYAAgOAXQgMATAAAbQAAAeATATQANAQAUAAQAZAAANgSQAGgKACgJQADAAABALIACAMQAAAbgTAQQgSAPgbAAQgmAAgWggg");
	this.shape_43.setTransform(-34.1,3.4);

	this.shape_44 = new cjs.Shape();
	this.shape_44.graphics.f("#92D0DE").s().p("AAUDfQgLAIgCgGQAHgBgBgGQgBgGgHgDQgFACAAAIQACAHgJABQgGgDACgHQACgGgEAAQgCAIgJABQgKAAABgLQADgDAQAAQAMAAAAgMIgTACQgLACABgKQADgHAMACIAQACQgKgOAKgCQABADAJAEQAEABADAFQgBgHAJgDQATgHACgEIgkADIgBgKQgBgFgEgBQAAABAAABQgBABAAAAQAAAAgBABQgBAAAAgBQgEgCgDAAQABAFgDAIQgDAHgCgHQAHgHgIAAQgLAAgBgEQALgGgOgSQgOgSAJgGQgJACgHgIQgHgIgHAAQgDAHgTABQgUABgGgJQARAAgCgNQgkgBgtgHIhHgMQAGgBgHgHQgHgIAGgBQABAAAOAIQANAIAGgGQgJgEgSgQQgQgNgNgDIAAgSQgBgHgGgJQACgEAJgEQAKgDACgDIgHAAQgFAAAAgDQAXgOA8ABQBYADALgBQAMhJAJglQAQhCAtgGQAHgBAOAHQAMAHAMAMIAHgEQAEgCAFAAQAjAXApAjIBNBEQAmAiAKAMQAXAaABAWQACAQgNAMQgKAKAFAMIgRAFQgJADgGgGQgCAHgFAKQAWAGgNAGQgCgDgEABQgFABgFgCQABAMgJAIQgLAKgCAQIgYgCQgLgBgGgFQABgDAJgCQAIgCgDgHQgJABgHAIQgGAKgFAEQAHgBAEADIAHAJQgNgBACAFQABAFAHADQgUgEgIABQgPABgKAKIAOACQAEAAAHgEQgCAXgvgPQAEAIgHABQgJAAABAFQABAIAKADIAPAHQgMgBgIAGQgHgRgBgIQgDgMAIgHQgCABgLAAQgIAAABAFQADAFABAIQABAIAFAGQgEABgGgGQgDgCgDAJQAKAAgBAHQgQAAgDAKQgEANgHAEQAAgQgIAHg");
	this.shape_44.setTransform(0,100,0.515,0.515,90);

	this.shape_45 = new cjs.Shape();
	this.shape_45.graphics.f("#231F20").s().p("AADEPQgzgHgYg5QgYg1ARg6QiEAEgOgCQhMgIgSg0QgIgWAGgfQAHggAPgQQAZgbA/gEQAkgCBQAAQgFhPAYgtQAagxA1gBIAUABQBKAeBLBEQAsAoBSBVQAZAYACAXIAAAHQgCAUgQATQgjAtg6A2Qg9A5gzAkQgMAJgSAIQgSAKgLACQgNADgOAAIgNAAgAAfDYQAIgDAEgOQACgKAQAAQABgHgJAAQACgJADADQAGAFAFAAQgFgHgBgIQgBgIgEgFQgBgFAJAAQALAAABgBQgIAHADANQACAHAHASQAIgGAMAAIgQgGQgJgEgBgIQgBgEAIgBQAIgBgEgHQAuAPACgXQgGADgEAAIgOgBQAJgLAPgBQAJAAATADQgHgDgBgEQgBgGAMABIgGgIQgFgEgGABQAEgEAGgJQAHgIAKgBQACAHgHACQgKACgBACQAHAGAKABIAZACQACgRAKgJQAJgIgBgMQAFACAGgCQAEgBACADQAMgFgVgGQAFgLABgGQAGAFAKgDIARgFQgFgMAKgKQAMgMgBgOQgCgXgXgaQgKgMgmgjIhNhEQgogigkgXQgFgBgEACIgGAEQgXgVgSgDIgEAAQgtAGgQBCQgJAlgNBIQgLABhXgCQg9gCgXAOQABADAEAAIAIAAQgDADgKAEQgJADgCAEQAHAJAAAHIAAAUQAOABAPAOQASAQAJADQgGAHgNgIQgNgJgBABQgGABAHAHQAHAIgHAAIBIAMQAtAHAjABQADAOgSAAQAGAIAUgBQAUAAADgHQAGgBAIAJQAHAHAIgCQgJAGAOATQAOASgKAGQABADALAAQAHAAgGAIQABAHAEgIQADgHgBgFQACgBADACQAEACABgEQADAAABAGIABAKIAlgDQgCADgTAHQgKAEABAHQgDgFgDgCIgLgFIgCgBQgHABAJAPIgPgDQgNgBgDAHQgBAJAMgBIARgDQAAANgKAAQgRAAgDACQAAAMAJgBQAJgBADgIQAEAAgCAHQgDAHAGACQAFAAACgDQABgBgBgFIAAgEQABgDAFgBQAGACABAGQACAGgIACQADAGAKgJIAEgCQAFAAgBALg");
	this.shape_45.setTransform(0,99.8,0.515,0.515,90);

	this.addChild(this.shape_45,this.shape_44,this.shape_43,this.shape_42,this.shape_41,this.shape_40,this.shape_39,this.shape_38,this.shape_37,this.shape_36,this.shape_35,this.shape_34,this.shape_33,this.shape_32,this.shape_31,this.shape_30,this.shape_29,this.shape_28,this.shape_27,this.shape_26,this.shape_25,this.shape_24,this.shape_23,this.shape_22,this.shape_21,this.shape_20,this.shape_19,this.shape_18,this.shape_17,this.shape_16,this.shape_15,this.shape_14,this.shape_13,this.shape_12,this.shape_11,this.shape_10,this.shape_9,this.shape_8,this.shape_7,this.shape_6,this.shape_5,this.shape_4,this.shape_3,this.shape_2,this.shape_1,this.shape);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-50.6,-10.6,101.3,127.2);


(lib.CharHead = function() {
	this.initialize();

	// Layer 1
	this.instance = new lib.Image();
	this.instance.setTransform(0,0,0.567,0.567);

	this.addChild(this.instance);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(0,0,93,127.1);


(lib.ExplodeBtn_1 = function(mode,startPosition,loop) {
	this.initialize(mode,startPosition,loop,{});

	// txt
	this.shape_2 = new cjs.Shape();
	this.shape_2.graphics.lf(["rgba(5,17,0,0.482)","rgba(0,0,0,0.322)"],[0,0.882],0,-63.9,0,71.8).s().p("A2yJfQgoAAgcg8Qgcg7AAhVIAAslQAAhUAcg8QAcg8AoAAMAtlAAAQAoAAAcA8QAcA8AABUIAAMlQAABUgcA8QgcA8goAAg");
	this.shape_2._off = true;

	this.timeline.addTween(cjs.Tween.get(this.shape_2).wait(2).to({_off:false},0).wait(2));

	// flash0.ai
	this.text_1 = new cjs.Text("Explode", "bold 54px 'Lithos Pro Regular'", "#FFFFFF");
	this.text_1.textAlign = "center";
	this.text_1.lineHeight = 54;
	this.text_1.lineWidth = 273;
	this.text_1.setTransform(-2,-31.5);

	this.shape_3 = new cjs.Shape();
	this.shape_3.graphics.f().s("#2CBB00").ss(9,1,0,13).p("AzipTMAnFAAAQDtAAAADtIAALNQAADtjtAAMgnFAAAQjtAAAAjtIAArNQAAjtDtAAg");

	this.shape_4 = new cjs.Shape();
	this.shape_4.graphics.lf(["#76D700","#539F00"],[0,1],-148.7,0,148.8,0).s().p("AziJUQjtAAABjtIAArNQgBjtDtAAMAnFAAAQDsAAAADtIAALNQAADtjsAAg");

	this.shape_5 = new cjs.Shape();
	this.shape_5.graphics.lf(["#8FFF00","#539F00"],[0,1],0,-73.3,0,59.2).s().p("A2OIlQgdAAgUgsQgVgtAAg+IAAsbQAAg+AVgtQAUgsAdAAMAsdAAAQAdAAAUAsQAVAtAAA+IAAMbQAAA+gVAtQgUAsgdAAg");
	this.shape_5.setTransform(-0.1,0.8);

	this.shape_6 = new cjs.Shape();
	this.shape_6.graphics.lf(["#2DBF00","#269F00","#2B9F00","#167300"],[0,0.29,0.58,1],0,-64,0,71.8).s().p("A2yJfQgoAAgcg8Qgcg7AAhVIAAslQAAhUAcg8QAcg8AoAAMAtlAAAQAoAAAcA8QAcA8AABUIAAMlQAABUgcA8QgcA8goAAg");

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.shape_4,p:{scaleX:1,scaleY:1}},{t:this.shape_3,p:{scaleX:1,scaleY:1}},{t:this.text_1,p:{scaleX:1,scaleY:1,x:-2,y:-31.5}}]}).to({state:[{t:this.shape_4,p:{scaleX:1.2,scaleY:1.2}},{t:this.shape_3,p:{scaleX:1.2,scaleY:1.2}},{t:this.text_1,p:{scaleX:1.2,scaleY:1.2,x:-2.5,y:-37.8}}]},1).to({state:[{t:this.shape_6},{t:this.shape_5},{t:this.text_1,p:{scaleX:1,scaleY:1,x:-2,y:-26.5}}]},1).wait(2));

}).prototype = p = new cjs.MovieClip();
p.nominalBounds = new cjs.Rectangle(-153.3,-64.1,306.6,128.4);

})(lib = lib||{}, images = images||{}, createjs = createjs||{});
var lib, images, createjs;