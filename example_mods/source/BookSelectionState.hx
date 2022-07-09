package;

// for game shutdown lololololololol
import flixel.input.keyboard.FlxKey;
import flash.system.System;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class BookSelectionState extends MusicBeatState
{
	// public static var isBook1:Bool = false;
	public static var isBook2:Bool = false;
	public static var preloadDisabled:Bool = false;

	// shitty fix for the mouse overlapping cuz it keeps repeating the scroll audio when the mouse is on the image
	// public static var dontRepeatAudio:Bool = false;

	var canMove:Bool = false;

	var bg:FlxSprite;
	var book1NS:FlxSprite;
	var book1S:FlxSprite;
	var book2NS:FlxSprite;
	var book2S:FlxSprite;

	var theCode:Array<Dynamic> = [
		[FlxKey.ONE], 
		[FlxKey.TWO], 
	    [FlxKey.NINE], 
	    [FlxKey.TWO], 
	    [FlxKey.TWO]
	];

	var theCodeOrder:Int = 0;

	// var loadingText:FlxText;

	override function create()
	{	
		// -- loading player data --
	/*
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}

		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
	*/
		FlxG.mouse.visible = true;

		// -- loading player data --


		// -- preloading sounds --
		
		FlxG.sound.cache(Paths.sound('locked', 'piggy'));

        // -- preloading sounds --


		// adding images

		bg = new FlxSprite().loadGraphic(Paths.image('bookSelection/bgScreen', 'piggy'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.alpha = 0;
		bg.y += 20;
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		book1NS = new FlxSprite().loadGraphic(Paths.image('bookSelection/bookOneNotSelected', 'piggy'));
		book1NS.antialiasing = true;
		book1NS.scrollFactor.set();
		book1NS.visible = true;
		book1NS.alpha = 0;
		book1NS.screenCenter(Y);
		book1NS.x += 130;
		book1NS.updateHitbox();
		add(book1NS);

		book1S = new FlxSprite().loadGraphic(Paths.image('bookSelection/bookOneSelected', 'piggy'));
		book1S.antialiasing = true;
		book1S.scrollFactor.set();
		book1S.visible = false;
		book1S.screenCenter(Y);
		book1S.x += 130;
		book1S.updateHitbox();
		add(book1S);

		book2NS = new FlxSprite().loadGraphic(Paths.image('bookSelection/bookTwoNotSelected', 'piggy'));
		book2NS.antialiasing = true;
		book2NS.scrollFactor.set();
		book2NS.visible = true;
		book2NS.alpha = 0;
		book2NS.screenCenter(Y);
		book2NS.x += 700;
		book2NS.updateHitbox();
		add(book2NS);

		book2S = new FlxSprite().loadGraphic(Paths.image('bookSelection/bookTwoSelected', 'piggy'));
		book2S.antialiasing = true;
		book2S.scrollFactor.set();
		book2S.visible = false;
		book2S.screenCenter(Y);
		book2S.x += 700;
		book2S.updateHitbox();
		add(book2S);

		// adding images


		var text:FlxText = new FlxText(12, FlxG.height - 104, 0, "FNF PIGGY BOOK 2 " + MainMenuState.fnfPiggyBook2Ver + " Early Build", 12);
		text.scrollFactor.set();
		text.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text);
		var text2:FlxText = new FlxText(12, FlxG.height - 84, 0, "Kade Engine " + MainMenuState.kadeEngineVer, 12);
		text2.scrollFactor.set();
		text2.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text2);
		var text3:FlxText = new FlxText(12, FlxG.height - 64, 0, "Friday Night Funkin' v" + MainMenuState.gameVer, 12);
		text3.scrollFactor.set();
		text3.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text3);
		var text4:FlxText = new FlxText(12, FlxG.height - 24, 0, "Press ESC to Close The Game.", 12);
		text4.scrollFactor.set();
		text4.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text4);

		// start the game
		startUp();

		super.create();
	}

	// function that is called to make everything appear when everything loads
	function startUp()
	{
		FlxTween.tween(bg, {alpha: 1}, 2);
		FlxTween.tween(book1NS, {alpha: 1}, 2);
		FlxTween.tween(book2NS, {alpha: 1}, 2);

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			canMove = true;
		});		
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.P)
			FlxG.switchState(new AntiPiracy());
		
		// stolen from https://github.com/alexlolxp/baldi-source/blob/main/source/MainMenuState.hx
		// ty <3
		if (FlxG.keys.justPressed.ANY)
		{
			var hitCorrectKey:Bool = false;

			for (i in 0...theCode[theCodeOrder].length)
			{
				if (FlxG.keys.checkStatus(theCode[theCodeOrder][i], JUST_PRESSED))
					hitCorrectKey = true;
			}
			if (hitCorrectKey)
			{
				if (theCodeOrder == (theCode.length - 1))
				{
					book1.PlayStateB1.SONG = Song.loadFromJson('wolfs-rage-hard', 'wolfs-rage');
					book1.PlayStateB1.isStoryMode = false;
					book1.PlayStateB1.storyDifficulty = 2;

					FlxG.switchState(new book1.PlayStateB1());
				}
				else
				{
					theCodeOrder++;
				}
			}
			else
			{
				theCodeOrder = 0;

				for (i in 0...theCode[0].length)
				{
					if (FlxG.keys.checkStatus(theCode[0][i], JUST_PRESSED))
						theCodeOrder = 1;
				}
			}

			if (theCodeOrder == 4)
				FlxG.sound.muteKeys = null;
			else
				FlxG.sound.muteKeys = [FlxKey.TWO];
		}


		if (FlxG.mouse.overlaps(book1NS))
		{			
			if (canMove)
			{
				book1S.visible = true;		
			}
		}
		else
		{
			if (canMove)
			{
				book1S.visible = false;					
			}	
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(book1S))
		{			
			if (preloadDisabled)
			{
				FlxG.save.data.curBook = 'book1';
				FlxG.save.flush();

				FlxG.mouse.visible = false;
				FlxG.switchState(new book1.MainMenuState());			
			}
			else
			{
				FlxG.save.data.curBook = 'book1';
				FlxG.save.flush();
				
				FlxG.mouse.visible = false;
				FlxG.switchState(new book1.CachingSelectionState());			
			}
		}

		if (FlxG.mouse.overlaps(book2NS))
		{			
			if (canMove)
			{
				book2S.visible = true;		
			}
		}
		else
		{
			if (canMove)
			{
				book2S.visible = false;					
			}	
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(book2S) && canMove)
		{			
			if (preloadDisabled)
			{
				FlxG.save.data.curBook = 'book2';
				FlxG.save.flush();

				FlxG.mouse.visible = false;
				FlxG.switchState(new MainMenuState());			
			}
			else
			{
				FlxG.save.data.curBook = 'book2';
				FlxG.save.flush();

				FlxG.mouse.visible = false;
				FlxG.switchState(new CachingSelectionState());			
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (canMove)
			{
				System.exit(0);				
			}
		}

		super.update(elapsed);
	}
}
