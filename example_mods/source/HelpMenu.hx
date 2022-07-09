package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

#if windows
import Discord.DiscordClient;
#end

class HelpMenu extends MusicBeatState
{
	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Seizure Warning Screen", null);
		#end

		FlxG.sound.playMusic(Paths.music('seizureTrack', 'piggy'), 0.65);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1', 'piggy'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var bgBlackOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0.6;
		add(bgBlackOverlay);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"FRECUENTLY ASKED QUESTIONS: "
			+ "\nHow Do You Unlock Rematch Remix Difficulty?:"
			+ "\nPlay Chapter 1 - 12 & Winter Holiday on Story Mode (Chapter Fun Doesn't Count)."
			+ "\n\nIs Book 2 Gonna Get Updated?:"
            + "\nBook 2 Is Gonna Get The Breakout Chapter Update And Then It Will Be No Longer Updated Anymore.",
			32);
		
		txt.setFormat("JackInput", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}
}
