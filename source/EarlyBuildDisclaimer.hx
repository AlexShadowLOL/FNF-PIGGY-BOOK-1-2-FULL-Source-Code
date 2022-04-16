package;

import flixel.FlxG;
import flixel.FlxSprite;
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

class EarlyBuildDisclaimer extends MusicBeatState
{
	override function create()
	{
		super.create();
		
		var bgBlack:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bgBlack);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"DISCLAIMER: "
			+ "\nYou Are Currently Playing an Early Build of The Deluxe Update."
			+ "\nPlease be Aware That There May be Some Bugs Around."
			+ "\nIf u See ANY Bugs, Notify AlexShadow Imediately on His Twitter (@AlexDaShadow)."
			+ "\nThank You."
            + "\n\nPress Any Key to Continue.",
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
        super.update(elapsed);

		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new BookSelectionState());
		}
	}
}