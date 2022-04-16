package;

// for tio's secret jumpscare lololololololol
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

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var canMove:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionsStuff:FlxSprite;
	
	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var fnfPiggyBook2Ver:String = 'V3';
	public static var gameVer:String = "0.2.7.1";

	var optionShit:Array<String> = [
		'story mode',
		'freeplay',
		'extras',
		'options',
		'credits'
	];
	
	var optionArray:Array<String> = [
		'sm',
		'f',
		'e',
		'o',
		'c'
	];

	var show:String = "";
	var blackScreen:FlxSprite;
	var tioJumpscare:FlxSprite;
	var mp4CodeTxt:FlxText;
	var lvlText:FlxText;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end

		FlxG.sound.playMusic(Paths.music('piggyMenu', 'piggy'));
		
		PlayState.isExtrasMenu = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayTwo = false;
		PlayState.isStoryMode = false;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1Blur', 'piggy'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/logoNew', 'piggy'));
		logo.scale.set(0.6, 0.6);
		logo.updateHitbox();
		logo.screenCenter(X);
		logo.y += 50;
		logo.antialiasing = true;
		add(logo);

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
		/*	
			switch (i) // changing menuItems position
			{	
				case 0: // Storymode
			        //
				case 1: // Freeplay
			        //
				case 2: // Options
			        //	
			    case 3: // Credits
			        //	
			}	
		*/
		}

		optionsStuff = new FlxSprite();
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
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "check the extra freeplay", 12);
				mp4CodeTxt.scrollFactor.set();
				mp4CodeTxt.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				mp4CodeTxt.alpha = 1;
				add(mp4CodeTxt);
			case 'two':
				mp4CodeTxt = new FlxText(12, FlxG.height - 84, 0, "minitoon song when???", 12);
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

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "FNF PIGGY BOOK 2 " + fnfPiggyBook2Ver, 12);
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

		tioJumpscare = new FlxSprite().loadGraphic(Paths.image('secret/tioJumpscare', 'piggy'));
		tioJumpscare.setGraphicSize(FlxG.width, FlxG.height);
		tioJumpscare.updateHitbox();
		tioJumpscare.screenCenter();
		tioJumpscare.antialiasing = true;
		tioJumpscare.visible = false;
		add(tioJumpscare);

		FlxG.sound.cache(Paths.sound('Lights_Shut_off', 'shared'));

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		canMove = true;
		Conductor.changeBPM(70);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new HiddenCodeScreen());
		}

		if (FlxG.keys.justPressed.T)
		{
			if (canMove)
			{
				FlxG.sound.music.stop();
				blackScreen.visible = true;
				FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'));
	
				new FlxTimer().start(.9, function(tmr:FlxTimer)
				{
					jumpscareTio();
				});				
			}
		}

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

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			spr.alpha = 0;
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());

				trace("Story Mode Selected.");

			case 'freeplay':
				FlxG.sound.music.stop();
				FlxG.switchState(new FreeplayState());
	
				trace("Freeplay Menu Selected.");	

			case 'extras':
				FlxG.sound.music.stop();
				FlxG.switchState(new ExtraFreeplay());
	
				trace("Extra Freeplay Menu Selected.");	

			case 'options':
				FlxG.switchState(new OptionsMenu());

				trace("Options Menu Selected.");

			case 'credits':
				FlxG.switchState(new CreditsState());

				trace("Credits Menu Selected.");
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
		optionsStuff.screenCenter();
		optionsStuff.antialiasing = true;
	}

	function jumpscareTio()
	{
		tioJumpscare.visible = true;
		FlxG.sound.play(Paths.sound('glitch', 'piggy'), 1, true);
	
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			System.exit(0);
		});	
	}	

	function forceCamZoom()
    {
        FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.2, {ease: FlxEase.expoOut});
            
        new FlxTimer().start(0.15, function(tmr:FlxTimer)
        {
            FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {ease: FlxEase.expoOut});
        }); 
    }
}
