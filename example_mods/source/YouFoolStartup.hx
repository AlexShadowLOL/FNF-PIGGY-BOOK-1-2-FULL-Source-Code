package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

// used on april fools
class YouFoolStartup extends MusicBeatState
{
    var txt:FlxText;

    override function create()
    {
        super.create();

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

        txt = new FlxText(0, 0, FlxG.width, "", 32);	
		txt.setFormat("JackInput", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
        txt.text = "Warning....";
        txt.alpha = 0;
		add(txt);

        // PlayState.isFelixCutscene = false;
        startTroll();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function startTroll()
    {
        FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'));

        new FlxTimer().start(0.7, function(tmr:FlxTimer)
        {
            FlxTween.tween(txt, {alpha: 1}, 2);
            shit();
        });
    }

    function shit()
    {
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            FlxTween.tween(txt, {alpha: 0}, 2);
            shit2();
        });
    }

    function shit2()
    {
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            finishTroll();
        });
    }

    function finishTroll()
    {
        txt.text = "You're Fat.";
        txt.color = FlxColor.RED;

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            txt.alpha = 1;
            finishNOW();
        });
    }

    function finishNOW()
    {
        new FlxTimer().start(0.6, function(tmr:FlxTimer)
        {
            FlxG.switchState(new BookSelectionState());
        });
    }
}