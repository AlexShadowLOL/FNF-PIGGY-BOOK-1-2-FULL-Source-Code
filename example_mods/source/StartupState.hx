package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class StartupState extends MusicBeatState
{
	var firstBoot:Bool = false;
	var isHTML5:Bool = false;

	override function create()
	{
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

		startGame();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function startGame()
	{
		#if html5
		isHTML5 = true;
		#end

		if (FlxG.save.data.cutscenes) 
		{
			var video:MP4Handler = new MP4Handler();
		
			video.playMP4(Paths.video('StartupCuts'));
			video.finishCallback = function()
			{
				#if sys
				if (!FileSystem.exists('index.html') || !FileSystem.exists('FNF Piggy Book 1 - 2.js') || !isHTML5)
					FlxG.switchState(new BookSelectionState());
				else
					FlxG.switchState(new AntiPiracy());
				#end
			} 	
		}
		else
		{
			#if sys
			if (!FileSystem.exists('index.html') || !FileSystem.exists('FNF Piggy Book 1 - 2.js') || !isHTML5)
				FlxG.switchState(new BookSelectionState());
			else
				FlxG.switchState(new AntiPiracy());
			#end
		}
	}
}