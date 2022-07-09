package book1;

// for tio's secret jumpscare lololololololol
import flixel.addons.display.FlxBackdrop;
import flash.system.System;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.display.BlendMode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var instance:MainMenuState;

	var curSelected:Int = 0;
	var canMove:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionsStuff:FlxSprite;
	
	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var firstStart:Bool = true;
	public static var alreadyBooted:Bool = false;

	var acceptInput:Bool = false;
	var isOnWelcome:Bool = false;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var fnfPiggyBook1Ver:String = 'V1';
	public static var gameVer:String = "0.2.7.1";

	var optionShit:Array<String> = [
		'story mode',
		'options',
		'credits',
		'discord'
	];
	
	var optionArray:Array<String> = [
		'sm',
		'o',
		'c',
		'd'
	];

	var show:String = "";
	var blackScreen:FlxSprite;
	var tioJumpscare:FlxSprite;
	var mp4CodeTxt:FlxText;
	var lvlText:FlxText;

	var welcomeThingy:FlxSprite;
	var pennyMenu:FlxSprite;

	var flickerLight:FlxSprite;
	var particlesBD:FlxBackdrop;

	var blackBG:FlxSprite;

	override function create()
	{
		instance = this;
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu (Book 1)", null);
		#end

		FlxG.sound.playMusic(Paths.music('piggyMenu', 'book1'));
		
		book1.PlayStateB1.isFreeplay = false;
		book1.PlayStateB1.isFreeplayTwo = false;
		book1.PlayStateB1.isStoryMode = false;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/houseHallway', 'book1'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		flickerLight = new FlxSprite().loadGraphic(Paths.image('mainmenu/flickerLight(Add-Blend)', 'book1'));
		flickerLight.setGraphicSize(FlxG.width, FlxG.height);
		flickerLight.updateHitbox();
		flickerLight.screenCenter();
		flickerLight.antialiasing = true;
		flickerLight.blend = ADD; // blendmode shit is pretty neat
		add(flickerLight);

		particlesBD = new FlxBackdrop(Paths.image('mainmenu/lightParticleIMG', 'book1'));
		particlesBD.alpha = 0.10;
		particlesBD.velocity.set(-30, -30);
		particlesBD.blend = ADD;
		add(particlesBD);

		var pennyGeorge:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/pennyAndGeorge', 'book1'));
		pennyGeorge.setGraphicSize(FlxG.width, FlxG.height);
		pennyGeorge.updateHitbox();
		pennyGeorge.screenCenter();
		pennyGeorge.antialiasing = true;
		add(pennyGeorge);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/logo', 'book1'));
		logo.scale.set(0.3, 0.3);
		logo.updateHitbox();
		logo.screenCenter(Y);
		logo.y -= 240;
		logo.x -= 40;
		logo.antialiasing = true;
		add(logo);

		blackBG = new FlxSprite().loadGraphic(Paths.image('mainmenu/semi-blackFG(Multiply-Blend)', 'book1'));
		blackBG.setGraphicSize(FlxG.width, FlxG.height);
		blackBG.updateHitbox();
		blackBG.screenCenter();
		blackBG.antialiasing = true;
		blackBG.blend = MULTIPLY;
		blackBG.alpha = 0.20;
		add(blackBG);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets'); 

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scale.set(0.7, 0.7);
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.alpha = 0;
		}

		optionsStuff = new FlxSprite();
		optionsStuff.y += 100;
		add(optionsStuff);

		lvlText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		lvlText.setFormat(Paths.font("JAi_____.ttf"), 32, FlxColor.WHITE, RIGHT);
		lvlText.text = "Level " + FlxG.save.data.curLevel
		                + "\nXP: " + PlayState.curXP + "%";
		lvlText.alpha = 0;
		add(lvlText);

		// i dont even know if anyone cares about this
		var random = FlxG.random.int(0, 100);
		trace(random);

		if (random >= 0 && random <= 25)
		{
			show = 'one';
		}
		if (random >= 25 && random <= 50)
		{
			show = 'two';
		}
		if (random >= 50 && random <= 75)
		{
			show = 'three';
		}
		if (random >= 75 && random <= 100)
		{
			show = 'four';
		}

		switch (show)
		{
			case 'one':
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "check the idk", 12);
				mp4CodeTxt.scrollFactor.set();
				mp4CodeTxt.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				mp4CodeTxt.alpha = 1;
				add(mp4CodeTxt);
			case 'two':
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "ok", 12);
				mp4CodeTxt.scrollFactor.set();
				mp4CodeTxt.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				mp4CodeTxt.alpha = 1;
				add(mp4CodeTxt);
			case 'three':
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "hi pghlfilms :)", 12);
				mp4CodeTxt.scrollFactor.set();
				mp4CodeTxt.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				mp4CodeTxt.alpha = 0;
				add(mp4CodeTxt);
			case 'four':
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "lixfe llowwi ghtfi", 12);
				mp4CodeTxt.scrollFactor.set();
				mp4CodeTxt.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				mp4CodeTxt.alpha = 0;
				add(mp4CodeTxt);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "FNF PIGGY BOOK 1 " + fnfPiggyBook1Ver, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Kade Engine v" + kadeEngineVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + gameVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		blackScreen = new FlxSprite(-100).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
		blackScreen.scale.set(2, 2);
		blackScreen.screenCenter();
		blackScreen.updateHitbox();
		blackScreen.visible = false;
		add(blackScreen);

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		canMove = true;
		Conductor.changeBPM(70);

		changeItem();

		acceptInput = true;
		isOnWelcome = false;

		if (acceptInput && !isOnWelcome)
		{
			if (!alreadyBooted)
			{
				firstBoot();
			}
		}

		if (!FlxG.save.data.photoSens)
		    lightFlicker();
			
		fadeIn();
		fadeIn2();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (isOnWelcome && !acceptInput)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				FlxTween.tween(welcomeThingy, {alpha: 0}, 1, {ease: FlxEase.expoInOut, onComplete:
					function(flx:FlxTween)
					{
						acceptInput = true;
						isOnWelcome = false;
						alreadyBooted = true;
		
						remove(welcomeThingy);
					}});	
			}		
		}
		else if (acceptInput && !isOnWelcome)
		{	
		    if (!selectedSomethin)
				{
					if (FlxG.keys.justPressed.SPACE)
					{
						if (canMove) {
							forceCamZoom();
						}
					}
		
					if (FlxG.keys.justPressed.LEFT)
					{
						if (canMove) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							changeItem(-1);
						}
		
					}
		
					if (FlxG.keys.justPressed.RIGHT)
					{
						if (canMove) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							changeItem(1);
						}
					}
		
					if (controls.BACK)
					{
						if (canMove)
						{
							blackScreen.visible = true;
							FlxG.sound.music.stop();
		
							BookSelectionState.preloadDisabled = true;
							FlxG.switchState(new BookSelectionState());
						}
					}

						if (FlxG.keys.justPressed.ENTER)
							{
								if (canMove)
								{
									selectedSomethin = true;
									FlxG.sound.play(Paths.sound('confirmMenu'));
					
									menuItems.forEach(function(spr:FlxSprite)
									{
										if (curSelected != spr.ID)
										{
											// idk what i am doing but ok ig
											FlxTween.tween(FlxG.camera, {zoom: 1.1}, 2, {ease: FlxEase.expoOut});
											FlxTween.tween(FlxG.camera, {y: FlxG.height}, 1.6, {ease: FlxEase.expoIn});
					
											FlxTween.tween(spr, {alpha: 0}, 1.3, {
												ease: FlxEase.quadOut,
												onComplete: function(twn:FlxTween)
												{
													spr.kill();
												}
											});
										}
										else
										{
											new FlxTimer().start(1.3, function(tmr:FlxTimer)
											{
												goToState();
											});
										}
									});					
								}
							}	

				}	
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			spr.alpha = 0;
		});
	}
	
	function firstBoot()
	{
		welcomeThingy = new FlxSprite(0, 0).loadGraphic(Paths.image('welcome/welcomeText', 'book1'));
		welcomeThingy.alpha = 0;
		welcomeThingy.antialiasing = true;
		welcomeThingy.screenCenter();
		welcomeThingy.setGraphicSize(FlxG.width, FlxG.height); // just to be sure
		welcomeThingy.updateHitbox();
		add(welcomeThingy);

		FlxTween.tween(welcomeThingy, {alpha: 1}, 1, {ease: FlxEase.expoInOut, onComplete:
			function(flx:FlxTween)
			{
				acceptInput = false;
				isOnWelcome = true;
			}});	
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new book1.StoryMenuState());

				trace("Story Mode Selected.");

			case 'options':
				FlxG.switchState(new book1.OptionsMenu());

				trace("Options Menu Selected.");

			case 'credits':
				FlxG.switchState(new book1.CreditsState());

				trace("Credits Menu Selected.");

			case 'discord': // funny mod's discord server link
				fancyOpenURL("https://discord.gg/qJxeE8TYbn");
		}
	}

	function changeItem(huh:Int = 0)    
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});

		var assetName2:String = optionArray[0];
		if(curSelected < optionArray.length) assetName2 = optionArray[curSelected];

		optionsStuff.loadGraphic(Paths.image('menuoptions/option-' + assetName2, 'piggy'));
		optionsStuff.screenCenter(X);
		optionsStuff.antialiasing = true;
	}

	function forceCamZoom()
    {
        FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.5, {ease: FlxEase.expoOut});
            
        new FlxTimer().start(0.45, function(tmr:FlxTimer)
        {
            FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoOut});
        }); 
    }


	// light flicking
	function lightFlicker()
	{
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxTween.tween(flickerLight, {alpha: 0}, 0.15, {onComplete: function (twn:FlxTween) {
				flickerLight.alpha = 1;
				lightFlicker2();
			}});
		});
	}

	function lightFlicker2()
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(flickerLight, {alpha: 0}, 0.15, {onComplete: function (twn:FlxTween) {
				flickerLight.alpha = 1;
				lightFlicker3();
			}});
		});
	}

	function lightFlicker3()
	{
		FlxTween.tween(flickerLight, {alpha: 0}, 0.1, {onComplete: function (twn:FlxTween) {
			flickerLight.alpha = 1;
			lightFlicker4();
		}});
	}

	function lightFlicker4()
	{
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			FlxTween.tween(flickerLight, {alpha: 0}, 0.2, {onComplete: function (twn:FlxTween) {
				flickerLight.alpha = 1;
				lightFlicker5();
			}});
		});
	}

	function lightFlicker5()
	{
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxTween.tween(flickerLight, {alpha: 0}, 0.15, {onComplete: function (twn:FlxTween) {
				flickerLight.alpha = 1;
				lightFlicker();
			}});
		});
	}


	// particles shit
	function fadeIn()
	{
		FlxTween.tween(particlesBD, {alpha: 0.15}, 0.4, {onComplete: function (twn:FlxTween) {
			fadeOut();
		}});
	}

	function fadeOut()
	{
		FlxTween.tween(particlesBD, {alpha: 0.10}, 0.4, {onComplete: function (twn:FlxTween) {
			fadeIn();
		}});
	}

	// black bg shit
	function fadeIn2()
	{
		FlxTween.tween(blackBG, {alpha: 0.65}, 1, {onComplete: function (twn:FlxTween) {
			fadeOut2();
		}});
	}

	function fadeOut2()
	{
		FlxTween.tween(blackBG, {alpha: 0.15}, 1, {onComplete: function (twn:FlxTween) {
			fadeIn2();
		}});
	}
}
