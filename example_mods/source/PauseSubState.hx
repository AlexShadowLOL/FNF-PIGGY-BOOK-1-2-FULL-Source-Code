package;

import openfl.Lib;
#if windows
import llua.Lua;
#end
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flash.system.System;
class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [
		'Resume',
		'Restart Song',
		'Exit to menu',
		'Close Game'
	];

	var curSelected:Int = 0;
	var perSongOffset:FlxText;
	var offsetChanged:Bool = false;

	var pauseMusic:FlxSound;
	var pauseScreens:FlxSprite;

	// var practiceInfo:FlxText;

	var pauseScreensArray:Array<String> = [  
		'resume',     
		'restart',      
		'exit',          
		'close'         
	];

	public function new(x:Float, y:Float)
	{
		super();

		if (FlxG.save.data.curBook == 'book1')
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('piggyMenu', 'book1'), true, true);
		else
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('pauseMenu', 'piggy'), true, true);

		pauseMusic.volume = 0.5;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		// var practiceTxt:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pausemenu/practiceTxt', 'piggy'));
		// practiceTxt.setGraphicSize(FlxG.width, FlxG.height);
		// practiceTxt.scrollFactor.set();
		// add(practiceTxt);

		pauseScreens = new FlxSprite();

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);

		if (FlxG.save.data.curBook == 'book1')
			levelInfo.text += book1.PlayStateB1.SONG.song;
		else
			levelInfo.text += PlayState.SONG.song;

		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("JAi_____.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('JAi_____.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(pauseScreens, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		perSongOffset = new FlxText(5, FlxG.height - 18, 0, "Press O To Go To The Options Menu", 12);
		perSongOffset.scrollFactor.set();
		perSongOffset.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		perSongOffset.visible = true;
		add(perSongOffset);

		add(pauseScreens);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.visible = false;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var oldOffset:Float = 0;

		if (FlxG.save.data.curBook == 'book1')
			var songPath = 'assets/data/book1/' + book1.PlayStateB1.SONG.song.toLowerCase() + '/';
		else
		    var songPath = 'assets/data/book2/' + PlayState.SONG.song.toLowerCase() + '/';

		if (FlxG.keys.justPressed.O)
		{
		    Lib.application.window.title = "Friday Night Funkin': PIGGY BOOK 1 - 2";
			
			if (FlxG.save.data.curBook == 'book1')
			{
				book1.OptionsMenu.isPlayState = true;
				FlxG.switchState(new book1.OptionsMenu());
			}
			else
			{
				OptionsMenu.isPlayState = true;
				FlxG.switchState(new OptionsMenu());
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		else if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					if (FlxG.save.data.curBook == 'book1')
						trace("Resume Song: " + book1.PlayStateB1.SONG.song + " - " + CoolUtil.difficultyString());
					else
						trace("Resume Song: " + PlayState.SONG.song + " - " + CoolUtil.difficultyString());

					close();
				case "Restart Song":
					trace("restarting song...");
					FlxG.resetState();				
				case "Exit to menu":
				    Lib.application.window.title = "Friday Night Funkin': PIGGY BOOK 1 - 2";

					if (FlxG.save.data.curBook == 'book1')
					{ 
						if (book1.PlayStateB1.loadRep)
							{
								FlxG.save.data.botplay = false;
								FlxG.save.data.scrollSpeed = 1;
								FlxG.save.data.downscroll = false;
							}

							book1.PlayStateB1.loadRep = false;

							#if windows
							if (book1.PlayStateB1.luaModchart != null)
							{
								book1.PlayStateB1.luaModchart.die();
								book1.PlayStateB1.luaModchart = null;
							}
							#end

							if (book1.PlayStateB1.isPiracy)
								FlxG.switchState(new BookSelectionState());
							else
								FlxG.switchState(new book1.StoryMenuState());
					}
					else
					{
						if(PlayState.loadRep)
							{
								FlxG.save.data.botplay = false;
								FlxG.save.data.scrollSpeed = 1;
								FlxG.save.data.downscroll = false;
							}
							PlayState.loadRep = false;
							#if windows
							if (PlayState.luaModchart != null)
							{
								PlayState.luaModchart.die();
								PlayState.luaModchart = null;
							}
							#end
							
							if (PlayState.isStoryMode)
							{
								trace("STORY MODE!!");
								FlxG.switchState(new StoryMenuState());
							}
							else if (PlayState.isFreeplay)
							{
								trace("FREE PLAY!!");
								FlxG.switchState(new FreeplayState());
							}
							else if (PlayState.isFreeplayTwo)
							{
								trace("FREE PLAY!!");
								FlxG.switchState(new FreeplayPageTwo());
							}
							else if (PlayState.isFreeplay3)
							{
								FlxG.switchState(new DumbassFreeplay());
							}
							else if (PlayState.isExtraFreeplay)
							{
								FlxG.switchState(new ExtraFreeplay());
							}
							else if (PlayState.isAlmost)
							{
								FlxG.switchState(new FreeplayAlmost());
							}
					}

				case "Close Game":
					trace("clean game shutdown.. but you lost all your progress in this song, lmao!");
					System.exit(0);
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		var assetName2:String = pauseScreensArray[0];
		if(curSelected < pauseScreensArray.length) assetName2 = pauseScreensArray[curSelected];

		pauseScreens.loadGraphic(Paths.image('pausemenu/screen-' + assetName2, 'piggy'));
		pauseScreens.setGraphicSize(FlxG.width, FlxG.height);
		pauseScreens.antialiasing = true;
	}
}