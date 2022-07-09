package;

// for game shutdown lololololololol
import flash.system.System;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class HTMLFiveWarningState extends MusicBeatState
{
	override function create()
	{
		super.create();

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
			"WARNING: "
			+ "\nYou Are Currently Playing an HTML5/Browser Version\nOf The Mod\nWhich Was Uploaded Without My Permission!"
			+ "\nClose The Game Right Now and Go To Download The Mod on Gamebanana."
			+ "\n\nPress ANY KEY to Close The Game, and if It Doesn't Close.."
			+ "\nClose The Game by Yourself Dummy LOL",
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
		if (FlxG.keys.justPressed.ANY)
		{
			System.exit(0);
		}

		super.update(elapsed);
	}
}
